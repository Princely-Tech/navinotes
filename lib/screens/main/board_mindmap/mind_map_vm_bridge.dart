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

  // Zoom methods - delegate to bridge VM or provide defaults
  @override
  void zoomIn() {
    // Implement zoom in functionality or delegate to canvas
  }

  @override
  void zoomOut() {
    // Implement zoom out functionality or delegate to canvas
  }

  @override
  void resetZoom() {
    // Implement reset zoom functionality or delegate to canvas
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
  void openDrawer() {}

  @override
  void openEndDrawer() {}
}
