// vm.dart
import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:navinotes/models/mind_map.dart';
import 'package:navinotes/models/mind_map_edge.dart';
import 'package:navinotes/models/mind_map_node.dart';
import 'package:navinotes/models/content.dart';
import 'package:navinotes/settings/db_helpers.dart';
import 'package:navinotes/settings/enums.dart';
import 'package:navinotes/settings/navigation_helper.dart';
import 'package:navinotes/settings/routes.dart';
import 'package:open_file/open_file.dart';
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
  String title = 'Mind Map';

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
      final newMatrix = Matrix4.identity()
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
      final newMatrix = Matrix4.identity()
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
    node.position = _constrainPosition(node.position + (screenDelta / currentScale));
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
        NavigationHelper.navigateToFlashCardStudy(deck);
      }
      return;
    }

    // Default: content
    final content = await DatabaseHelper.instance.getContentById(id);
    if (content == null) return;

    if (content.type == AppContentType.file) {
      final filePath = content.file;
      if (filePath != null && filePath.isNotEmpty) {
        final lower = filePath.toLowerCase();
        if (lower.endsWith('.pdf')) {
          if (content.id != null) {
            await NavigationHelper.navigateToPdfView(content.id!);
          }
          return;
        }
        // Fallback: try to open with OS handler (images, docs, etc.)
        await OpenFile.open(filePath);
        return;
      }
    }

    if (content.type == AppContentType.note) {
      // TODO: Navigate directly to a specific note editor if available
      // For now, navigate to the board's notes screen
      final board = await content.getBoard();
      await NavigationHelper.navigateToBoardNotes(board);
      return;
    }

    if (content.type == AppContentType.mindmap) {
      // Open the mind map screen with this content id
      await NavigationHelper.push(
        Routes.mindMap,
        arguments: {'boardId': content.boardId, 'contentId': content.id},
      );
      return;
    }
  }

  // ---------- Persistence (DB) ----------
  /// Save (insert or update) the current mind map into the contents table.
  /// - If contentId is null, insert a new Content row.
  /// - Otherwise, update the existing row.
  Future<void> saveToDb({String? newTitle}) async {
    if (_isSaving) return; // guard re-entrancy
    _suppressAutoSave = true;
    _isSaving = true;
    try {
      title = newTitle ?? title;
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
            title: newTitle ?? existing.title,
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
    title = content.title;
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
    final x = position.dx.clamp(0.0, canvasWidth - 200.0); // Leave space for node width
    final y = position.dy.clamp(0.0, canvasHeight - 100.0); // Leave space for node height
    return Offset(x, y);
  }
}
