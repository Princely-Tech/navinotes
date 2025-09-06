// vm.dart
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:navinotes/models/mind_map.dart';
import 'package:navinotes/models/mind_map_edge.dart';
import 'package:navinotes/models/mind_map_node.dart';

class MindMapVm extends ChangeNotifier {
  final GlobalKey<ScaffoldState> scaffoldKey;

  MindMap mindMap;

  /// UI state
  String? selectedNodeId;
  String? selectedEdgeId;
  String? connectingFromNodeId;
  String? draggingNodeId;

  /// Canvas transform state (logical coordinates)
  Offset canvasOffset = Offset.zero;
  double scale = 1.0;

  /// Latest pointer in logical coordinates used for drawing temporary edge
  Offset? pointerLogical;

  MindMapVm({required this.scaffoldKey})
    : mindMap = MindMap(name: 'Untitled Mind Map');

  // Drawer helpers (kept for compatibility)
  void openDrawer() {
    scaffoldKey.currentState?.openDrawer();
  }

  void openEndDrawer() {
    scaffoldKey.currentState?.openEndDrawer();
  }

  // ---------- Mind map operations ----------
  MindMapNode addNodeAt({
    required String text,
    required Offset logicalPosition,
    Color color = Colors.blue,
  }) {
    final node = MindMapNode(
      text: text,
      position: logicalPosition,
      color: color,
    );
    mindMap.nodes.add(node);
    notifyListeners();
    return node;
  }

  void removeNode(String nodeId) {
    mindMap.removeNode(nodeId);
    if (selectedNodeId == nodeId) selectedNodeId = null;
    notifyListeners();
  }

  void updateNodePosition(String nodeId, Offset newLogicalPosition) {
    final node = mindMap.findNode(nodeId);
    if (node == null) return;
    node.position = newLogicalPosition;
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

  // ---------- Selection & connect flow ----------
  void selectNode(String? nodeId) {
    selectedNodeId = nodeId;
    if (nodeId != null) {
      selectedEdgeId = null; // deselect edges when node is selected
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

  void zoomIn() => setScale((scale * 1.2).clamp(0.2, 4.0));
  void zoomOut() => setScale((scale / 1.2).clamp(0.2, 4.0));
  void resetZoom() {
    scale = 1.0;
    canvasOffset = Offset.zero;
    notifyListeners();
  }

  /// Pan canvas by a logical delta. delta is in screen pixels; convert to logical by dividing scale.
  void panCanvasBy(Offset screenDelta) {
    canvasOffset += screenDelta / scale;
    notifyListeners();
  }

  /// Convert a visual/screen-local pointer into logical coordinates (the coordinate space of nodes).
  Offset visualToLogical(Offset visualLocal) =>
      visualLocal / scale - canvasOffset;

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
    node.position = node.position + (screenDelta / scale);
    notifyListeners();
  }

  /// End dragging
  void stopDraggingNode() {
    draggingNodeId = null;
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
      default:
        final vx2 = v.dx;
        final vy2 = v.dy;
        final sx = vx2 == 0 ? double.infinity : (halfW / vx2.abs());
        final sy = vy2 == 0 ? double.infinity : (halfH / vy2.abs());
        final t = sx < sy ? sx : sy;
        return center + v * t;
    }
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
    mindMap = MindMap.fromJson(json);
    selectedNodeId = null;
    selectedEdgeId = null;
    connectingFromNodeId = null;
    draggingNodeId = null;
    notifyListeners();
  }
}
