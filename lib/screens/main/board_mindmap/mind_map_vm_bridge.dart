import 'package:flutter/material.dart';
import 'package:navinotes/models/content.dart';
import 'package:navinotes/models/mind_map.dart';
import 'package:navinotes/models/mind_map_node.dart';
import 'package:navinotes/models/mind_map_edge.dart';
import 'package:navinotes/screens/main/board_mindmap/board_mindmap_vm.dart';
import 'package:navinotes/screens/main/choose_board/mind_map/vm.dart';
import 'package:navinotes/settings/board_theme.dart';
import 'package:navinotes/settings/enums.dart';

/// Bridge class that adapts BoardMindMapVm to work with existing MindMapVm interface
/// This allows us to reuse existing mind map widgets without major changes
class MindMapVmBridge extends MindMapVm {
  final BoardMindMapVm _boardVm;

  MindMapVmBridge(this._boardVm) 
    : super(scaffoldKey: GlobalKey<ScaffoldState>(), contentId: null);

  @override
  MindMap get mindMap => _boardVm.mindMap;

  @override
  String? get selectedNodeId => _boardVm.selectedNodeId;

  @override
  String? get selectedEdgeId => _boardVm.selectedEdgeId;

  @override
  String? get connectingFromNodeId => _boardVm.connectingFromNodeId;

  @override
  String? get draggingNodeId => _boardVm.draggingNodeId;

  @override
  bool get isDocumentPanelVisible => _boardVm.isDocumentPanelVisible;

  @override
  double get scale => _boardVm.scale;

  @override
  Offset? get pointerLogical => _boardVm.pointerLogical;

  @override
  BoardTheme get boardTheme => _boardVm.boardTheme;

  @override
  Content? get baseContent {
    // Create a dummy content with the board ID so MindMapDocuments can load contents
    return Content(
      id: 'board-${_boardVm.board.id}',
      title: _boardVm.board.name,
      boardId: _boardVm.board.id,
      type: AppContentType.mindmap,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      updatedAt: DateTime.now().millisecondsSinceEpoch,
      metaData: {},
    );
  }

  @override
  bool get isLoading => _boardVm.isLoading;

  /// Get the target view center for auto-centering on nodes
  Offset? get targetViewCenter => _boardVm.targetViewCenter;

  /// Clear the target view center after it's been applied
  void clearTargetViewCenter() => _boardVm.clearTargetViewCenter();

  /// Check if initial centering is needed
  bool get needsInitialCentering => _boardVm.needsInitialCentering;

  /// Center view on content
  void centerViewOnContent() => _boardVm.centerViewOnContent();

  /// Get content by ID
  Content? getContentById(String contentId) => _boardVm.getContentById(contentId);

  // Delegate methods to BoardMindMapVm
  @override
  MindMapNode addNodeWithContent({
    required String text,
    required Offset logicalPosition,
    required String contentId,
    Color? color,
  }) {
    return _boardVm.addNodeWithContent(
      text: text,
      logicalPosition: logicalPosition,
      contentId: contentId,
    );
  }

  @override
  MindMapEdge connectNodes(String sourceId, String targetId, {String? label}) {
    return _boardVm.connectNodes(
      sourceId: sourceId,
      targetId: targetId,
      label: label,
    );
  }

  @override
  void selectNode(String? nodeId) {
    _boardVm.selectNode(nodeId);
  }

  @override
  void selectEdge(String? edgeId) {
    _boardVm.selectEdge(edgeId);
  }

  @override
  void setScale(double newScale) {
    _boardVm.setScale(newScale);
  }

  @override
  void updatePointerFromVisual(Offset visualPosition) {
    _boardVm.updatePointerFromVisual(visualPosition);
  }

  @override
  bool trySelectEdgeAtVisual(Offset visualPosition) {
    return _boardVm.trySelectEdgeAtVisual(visualPosition);
  }

  @override
  void updateViewportInfo(Size viewportSize, TransformationController controller) {
    _boardVm.updateViewportInfo(viewportSize, controller);
  }

  @override
  void cancelConnecting() {
    _boardVm.cancelConnecting();
  }

  @override
  void startConnectingFrom(String nodeId) {
    _boardVm.startConnectingFrom(nodeId);
  }

  @override
  void finishConnecting(String targetNodeId) {
    _boardVm.finishConnecting(targetNodeId);
  }

  @override
  void updateNodeText(String nodeId, String newText) {
    _boardVm.updateNodeText(nodeId, newText);
  }

  @override
  Future<void> deleteNodeWithConfirmation(BuildContext context, String nodeId) {
    return _boardVm.deleteNodeWithConfirmation(context, nodeId);
  }

  @override
  Future<void> openAttachedContent(String nodeId) {
    return _boardVm.openAttachedContent(nodeId);
  }

  @override
  void removeAttachmentFromNode(String nodeId) {
    _boardVm.removeAttachmentFromNode(nodeId);
  }

  @override
  void startAttachToNode(String nodeId) {
    _boardVm.startAttachToNode(nodeId);
  }

  @override
  void openDrawer() {
    _boardVm.openDrawer();
  }

  // Dragging methods - delegate to BoardMindMapVm
  @override
  void startDraggingNode(String nodeId) {
    _boardVm.startDraggingNode(nodeId);
  }

  @override
  void dragNodeByGlobal(String nodeId, Offset globalPosition) {
    _boardVm.dragNodeByGlobal(nodeId, globalPosition);
  }

  @override
  void stopDraggingNode() {
    _boardVm.stopDraggingNode();
  }

  // Zoom methods - delegate to BoardMindMapVm
  @override
  void zoomIn() {
    _boardVm.zoomIn();
  }

  @override
  void zoomOut() {
    _boardVm.zoomOut();
  }

  @override
  void resetZoom() {
    _boardVm.resetZoom();
  }

  @override
  Offset getCurrentViewportCenter() {
    return _boardVm.getCurrentViewportCenter();
  }

  @override
  MindMapNode addNodeAt({
    required String text,
    required Offset logicalPosition,
    Color? color,
    String? contentID,
  }) {
    return _boardVm.addNode(
      text: text,
      position: logicalPosition,
      color: color ?? Colors.blue,
      contentId: contentID,
    );
  }

  // Methods that don't apply to board context
  @override
  String? get attachingNodeId => null;

  @override
  void attachContentToNodeById(String nodeId, String contentId) {
    // Not used in board context - content is automatically linked
  }

  @override
  void cancelAttachMode() {
    // Not used in board context
  }

  // Drawer methods - not used in board context
  @override
  void openEndDrawer() {}
}
