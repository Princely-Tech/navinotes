// vm.dart
import 'package:flutter/material.dart';
import 'package:navinotes/models/mind_map.dart';
import 'package:navinotes/models/mind_map_edge.dart';
import 'package:navinotes/models/mind_map_node.dart';

class MindMapVm extends ChangeNotifier {
  final GlobalKey<ScaffoldState> scaffoldKey;

  MindMap mindMap;

  /// UI state
  String? selectedNodeId;
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

  // ---------- Serialization ----------
  Map<String, dynamic> toJson() => mindMap.toJson();

  void loadFromJson(Map<String, dynamic> json) {
    mindMap = MindMap.fromJson(json);
    selectedNodeId = null;
    connectingFromNodeId = null;
    draggingNodeId = null;
    notifyListeners();
  }
}
