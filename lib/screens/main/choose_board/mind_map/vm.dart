// vm.dart
import 'dart:async';
import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:navinotes/models/mind_map.dart';
import 'package:navinotes/models/mind_map_edge.dart';
import 'package:navinotes/models/mind_map_node.dart';
import 'package:navinotes/models/content.dart';
import 'package:navinotes/settings/db_helpers.dart';
import 'package:navinotes/settings/enums.dart';
import 'package:navinotes/settings/file_utils.dart';
import 'package:navinotes/settings/navigation_helper.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:uuid/uuid.dart';

class MindMapVm extends ChangeNotifier {
  final GlobalKey<ScaffoldState> scaffoldKey;

  MindMap mindMap;

  /// Canvas dimensions
  static const double canvasWidth = 20000;
  static const double canvasHeight = 15000;

  /// UI state
  String? selectedNodeId;
  String? selectedEdgeId;
  String? connectingFromNodeId;
  String? draggingNodeId;
  // When not null, the next document/deck tapped in the sidebar will attach to this node
  String? attachingNodeId;
  // Document panel visibility (desktop only)
  bool isDocumentPanelVisible = true;

  /// Persistence state
  final int boardId;
  int? contentId; // row id in contents table for this mindmap
  Content? baseContent; // the content this mindmap is based on
  String title = "Mind Map";

  /// Canvas transform state (logical coordinates)
  double scale = 1.0;

  /// Latest pointer in logical coordinates used for drawing temporary edge
  Offset? pointerLogical;

  /// Autosave state
  Timer? _autoSaveTimer;
  final Duration autoSaveDelay = const Duration(seconds: 5);
  bool _suppressAutoSave = false; // used during load/save
  bool _isSaving = false;

  MindMapVm({required this.scaffoldKey, required this.boardId, this.contentId})
    : mindMap = MindMap(name: 'Untitled Mind Map') {
    // If a contentId is provided, load the saved mind map from DB
    if (contentId != null) {
      Future.microtask(() => loadFromDb(contentId!));
    }
    // Any change notification schedules a debounced autosave
    addListener(_onVmChanged);
  }

  // Drawer helpers (kept for compatibility)
  void openDrawer() {
    scaffoldKey.currentState?.openDrawer();
  }

  void openEndDrawer() {
    scaffoldKey.currentState?.openEndDrawer();
  }

  // Document panel toggle
  void toggleDocumentPanel() {
    isDocumentPanelVisible = !isDocumentPanelVisible;
    notifyListeners();
  }

  updateTitle(String newTitle) {
    if (newTitle.trim().isEmpty) return;
    title = newTitle;
    saveToDb();
    notifyListeners();
  }

  // ---------- Mind map operations ----------
  MindMapNode addNodeAt({
    required String text,
    required Offset logicalPosition,
    Color color = Colors.blue,
  }) {
    final node = MindMapNode(
      text: text,
      position: _constrainPosition(logicalPosition),
      color: color,
    );
    mindMap.nodes.add(node);
    notifyListeners();
    return node;
  }

  /// Create a new node with attached content at the specified position
  MindMapNode addNodeWithContent({
    required String text,
    required Offset logicalPosition,
    required int contentId,
    Color color = Colors.blue,
  }) {
    final node = MindMapNode(
      text: text,
      position: _constrainPosition(logicalPosition),
      color: color,
    );
    node.contentID = 'content:$contentId';
    mindMap.nodes.add(node);
    notifyListeners();
    return node;
  }

  /// Create a new node with attached deck at the specified position
  MindMapNode addNodeWithDeck({
    required String text,
    required Offset logicalPosition,
    required int deckId,
    Color color = Colors.blue,
  }) {
    final node = MindMapNode(
      text: text,
      position: _constrainPosition(logicalPosition),
      color: color,
    );
    node.contentID = 'deck:$deckId';
    mindMap.nodes.add(node);
    notifyListeners();
    return node;
  }

  void removeNode(String nodeId) {
    mindMap.removeNode(nodeId);
    if (selectedNodeId == nodeId) selectedNodeId = null;
    notifyListeners();
  }

  /// Delete a node with confirmation dialog
  Future<void> deleteNodeWithConfirmation(
    BuildContext context,
    String nodeId,
  ) async {
    final node = mindMap.findNode(nodeId);
    if (node == null) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Node'),
          content: Text(
            'Are you sure you want to delete "${node.text}"?\n\nThis action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      removeNode(nodeId);

      // Show success message
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Node "${node.text}" deleted'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }

  void updateNodePosition(String nodeId, Offset newLogicalPosition) {
    final node = mindMap.findNode(nodeId);
    if (node == null) return;
    node.position = _constrainPosition(newLogicalPosition);
    notifyListeners();
  }

  void updateNodeSize(String nodeId, double width, double height) {
    final node = mindMap.findNode(nodeId);
    if (node == null) return;
    node.width = width;
    node.height = height;
    notifyListeners();
  }

  void updateNodeText(String nodeId, String text) {
    final node = mindMap.findNode(nodeId);
    if (node == null) return;
    node.text = text;
    notifyListeners();
  }

  MindMapEdge connectNodes(String sourceId, String targetId, {String? label}) {
    // prevent self connect
    if (sourceId == targetId) throw Exception('Cannot connect node to itself');
    // prevent duplicate edge
    final exists = mindMap.edges.any(
      (e) =>
          (e.sourceId == sourceId && e.targetId == targetId) ||
          (e.sourceId == targetId && e.targetId == sourceId),
    );
    if (exists) {
      final existing = mindMap.edges.firstWhere(
        (e) =>
            (e.sourceId == sourceId && e.targetId == targetId) ||
            (e.sourceId == targetId && e.targetId == sourceId),
      );
      return existing;
    }
    final edge = mindMap.connectNodes(
      sourceId: sourceId,
      targetId: targetId,
      label: label,
    );
    notifyListeners();
    return edge;
  }

  void removeEdge(String edgeId) {
    mindMap.removeEdge(edgeId);
    notifyListeners();
  }

  Future<void> deleteEdgeWithConfirmation(
    BuildContext context,
    String edgeId,
  ) async {
    final edge = mindMap.findEdge(edgeId);
    if (edge == null) return;

    final sourceNode = mindMap.findNode(edge.sourceId);
    final targetNode = mindMap.findNode(edge.targetId);
    final edgeDescription =
        sourceNode != null && targetNode != null
            ? '"${sourceNode.text}" → "${targetNode.text}"'
            : 'this connection';

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Connection'),
          content: Text(
            'Are you sure you want to delete the connection $edgeDescription?\n\nThis action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      removeEdge(edgeId);
      selectedEdgeId = null; // Clear selection after deletion
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Connection $edgeDescription deleted'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }

  // ---------- Selection & connect flow ----------
  void selectNode(String? nodeId) {
    selectedNodeId = nodeId;
    if (nodeId != null) {
      selectedEdgeId = null; // deselect edges when node is selected
    }
    // if switching selection, exit attach mode
    if (attachingNodeId != null && attachingNodeId != nodeId) {
      attachingNodeId = null;
    }
    notifyListeners();
  }

  void selectEdge(String? edgeId) {
    selectedEdgeId = edgeId;
    if (edgeId != null) {
      selectedNodeId = null; // deselect nodes when edge is selected
    }
    notifyListeners();
  }

  // In vm.dart
  void startConnectingFrom(String nodeId) {
    connectingFromNodeId = nodeId;
    selectedNodeId = nodeId;
    notifyListeners();
  }

  void cancelConnecting() {
    connectingFromNodeId = null;
    notifyListeners();
  }

  void finishConnecting(String targetNodeId) {
    final sourceId = connectingFromNodeId;
    if (sourceId == null || sourceId == targetNodeId) {
      cancelConnecting();
      return;
    }

    connectNodes(sourceId, targetNodeId);
    cancelConnecting();
  }

  // ---------- Canvas pan/zoom & pointer handling ----------
  void setScale(double newScale) {
    if (newScale <= 0.1) return;
    scale = newScale;
    notifyListeners();
  }

  void zoomIn() {
    if (_transformationController != null) {
      final currentMatrix = _transformationController!.value;
      final currentScale = currentMatrix.getMaxScaleOnAxis();
      final newScale = (currentScale * 1.2).clamp(0.1, 4.0);

      // Get current translation to maintain position
      final translation = currentMatrix.getTranslation();

      // Create new matrix with updated scale but same translation
      final newMatrix =
          Matrix4.identity()
            ..translate(translation.x, translation.y)
            ..scale(newScale);

      _transformationController!.value = newMatrix;
      setScale(newScale);
    }
  }

  void zoomOut() {
    if (_transformationController != null) {
      final currentMatrix = _transformationController!.value;
      final currentScale = currentMatrix.getMaxScaleOnAxis();
      final newScale = (currentScale / 1.2).clamp(0.1, 4.0);

      // Get current translation to maintain position
      final translation = currentMatrix.getTranslation();

      // Create new matrix with updated scale but same translation
      final newMatrix =
          Matrix4.identity()
            ..translate(translation.x, translation.y)
            ..scale(newScale);

      _transformationController!.value = newMatrix;
      setScale(newScale);
    }
  }

  void resetZoom() {
    if (_transformationController != null) {
      _transformationController!.value = Matrix4.identity();
      setScale(1.0);
    } else {
      scale = 1.0;
      notifyListeners();
    }
  }

  /// Convert a visual/screen-local pointer into logical coordinates (the coordinate space of nodes).
  Offset visualToLogical(Offset visualLocal) => visualLocal / scale;

  /// Set latest pointer (in logical coords) — used by painting the temporary edge.
  void updatePointerFromVisual(Offset visualLocal) {
    pointerLogical = visualToLogical(visualLocal);
    notifyListeners();
  }

  // ---------- Dragging nodes ----------
  /// Start dragging (called from NodeWidget onPanStart)
  void startDraggingNode(String nodeId) {
    draggingNodeId = nodeId;
    // keep selected node as dragging node
    selectedNodeId = nodeId;
    selectedEdgeId = null;
    notifyListeners();
  }

  /// Move the dragging node by an incoming visual delta.
  void dragNodeBy(String nodeId, Offset screenDelta) {
    if (draggingNodeId != nodeId) return;
    final node = mindMap.findNode(nodeId);
    if (node == null) return;

    // Get the current scale from the transformation controller if available
    double currentScale = scale;
    if (_transformationController != null) {
      currentScale = _transformationController!.value.getMaxScaleOnAxis();
    }

    // Apply the screen delta divided by the current scale to get logical movement
    node.position = _constrainPosition(
      node.position + (screenDelta / currentScale),
    );
    notifyListeners();
  }

  /// Move the dragging node using global position for accurate tracking
  void dragNodeByGlobal(String nodeId, Offset globalPosition) {
    if (draggingNodeId != nodeId) return;
    final node = mindMap.findNode(nodeId);
    if (node == null) return;

    // Store the initial global position when dragging starts
    if (_dragStartGlobal == null) {
      _dragStartGlobal = globalPosition;
      _dragStartNodePosition = node.position;
      return;
    }

    // Calculate the delta from start position
    final globalDelta = globalPosition - _dragStartGlobal!;

    // Get current transformation matrix
    if (_transformationController != null) {
      final matrix = _transformationController!.value;
      final scale = matrix.getMaxScaleOnAxis();

      // Convert global delta to canvas coordinates
      final canvasDelta = globalDelta / scale;

      // Apply delta to original position
      node.position = _constrainPosition(_dragStartNodePosition! + canvasDelta);
      notifyListeners();
    }
  }

  /// End dragging
  void stopDraggingNode() {
    draggingNodeId = null;
    _dragStartGlobal = null;
    _dragStartNodePosition = null;
    notifyListeners();
  }

  // ---------- Styling: apply to selected node ----------
  MindMapNode? get _selectedNode =>
      selectedNodeId == null ? null : mindMap.findNode(selectedNodeId!);

  MindMapEdge? get _selectedEdge =>
      selectedEdgeId == null ? null : mindMap.findEdge(selectedEdgeId!);

  void updateSelectedNodeBackgroundColor(Color color) {
    final node = _selectedNode;
    if (node == null) return;
    node.color = color;
    notifyListeners();
  }

  void updateSelectedNodeTextColor(Color color) {
    final node = _selectedNode;
    if (node == null) return;
    node.textColor = color;
    notifyListeners();
  }

  void updateSelectedNodeFontSize(double size) {
    final node = _selectedNode;
    if (node == null) return;
    node.fontSize = size.clamp(8.0, 48.0);
    notifyListeners();
  }

  void updateSelectedNodeFontWeight(int weight) {
    final node = _selectedNode;
    if (node == null) return;
    node.fontWeight = weight;
    notifyListeners();
  }

  void updateSelectedNodeFontFamily(String? family) {
    final node = _selectedNode;
    if (node == null) return;
    node.fontFamily = family;
    notifyListeners();
  }

  void updateSelectedNodeOpacity(double opacity) {
    final node = _selectedNode;
    if (node == null) return;
    node.opacity = opacity.clamp(0.0, 1.0);
    notifyListeners();
  }

  /// colorTone is expected in -1..1 (negative=cooler, positive=warmer)
  void updateSelectedNodeColorTone(double tone) {
    final node = _selectedNode;
    if (node == null) return;
    node.colorTone = tone.clamp(-1.0, 1.0);
    notifyListeners();
  }

  void updateSelectedNodeBorderRadius(double radius) {
    final node = _selectedNode;
    if (node == null) return;
    node.borderRadius = radius.clamp(0.0, 1000.0);
    notifyListeners();
  }

  void updateSelectedNodeBorderStyle(MindMapBorderStyle style) {
    final node = _selectedNode;
    if (node == null) return;
    node.borderStyle = style;
    notifyListeners();
  }

  void updateSelectedNodeShape(MindMapShape shape) {
    final node = _selectedNode;
    if (node == null) return;
    node.shape = shape;
    // When switching to circle/pill we may want to adjust radius; leave radius as-is for rectangular shapes
    notifyListeners();
  }

  // ---------- Styling: edges ----------
  void updateSelectedEdgeColor(Color color) {
    final edge = _selectedEdge;
    if (edge == null) return;
    edge.color = color;
    notifyListeners();
  }

  void updateSelectedEdgeType(EdgeLineType type) {
    final edge = _selectedEdge;
    if (edge == null) return;
    edge.lineType = type;
    notifyListeners();
  }

  void updateSelectedEdgeThickness(double thickness) {
    final edge = _selectedEdge;
    if (edge == null) return;
    edge.thickness = thickness.clamp(0.5, 12.0);
    notifyListeners();
  }

  void updateSelectedEdgeOpacity(double opacity) {
    final edge = _selectedEdge;
    if (edge == null) return;
    edge.opacity = opacity.clamp(0.0, 1.0);
    notifyListeners();
  }

  // ---------- Edge hit testing ----------
  /// Try select an edge at a visual position. Returns true if an edge was selected.
  bool trySelectEdgeAtVisual(Offset visualLocal) {
    final logical = visualToLogical(visualLocal);
    final hitId = _hitTestEdge(logical);
    selectEdge(hitId);
    return hitId != null;
  }

  String? _hitTestEdge(Offset p) {
    const double tolerance = 8.0; // logical pixels
    String? closestId;
    double best = double.infinity;
    for (final e in mindMap.edges) {
      final endpoints = _edgeEndpoints(e);
      final type = e.lineType;
      double d;
      if (type == EdgeLineType.elbow) {
        final mid = Offset(endpoints.$1.dx, endpoints.$2.dy);
        d = _distanceToSegment(p, endpoints.$1, mid).clamp(0, double.infinity);
        d = math.min(d, _distanceToSegment(p, mid, endpoints.$2));
      } else if (type == EdgeLineType.curved) {
        d = _distanceToQuadraticApprox(
          p,
          endpoints.$1,
          (endpoints.$1 + endpoints.$2) / 2 + const Offset(0, -40),
          endpoints.$2,
        );
      } else {
        d = _distanceToSegment(p, endpoints.$1, endpoints.$2);
      }
      if (d < best && d <= tolerance) {
        best = d;
        closestId = e.id;
      }
    }
    return closestId;
  }

  (Offset, Offset) _edgeEndpoints(MindMapEdge edge) {
    final s = mindMap.findNode(edge.sourceId)!;
    final t = mindMap.findNode(edge.targetId)!;
    final c1 = _nodeCenter(s);
    final c2 = _nodeCenter(t);
    return (_edgePoint(s, c2), _edgePoint(t, c1));
  }

  Offset _nodeCenter(MindMapNode node) => Offset(
    node.position.dx + node.width / 2,
    node.position.dy + node.height / 2,
  );

  Offset _edgePoint(MindMapNode node, Offset towards) {
    final cx = node.position.dx + node.width / 2;
    final cy = node.position.dy + node.height / 2;
    final center = Offset(cx, cy);
    final v = towards - center;
    if (v == Offset.zero) return center;
    final halfW = node.width / 2;
    final halfH = node.height / 2;

    switch (node.shape) {
      case MindMapShape.circle:
        final len = v.distance;
        if (len == 0) return center;
        final radius = halfW < halfH ? halfW : halfH;
        final dir = v / len;
        return center + dir * radius;

      case MindMapShape.diamond:
        final vx = v.dx.abs();
        final vy = v.dy.abs();
        final denom = (vx / halfW) + (vy / halfH);
        if (denom == 0) return center;
        final t = 1 / denom;
        return center + v * t;

      case MindMapShape.hexagon:
        return _hexagonEdgePoint(center, halfW, halfH, v);

      case MindMapShape.octagon:
        return _octagonEdgePoint(center, halfW, halfH, v);

      case MindMapShape.parallelogram:
        return _parallelogramEdgePoint(center, halfW, halfH, v);

      case MindMapShape.trapezoid:
        return _trapezoidEdgePoint(center, halfW, halfH, v);

      case MindMapShape.pill:
        return _pillEdgePoint(center, halfW, halfH, v);

      default:
        // Rectangle and rounded rectangle
        final vx2 = v.dx;
        final vy2 = v.dy;
        final sx = vx2 == 0 ? double.infinity : (halfW / vx2.abs());
        final sy = vy2 == 0 ? double.infinity : (halfH / vy2.abs());
        final t = sx < sy ? sx : sy;
        return center + v * t;
    }
  }

  Offset _hexagonEdgePoint(
    Offset center,
    double halfW,
    double halfH,
    Offset v,
  ) {
    // Hexagon vertices (flat top)
    final vertices = <Offset>[
      Offset(halfW, 0), // Right
      Offset(halfW * 0.5, halfH), // Bottom right
      Offset(-halfW * 0.5, halfH), // Bottom left
      Offset(-halfW, 0), // Left
      Offset(-halfW * 0.5, -halfH), // Top left
      Offset(halfW * 0.5, -halfH), // Top right
    ];

    return _polygonEdgeIntersection(center, vertices, v);
  }

  Offset _octagonEdgePoint(
    Offset center,
    double halfW,
    double halfH,
    Offset v,
  ) {
    // Octagon vertices
    final cut = 0.3; // How much to cut the corners
    final vertices = <Offset>[
      Offset(halfW, halfH * cut), // Right top
      Offset(halfW * cut, halfH), // Top right
      Offset(-halfW * cut, halfH), // Top left
      Offset(-halfW, halfH * cut), // Left top
      Offset(-halfW, -halfH * cut), // Left bottom
      Offset(-halfW * cut, -halfH), // Bottom left
      Offset(halfW * cut, -halfH), // Bottom right
      Offset(halfW, -halfH * cut), // Right bottom
    ];

    return _polygonEdgeIntersection(center, vertices, v);
  }

  Offset _parallelogramEdgePoint(
    Offset center,
    double halfW,
    double halfH,
    Offset v,
  ) {
    // Parallelogram with skewed sides (clockwise from top-right)
    final skew = halfW * 0.25; // Reduced skew factor for better proportions
    final vertices = <Offset>[
      Offset(halfW - skew, -halfH), // Top right
      Offset(halfW + skew, halfH), // Bottom right
      Offset(-halfW + skew, halfH), // Bottom left
      Offset(-halfW - skew, -halfH), // Top left
    ];

    return _polygonEdgeIntersection(center, vertices, v);
  }

  Offset _trapezoidEdgePoint(
    Offset center,
    double halfW,
    double halfH,
    Offset v,
  ) {
    // Trapezoid (wider at bottom, clockwise from top-right)
    final topWidth = halfW * 0.65; // Slightly wider top for better proportions
    final vertices = <Offset>[
      Offset(topWidth, -halfH), // Top right
      Offset(halfW, halfH), // Bottom right
      Offset(-halfW, halfH), // Bottom left
      Offset(-topWidth, -halfH), // Top left
    ];

    return _polygonEdgeIntersection(center, vertices, v);
  }

  Offset _pillEdgePoint(Offset center, double halfW, double halfH, Offset v) {
    // Pill shape (rectangle with semicircular ends)
    if (halfW > halfH) {
      // Horizontal pill
      final rectWidth = halfW - halfH;
      if (v.dx.abs() > rectWidth) {
        // Hit the circular ends
        final circleCenter =
            v.dx > 0 ? Offset(rectWidth, 0) : Offset(-rectWidth, 0);
        final toCircle = v - circleCenter;
        final len = toCircle.distance;
        if (len == 0) return center + circleCenter;
        return center + circleCenter + (toCircle / len) * halfH;
      } else {
        // Hit the straight sides
        final t = halfH / v.dy.abs();
        return center + v * t;
      }
    } else {
      // Vertical pill
      final rectHeight = halfH - halfW;
      if (v.dy.abs() > rectHeight) {
        // Hit the circular ends
        final circleCenter =
            v.dy > 0 ? Offset(0, rectHeight) : Offset(0, -rectHeight);
        final toCircle = v - circleCenter;
        final len = toCircle.distance;
        if (len == 0) return center + circleCenter;
        return center + circleCenter + (toCircle / len) * halfW;
      } else {
        // Hit the straight sides
        final t = halfW / v.dx.abs();
        return center + v * t;
      }
    }
  }

  Offset _polygonEdgeIntersection(
    Offset center,
    List<Offset> vertices,
    Offset v,
  ) {
    // Find intersection of ray from center in direction v with polygon edges
    double closestT = double.infinity;

    for (int i = 0; i < vertices.length; i++) {
      final p1 = vertices[i];
      final p2 = vertices[(i + 1) % vertices.length];

      // Ray-line segment intersection
      final edge = p2 - p1;
      final toStart = p1;

      final cross = v.dx * edge.dy - v.dy * edge.dx;
      if (cross.abs() < 1e-10) continue; // Parallel

      final t1 = (toStart.dx * edge.dy - toStart.dy * edge.dx) / cross;
      final t2 = (toStart.dx * v.dy - toStart.dy * v.dx) / cross;

      if (t1 > 0 && t2 >= 0 && t2 <= 1 && t1 < closestT) {
        closestT = t1;
      }
    }

    if (closestT == double.infinity) {
      // Fallback to rectangular intersection
      final vx = v.dx;
      final vy = v.dy;
      final sx = vx == 0 ? double.infinity : (vertices[0].dx.abs() / vx.abs());
      final sy = vy == 0 ? double.infinity : (vertices[0].dy.abs() / vy.abs());
      final t = sx < sy ? sx : sy;
      return center + v * t;
    }

    return center + v * closestT;
  }

  double _distanceToSegment(Offset p, Offset a, Offset b) {
    final ab = b - a;
    final ap = p - a;
    final ab2 = ab.dx * ab.dx + ab.dy * ab.dy;
    if (ab2 == 0) return (p - a).distance;
    final t = ((ap.dx * ab.dx + ap.dy * ab.dy) / ab2).clamp(0.0, 1.0);
    final proj = Offset(a.dx + ab.dx * t, a.dy + ab.dy * t);
    return (p - proj).distance;
  }

  double _distanceToQuadraticApprox(Offset p, Offset a, Offset c, Offset b) {
    // Sample the quadratic curve and take min distance
    double best = double.infinity;
    const int steps = 24;
    Offset prev = a;
    for (int i = 1; i <= steps; i++) {
      final t = i / steps;
      final q = _quadraticPoint(a, c, b, t);
      final d = _distanceToSegment(p, prev, q);
      if (d < best) best = d;
      prev = q;
    }
    return best;
  }

  Offset _quadraticPoint(Offset a, Offset c, Offset b, double t) {
    final mt = 1 - t;
    return a * (mt * mt) + c * (2 * mt * t) + b * (t * t);
  }

  // ---------- Serialization ----------
  Map<String, dynamic> toJson() => mindMap.toJson();

  void loadFromJson(Map<String, dynamic> json) {
    _suppressAutoSave = true;
    try {
      mindMap = MindMap.fromJson(json);
      selectedNodeId = null;
      selectedEdgeId = null;
      connectingFromNodeId = null;
      draggingNodeId = null;
      notifyListeners();
    } finally {
      _suppressAutoSave = false;
    }
  }

  // ---------- Attachments (Content <-> Node) ----------
  // ---- Attach mode control ----
  void startAttachToNode(String nodeId) {
    attachingNodeId = nodeId;
    notifyListeners();
  }

  void cancelAttachMode() {
    if (attachingNodeId != null) {
      attachingNodeId = null;
      notifyListeners();
    }
  }

  bool isAttachModeFor(String nodeId) => attachingNodeId == nodeId;

  void attachContentToNodeById(String nodeId, int contentId) {
    final node = mindMap.findNode(nodeId);
    if (node == null) return;
    node.contentID = 'content:$contentId';
    // exit attach mode after attaching
    attachingNodeId = null;
    notifyListeners();
  }

  void attachDeckToNodeById(String nodeId, int deckId) {
    final node = mindMap.findNode(nodeId);
    if (node == null) return;
    node.contentID = 'deck:$deckId';
    // exit attach mode after attaching
    attachingNodeId = null;
    notifyListeners();
  }

  void removeAttachmentFromNode(String nodeId) {
    final node = mindMap.findNode(nodeId);
    if (node == null) return;
    node.contentID = null;
    notifyListeners();
  }

  (String type, int? id)? _parseAttachment(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    if (raw.contains(':')) {
      final parts = raw.split(':');
      if (parts.length == 2) {
        final id = int.tryParse(parts[1]);
        return (parts[0], id);
      }
      return null;
    }
    // Backward compatibility: plain numeric means content
    final legacyId = int.tryParse(raw);
    return ('content', legacyId);
  }

  Future<Content?> getAttachedContent(String nodeId) async {
    final node = mindMap.findNode(nodeId);
    if (node == null) return null;
    final parsed = _parseAttachment(node.contentID);
    if (parsed == null) return null;
    if (parsed.$1 != 'content') return null;
    final id = parsed.$2;
    if (id == null) return null;
    final helper = DatabaseHelper.instance;
    return await helper.getContentById(id);
  }

  Future<void> openAttachedContent(String nodeId) async {
    final node = mindMap.findNode(nodeId);
    if (node == null) return;
    final parsed = _parseAttachment(node.contentID);
    if (parsed == null) return;
    final type = parsed.$1;
    final id = parsed.$2;
    if (id == null) return;

    if (type == 'deck') {
      final deck = await DatabaseHelper.instance.getDeck(id);
      if (deck != null) {
        NavigationHelper.navigateToDeck(deck);
      }
      return;
    }

    // Default: content
    final content = await DatabaseHelper.instance.getContentById(id);
    if (content == null) return;
    NavigationHelper.navigateToContent(content);
  }

  // ---------- Persistence (DB) ----------
  /// Save (insert or update) the current mind map into the contents table.
  /// - If contentId is null, insert a new Content row.
  /// - Otherwise, update the existing row.
  Future<void> saveToDb() async {
    if (_isSaving) return; // guard re-entrancy
    _suppressAutoSave = true;
    _isSaving = true;
    try {
      final meta = toJson();
      final now = DateTime.now().millisecondsSinceEpoch;
      final helper = DatabaseHelper.instance;

      if (contentId == null) {
        final content = Content(
          guid: const Uuid().v4(),
          title: title,
          type: AppContentType.mindmap,
          metaData: meta,
          boardId: boardId,
          createdAt: now,
          updatedAt: now,
          tags: null,
          content: null,
          drawing: null,
          file: null,
        );
        final id = await helper.insertContent(content);
        contentId = id;
        debugPrint('Content inserted with id: $id');
      } else {
        final existing = await helper.getContentById(contentId!);
        if (existing != null) {
          final updated = Content(
            id: existing.id,
            guid: existing.guid,
            title: title,
            voiceNotes: existing.voiceNotes,
            coverImage: existing.coverImage,
            type: existing.type,
            metaData: meta,
            boardId: existing.boardId,
            tags: existing.tags,
            content: existing.content,
            drawing: existing.drawing,
            file: existing.file,
            createdAt: existing.createdAt,
            updatedAt: now,
            syncedAt: existing.syncedAt,
            coverImageNeedSync: existing.coverImageNeedSync,
            fileNeedSync: existing.fileNeedSync,
          );
          await helper.updateContent(updated);
          debugPrint('Content updated with id: $contentId');
        }
      }
      // No notifyListeners here; UI usually doesn't need to change after save
    } finally {
      _isSaving = false;
      _suppressAutoSave = false;
    }
  }

  /// Load a mind map from DB by contentId (row id) and set internal state.
  Future<void> loadFromDb(int id) async {
    final helper = DatabaseHelper.instance;
    final content = await helper.getContentById(id);
    if (content == null) return;
    if (content.type != AppContentType.mindmap) return;
    contentId = content.id;
    baseContent = content;
    title = content.title;
    debugPrint('Loaded mind map with title: $title');
    // meta_data contains our map
    final meta = content.metaData;
    loadFromJson(meta);

    // Validate that all nodes are within canvas bounds
    validateNodeBounds();
  }

  // ---------- Autosave internals ----------
  void _onVmChanged() {
    if (_suppressAutoSave || _isSaving) return;
    _autoSaveTimer?.cancel();
    _autoSaveTimer = Timer(autoSaveDelay, () async {
      // Timer fired after inactivity
      await saveToDb();
    });
  }

  @override
  void dispose() {
    removeListener(_onVmChanged);
    _autoSaveTimer?.cancel();
    super.dispose();
  }

  /// Validate and fix positions of all existing nodes to ensure they're within canvas bounds
  void validateNodeBounds() {
    bool hasChanges = false;
    for (final node in mindMap.nodes) {
      final constrainedPosition = Offset(
        node.position.dx.clamp(
          0.0,
          canvasWidth - 200.0,
        ), // Leave space for node width
        node.position.dy.clamp(
          0.0,
          canvasHeight - 100.0,
        ), // Leave space for node height
      );
      if (constrainedPosition != node.position) {
        node.position = constrainedPosition;
        hasChanges = true;
      }
    }
    if (hasChanges) {
      notifyListeners();
    }
  }

  /// Get the center position of the currently visible viewport
  Offset getViewportCenter(Size viewportSize) {
    return Offset(viewportSize.width / 2, viewportSize.height / 2);
  }

  /// Current viewport information
  Size? _viewportSize;
  TransformationController? _transformationController;

  /// Drag tracking for accurate node movement
  Offset? _dragStartGlobal;
  Offset? _dragStartNodePosition;

  /// Update viewport information from the canvas
  void updateViewportInfo(
    Size viewportSize,
    TransformationController controller,
  ) {
    _viewportSize = viewportSize;
    _transformationController = controller;
  }

  /// Get the center of the currently visible area in canvas coordinates
  Offset getCurrentViewportCenter() {
    if (_viewportSize == null || _transformationController == null) {
      // Fallback to canvas center if no viewport info
      return Offset(canvasWidth / 2, canvasHeight / 2);
    }

    final matrix = _transformationController!.value;
    final translation = matrix.getTranslation();
    final scale = matrix.getMaxScaleOnAxis();

    // Calculate the center of the visible viewport in canvas coordinates
    final viewportCenterX = _viewportSize!.width / 2;
    final viewportCenterY = _viewportSize!.height / 2;

    // Convert viewport center to canvas coordinates
    final canvasCenterX = (viewportCenterX - translation.x) / scale;
    final canvasCenterY = (viewportCenterY - translation.y) / scale;

    return Offset(canvasCenterX, canvasCenterY);
  }

  /// Constrain position to stay within canvas boundaries
  Offset _constrainPosition(Offset position) {
    final x = position.dx.clamp(
      0.0,
      canvasWidth - 200.0,
    ); // Leave space for node width
    final y = position.dy.clamp(
      0.0,
      canvasHeight - 100.0,
    ); // Leave space for node height
    return Offset(x, y);
  }

  /// Export mind map as PDF by converting PNG to PDF
  Future<void> exportAsPdf(BuildContext context) async {
    final byteData = await exportAsByteData();
    if (byteData == null) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Failed to export PDF')));
      }
      return;
    }

    final pdf = pw.Document();
    final pngImage = pw.MemoryImage(byteData.buffer.asUint8List());

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4.landscape,
        build: (pw.Context context) {
          return pw.Center(child: pw.Image(pngImage, fit: pw.BoxFit.contain));
        },
      ),
    );

    // Save PDF
    final output = await getApplicationDocumentsDirectory();
    final file = File(
      '${output.path}/mindmap_${DateTime.now().millisecondsSinceEpoch}.pdf',
    );
    await file.writeAsBytes(await pdf.save());

    await handleFileSharing(
      file,
      context: context,
      successMessage: 'PDF exported.',
      errorMessage: 'Failed to export PDF',
    );
    // delete the original file
    if (file.existsSync()) {
      await file.delete();
    }
  }

  /// Export mind map as PNG
  Future<void> exportAsPng(BuildContext context) async {
    final byteData = await exportAsByteData();

    if (byteData == null) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Failed to export PNG')));
      }
      return;
    }
    // Save PNG
    final output = await getApplicationDocumentsDirectory();
    final file = File(
      '${output.path}/mindmap_${DateTime.now().millisecondsSinceEpoch}.png',
    );
    await file.writeAsBytes(byteData.buffer.asUint8List());

    await handleFileSharing(
      file,
      context: context,
      successMessage: 'PNG exported.',
      errorMessage: 'Failed to export PNG',
    );
    // delete the original file
    if (file.existsSync()) {
      await file.delete();
    }
  }

  /// Export mind map as PNG
  Future<ByteData?> exportAsByteData() async {
    try {
      // Calculate bounds
      final bounds = _calculateMindMapBounds();

      // Handle empty mind map
      if (bounds == Rect.zero) {
        if (scaffoldKey.currentContext != null) {
          ScaffoldMessenger.of(
            scaffoldKey.currentContext!,
          ).showSnackBar(const SnackBar(content: Text('No nodes to export')));
        }
        return null;
      }

      // Create a custom painter to render the mind map
      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder);
      final size = Size(bounds.width + 100, bounds.height + 100);

      // Draw white background
      canvas.drawRect(
        Rect.fromLTWH(0, 0, size.width, size.height),
        Paint()..color = Colors.white,
      );

      // Draw mind map
      _drawMindMapToCanvas(canvas, bounds);

      // Convert to image
      final picture = recorder.endRecording();
      final image = await picture.toImage(
        size.width.toInt(),
        size.height.toInt(),
      );
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);

      return byteData;
    } catch (e) {
      print('Error exporting PNG: $e');
      return null;
    }
  }

  /// Calculate bounding rectangle of all nodes
  Rect _calculateMindMapBounds() {
    if (mindMap.nodes.isEmpty) return Rect.zero;

    double minX = double.infinity;
    double minY = double.infinity;
    double maxX = double.negativeInfinity;
    double maxY = double.negativeInfinity;

    for (final node in mindMap.nodes) {
      minX = math.min(minX, node.position.dx);
      minY = math.min(minY, node.position.dy);
      maxX = math.max(maxX, node.position.dx + node.width);
      maxY = math.max(maxY, node.position.dy + node.height);
    }

    return Rect.fromLTRB(minX - 50, minY - 50, maxX + 50, maxY + 50);
  }

  /// Draw mind map to Flutter canvas
  void _drawMindMapToCanvas(Canvas canvas, Rect bounds) {
    // Draw edges first
    for (final edge in mindMap.edges) {
      final fromNode = mindMap.findNode(edge.sourceId);
      final toNode = mindMap.findNode(edge.targetId);
      if (fromNode != null && toNode != null) {
        final fromCenter = Offset(
          fromNode.position.dx + fromNode.width / 2 - bounds.left + 50,
          fromNode.position.dy + fromNode.height / 2 - bounds.top + 50,
        );
        final toCenter = Offset(
          toNode.position.dx + toNode.width / 2 - bounds.left + 50,
          toNode.position.dy + toNode.height / 2 - bounds.top + 50,
        );

        canvas.drawLine(
          fromCenter,
          toCenter,
          Paint()
            ..color = Colors.grey[600]!
            ..strokeWidth = 2,
        );
      }
    }

    // Draw nodes
    for (final node in mindMap.nodes) {
      final rect = Rect.fromLTWH(
        node.position.dx - bounds.left + 50,
        node.position.dy - bounds.top + 50,
        node.width,
        node.height,
      );

      // Draw node background
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, Radius.circular(node.borderRadius)),
        Paint()..color = node.color.withOpacity(node.opacity),
      );

      // Draw node border
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, Radius.circular(node.borderRadius)),
        Paint()
          ..color = Colors.black
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1,
      );

      // Draw text
      final textPainter = TextPainter(
        text: TextSpan(
          text: node.text,
          style: TextStyle(
            color: node.textColor,
            fontSize: node.fontSize,
            fontWeight: FontWeight.values[node.fontWeight ~/ 100 - 1],
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout(maxWidth: node.width - 16);
      textPainter.paint(
        canvas,
        Offset(
          rect.left + 8,
          rect.top + (rect.height - textPainter.height) / 2,
        ),
      );
    }
  }
}
