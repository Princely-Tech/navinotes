import 'package:flutter/material.dart';
import 'package:navinotes/models/board.dart';
import 'package:navinotes/models/content.dart';
import 'package:navinotes/models/mind_map.dart';
import 'package:navinotes/models/mind_map_node.dart';
import 'package:navinotes/models/mind_map_edge.dart';
import 'package:navinotes/settings/board_theme.dart';
import 'package:navinotes/settings/db_helpers.dart';
import 'package:navinotes/settings/enums.dart';
import 'package:navinotes/settings/navigation_helper.dart';
import 'package:navinotes/settings/packages.dart';
import 'dart:math' as math;

class BoardMindMapVm extends ChangeNotifier {
  Board board; // Make it mutable so we can update it with the latest mind map

  bool _isLoading = true;
  bool _isDocumentPanelVisible = true;

  // Mind Map State
  MindMap _mindMap;
  String? _selectedNodeId;
  String? _selectedEdgeId;
  String? _connectingFromNodeId;
  String? _draggingNodeId;

  // Canvas transform state
  double scale = 1.0;
  Offset? pointerLogical;

  // Dragging state
  Offset? _dragStartGlobal;
  Offset? _dragStartNodePosition;
  Size? _viewportSize;
  TransformationController? _transformationController;

  // Content state
  List<Content> _contents = [];

  // Getters
  bool get isLoading => _isLoading;
  bool get isDocumentPanelVisible => _isDocumentPanelVisible;
  MindMap get mindMap => _mindMap;
  List<Content> get contents => _contents;
  String? get selectedNodeId => _selectedNodeId;
  String? get selectedEdgeId => _selectedEdgeId;
  String? get connectingFromNodeId => _connectingFromNodeId;
  String? get draggingNodeId => _draggingNodeId;

  BoardTheme get boardTheme {
    final boardType = board.boardType ?? BoardTypeCodes.plain;
    switch (boardType) {
      case BoardTypeCodes.plain:
        return BoardTheme.plain;
      case BoardTypeCodes.minimalist:
        return BoardTheme.minimalist;
      case BoardTypeCodes.darkAcademia:
        return BoardTheme.darkAcademia;
      case BoardTypeCodes.lightAcademia:
        return BoardTheme.lightAcademia;
      case BoardTypeCodes.nature:
        return BoardTheme.nature;
    }
  }

  BoardMindMapVm({required this.board})
    : _mindMap = board.getOrCreateMindMap() {
    debugPrint(
      'BoardMindMapVm: Constructor - loaded mind map with ${board.getOrCreateMindMap().nodes.length} nodes',
    );
    debugPrint(
      'BoardMindMapVm: Board mind map data: ${board.mindMap != null ? "exists" : "null"}',
    );
    _initialize();
  }

  Future<void> _initialize() async {
    debugPrint('BoardMindMapVm: Starting initialization for board ${board.id}');

    try {
      // Load board contents
      debugPrint('BoardMindMapVm: Loading contents for board ${board.id}');
      _contents = await DatabaseHelper.instance.getAllContents(board.id);
      debugPrint('BoardMindMapVm: Loaded ${_contents.length} contents');

      // Initialize mind map with existing content nodes if mind map is empty
      if (_mindMap.nodes.isEmpty && _contents.isNotEmpty) {
        debugPrint(
          'BoardMindMapVm: Initializing mind map with ${_contents.length} content items',
        );
        await _initializeMindMapWithContent();
      } else {
        debugPrint(
          'BoardMindMapVm: Mind map already has ${_mindMap.nodes.length} nodes',
        );
      }

      debugPrint('BoardMindMapVm: Initialization completed successfully');
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      debugPrint('Error initializing BoardMindMapVm: $e');
      debugPrint('Stack trace: ${StackTrace.current}');
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Initialize mind map with all content as nodes
  Future<void> _initializeMindMapWithContent() async {
    try {
      debugPrint(
        'BoardMindMapVm: Initializing mind map with ${_contents.length} content items as nodes',
      );

      // Create a fresh mind map and populate it from all content
      final currentMindMap = MindMap(name: '${board.name} Mind Map');

      int nodesWithPositions = 0;
      int nodesNeedingPositions = 0;

      // Convert all content to mind map nodes
      for (final content in _contents) {
        // Check if content already has mind map position
        Offset position;
        if (content.mindMapPosition != null) {
          position = content.mindMapPosition!;
          nodesWithPositions++;
          debugPrint(
            'BoardMindMapVm: Content ${content.id} (${content.title}) already has position ${position}',
          );
        } else {
          // Generate new position for content without mind map data
          position = _generateNodePosition(currentMindMap.nodes.length);
          nodesNeedingPositions++;

          // Update content with new mind map position
          final color = _getNodeColorForContentType(content.type);
          final updatedContent = content.getUpdatedContent(
            mindMapX: position.dx,
            mindMapY: position.dy,
            nodeColor: '#${color.value.toRadixString(16).padLeft(8, '0')}',
            nodeWidth: 200.0,
            nodeHeight: 100.0,
            connectedContentIds: '[]',
            updatedAt: DateTime.now().millisecondsSinceEpoch,
          );

          // Save updated content to database
          await DatabaseHelper.instance.updateContent(updatedContent);

          // Update in local list
          final index = _contents.indexWhere((c) => c.id == content.id);
          if (index != -1) {
            _contents[index] = updatedContent;
          }

          debugPrint(
            'BoardMindMapVm: Generated position ${position} for content ${content.id} (${content.title})',
          );
        }

        // Create mind map node from content
        final node = _createNodeFromContent(
          _contents.firstWhere((c) => c.id == content.id),
        );
        currentMindMap.nodes.add(node);
      }

      // Update the mind map reference
      _mindMap = currentMindMap;

      debugPrint(
        'BoardMindMapVm: Created mind map with ${_mindMap.nodes.length} nodes (${nodesWithPositions} had positions, ${nodesNeedingPositions} needed new positions)',
      );

      // Center the view on all nodes
      _centerViewOnNodes();
    } catch (e) {
      debugPrint('Error initializing content-based mind map: $e');
      debugPrint('Stack trace: ${StackTrace.current}');
    }
  }

  /// Toggle document panel visibility
  void toggleDocumentPanel() {
    _isDocumentPanelVisible = !_isDocumentPanelVisible;
    notifyListeners();
  }

  /// Handle adding new content
  Future<void> handleAddContent(String contentType) async {
    try {
      switch (contentType) {
        case 'note':
          await NavigationHelper.gotToNewNoteTemplate(board);
          break;
        case 'file':
          await NavigationHelper.push(Routes.uploadPdf, arguments: board);
          break;
        case 'flashcard':
          await NavigationHelper.createAndNavigateToNewFlashCard(board);
          break;
        case 'notebook':
          await NavigationHelper.createAndNavigateToNewNotebook(board);
          break;
      }

      // Refresh content after navigation returns
      await _refreshContent();
    } catch (e) {
      debugPrint('Error handling add content: $e');
    }
  }

  /// Refresh content and update mind map
  Future<void> _refreshContent() async {
    try {
      _contents = await DatabaseHelper.instance.getAllContents(board.id);

      // Reload the board to get updated mind map
      final updatedBoard = await DatabaseHelper.instance.getBoard(board.id);
      _mindMap = updatedBoard.getOrCreateMindMap();

      notifyListeners();
    } catch (e) {
      debugPrint('Error refreshing content: $e');
    }
  }

  /// Add a new node to the mind map
  MindMapNode addNode({
    required String text,
    required Offset position,
    Color color = Colors.blue,
    String? contentId,
  }) {
    final node = _mindMap.addNode(
      text: text,
      position: position,
      color: color,
      contentId: contentId,
    );

    _saveMindMapChanges();
    notifyListeners();
    return node;
  }

  /// Add a node with linked content
  MindMapNode addNodeWithContent({
    required String text,
    required Offset logicalPosition,
    required String contentId,
  }) {
    final content = _contents.firstWhere((c) => c.id == contentId);
    final color = _getNodeColorForContentType(content.type);

    return addNode(
      text: text,
      position: logicalPosition,
      color: color,
      contentId: contentId,
    );
  }

  /// Connect two nodes with an edge
  MindMapEdge connectNodes({
    required String sourceId,
    required String targetId,
    String? label,
    Color? color,
  }) {
    final edge = _mindMap.connectNodes(
      sourceId: sourceId,
      targetId: targetId,
      label: label,
      color: color,
    );

    _saveMindMapChanges();
    notifyListeners();
    return edge;
  }

  /// Remove a node and its connections
  void removeNode(String nodeId) {
    _mindMap.removeNode(nodeId);
    _saveMindMapChanges();
    notifyListeners();
  }

  /// Remove an edge
  void removeEdge(String edgeId) {
    _mindMap.removeEdge(edgeId);
    _saveMindMapChanges();
    notifyListeners();
  }

  /// Update node text
  void updateNodeText(String nodeId, String newText) {
    final node = _mindMap.findNode(nodeId);
    if (node != null) {
      node.text = newText;
      _saveMindMapChanges();
      notifyListeners();
    }
  }

  /// Delete node with confirmation dialog
  Future<void> deleteNodeWithConfirmation(
    BuildContext context,
    String nodeId,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Delete Node'),
            content: const Text(
              'Are you sure you want to delete this node? This action cannot be undone.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text('Delete'),
              ),
            ],
          ),
    );

    if (confirmed == true) {
      // Remove all edges connected to this node
      final edgesToRemove =
          _mindMap.edges
              .where(
                (edge) => edge.sourceId == nodeId || edge.targetId == nodeId,
              )
              .toList();

      for (final edge in edgesToRemove) {
        _mindMap.removeEdge(edge.id);
      }

      // Remove the node
      _mindMap.removeNode(nodeId);

      // Clear selection if this node was selected
      if (_selectedNodeId == nodeId) {
        _selectedNodeId = null;
      }

      _saveMindMapChanges();
      notifyListeners();
    }
  }

  /// Open attached content for a node
  Future<void> openAttachedContent(String nodeId) async {
    final node = _mindMap.findNode(nodeId);
    if (node?.contentID != null && node!.contentID!.isNotEmpty) {
      final content = _contents.firstWhere(
        (c) => c.id == node.contentID,
        orElse:
            () => Content(
              id: '',
              title: '',
              boardId: board.id,
              type: AppContentType.note,
              createdAt: DateTime.now().millisecondsSinceEpoch,
              updatedAt: DateTime.now().millisecondsSinceEpoch,
              metaData: {},
            ),
      );

      if (content.id.isNotEmpty) {
        await NavigationHelper.navigateToContent(content);
      }
    }
  }

  /// Remove attachment from node
  void removeAttachmentFromNode(String nodeId) {
    final node = _mindMap.findNode(nodeId);
    if (node != null) {
      node.contentID = null;
      _saveMindMapChanges();
      notifyListeners();
    }
  }

  /// Start attach mode for a node (placeholder - not used in board context)
  void startAttachToNode(String nodeId) {
    // In board context, attachments are automatically created when nodes are made
    // This method is kept for compatibility but doesn't need implementation
  }

  /// Open drawer (placeholder - handled by screen)
  void openDrawer() {
    // This would be handled by the screen's scaffold key
    // Kept for compatibility
  }

  /// Select a node
  void selectNode(String? nodeId) {
    _selectedNodeId = nodeId;
    _selectedEdgeId = null;
    notifyListeners();
  }

  /// Select an edge
  void selectEdge(String? edgeId) {
    _selectedEdgeId = edgeId;
    _selectedNodeId = null;
    notifyListeners();
  }

  /// Start connecting from a node
  void startConnecting(String nodeId) {
    _connectingFromNodeId = nodeId;
    notifyListeners();
  }

  /// Start connecting from a node (alternative method name for compatibility)
  void startConnectingFrom(String nodeId) {
    _connectingFromNodeId = nodeId;
    _selectedNodeId = nodeId; // Also select the node
    notifyListeners();
  }

  /// Cancel connecting
  void cancelConnecting() {
    _connectingFromNodeId = null;
    notifyListeners();
  }

  /// Finish connecting to a target node
  void finishConnecting(String targetNodeId) {
    if (_connectingFromNodeId != null &&
        _connectingFromNodeId != targetNodeId) {
      // Create connection between nodes
      connectNodes(sourceId: _connectingFromNodeId!, targetId: targetNodeId);
    }
    _connectingFromNodeId = null;
    notifyListeners();
  }

  /// Update canvas scale
  void setScale(double newScale) {
    scale = newScale;
    notifyListeners();
  }

  /// Zoom in by 20%
  void zoomIn() {
    debugPrint('BoardMindMapVm: zoomIn called');
    if (_transformationController != null && _viewportSize != null) {
      final currentMatrix = _transformationController!.value;
      final currentScale = currentMatrix.getMaxScaleOnAxis();
      final newScale = (currentScale * 1.2).clamp(0.1, 4.0);

      debugPrint('BoardMindMapVm: Zooming from $currentScale to $newScale');

      // Get viewport center
      final viewportCenter = Offset(
        _viewportSize!.width / 2,
        _viewportSize!.height / 2,
      );

      // Get current translation
      final translation = currentMatrix.getTranslation();

      // Calculate the point in canvas coordinates that's currently at viewport center
      final canvasPoint = Offset(
        (viewportCenter.dx - translation.x) / currentScale,
        (viewportCenter.dy - translation.y) / currentScale,
      );

      // Calculate new translation to keep the same canvas point at viewport center
      final newTranslation = Offset(
        viewportCenter.dx - (canvasPoint.dx * newScale),
        viewportCenter.dy - (canvasPoint.dy * newScale),
      );

      // Create new matrix with updated scale and adjusted translation
      final newMatrix =
          Matrix4.identity()
            ..translate(newTranslation.dx, newTranslation.dy)
            ..scale(newScale);

      _transformationController!.value = newMatrix;
      setScale(newScale);
    } else {
      debugPrint(
        'BoardMindMapVm: No transformation controller or viewport size available for zoom',
      );
    }
  }

  /// Zoom out by 20%
  void zoomOut() {
    debugPrint('BoardMindMapVm: zoomOut called');
    if (_transformationController != null && _viewportSize != null) {
      final currentMatrix = _transformationController!.value;
      final currentScale = currentMatrix.getMaxScaleOnAxis();
      final newScale = (currentScale / 1.2).clamp(0.1, 4.0);

      debugPrint('BoardMindMapVm: Zooming from $currentScale to $newScale');

      // Get viewport center
      final viewportCenter = Offset(
        _viewportSize!.width / 2,
        _viewportSize!.height / 2,
      );

      // Get current translation
      final translation = currentMatrix.getTranslation();

      // Calculate the point in canvas coordinates that's currently at viewport center
      final canvasPoint = Offset(
        (viewportCenter.dx - translation.x) / currentScale,
        (viewportCenter.dy - translation.y) / currentScale,
      );

      // Calculate new translation to keep the same canvas point at viewport center
      final newTranslation = Offset(
        viewportCenter.dx - (canvasPoint.dx * newScale),
        viewportCenter.dy - (canvasPoint.dy * newScale),
      );

      // Create new matrix with updated scale and adjusted translation
      final newMatrix =
          Matrix4.identity()
            ..translate(newTranslation.dx, newTranslation.dy)
            ..scale(newScale);

      _transformationController!.value = newMatrix;
      setScale(newScale);
    } else {
      debugPrint(
        'BoardMindMapVm: No transformation controller or viewport size available for zoom',
      );
    }
  }

  /// Reset zoom to 100% and center position
  void resetZoom() {
    debugPrint('BoardMindMapVm: resetZoom called');
    if (_transformationController != null) {
      _transformationController!.value = Matrix4.identity();
      setScale(1.0);
      debugPrint('BoardMindMapVm: Zoom reset to 1.0 and position centered');

      // After reset, center on content if available
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _centerViewOnNodes();
      });
    } else {
      scale = 1.0;
      notifyListeners();
      debugPrint(
        'BoardMindMapVm: Scale reset to 1.0 (no transformation controller)',
      );
    }
  }

  /// Update pointer position for drawing temporary edge
  void updatePointerFromVisual(Offset visualPosition) {
    if (_transformationController == null) {
      pointerLogical = visualPosition;
      notifyListeners();
      return;
    }

    final matrix = _transformationController!.value;
    final scale = matrix.getMaxScaleOnAxis();
    final translation = matrix.getTranslation();

    // Convert visual to logical coordinates
    pointerLogical = Offset(
      (visualPosition.dx - translation.x) / scale,
      (visualPosition.dy - translation.y) / scale,
    );

    notifyListeners();
  }

  /// Try to select edge at visual position
  bool trySelectEdgeAtVisual(Offset visualPosition) {
    // Convert visual to logical coordinates
    if (_transformationController == null) return false;

    final matrix = _transformationController!.value;
    final scale = matrix.getMaxScaleOnAxis();
    final translation = matrix.getTranslation();

    final logicalPosition = Offset(
      (visualPosition.dx - translation.x) / scale,
      (visualPosition.dy - translation.y) / scale,
    );

    // Check if any edge is close to this position
    for (final edge in _mindMap.edges) {
      final sourceNode = _mindMap.findNode(edge.sourceId);
      final targetNode = _mindMap.findNode(edge.targetId);

      if (sourceNode != null && targetNode != null) {
        // Simple distance check to edge line
        final sourceCenter = Offset(
          sourceNode.position.dx + sourceNode.width / 2,
          sourceNode.position.dy + sourceNode.height / 2,
        );
        final targetCenter = Offset(
          targetNode.position.dx + targetNode.width / 2,
          targetNode.position.dy + targetNode.height / 2,
        );

        // Check if point is close to line segment
        final distance = _distanceToLineSegment(
          logicalPosition,
          sourceCenter,
          targetCenter,
        );
        if (distance < 20) {
          // 20 pixel tolerance
          selectEdge(edge.id);
          return true;
        }
      }
    }

    return false;
  }

  /// Update viewport info (called by canvas)
  void updateViewportInfo(
    Size viewportSize,
    TransformationController controller,
  ) {
    _viewportSize = viewportSize;
    _transformationController = controller;
    debugPrint(
      'BoardMindMapVm: Viewport info updated - size: $viewportSize, controller set',
    );
  }

  /// Get the center of the currently visible area in canvas coordinates
  Offset getCurrentViewportCenter() {
    if (_viewportSize == null || _transformationController == null) {
      // Fallback to canvas center if no viewport info
      return const Offset(10000, 7500);
    }

    final matrix = _transformationController!.value;
    final scale = matrix.getMaxScaleOnAxis();
    final translation = matrix.getTranslation();

    // Calculate center of visible viewport in logical coordinates
    final viewportCenter = Offset(
      _viewportSize!.width / 2,
      _viewportSize!.height / 2,
    );
    final logicalCenter = Offset(
      (viewportCenter.dx - translation.x) / scale,
      (viewportCenter.dy - translation.y) / scale,
    );

    return logicalCenter;
  }

  /// Save mind map changes to database
  Future<void> _saveMindMapChanges() async {
    try {
      debugPrint('BoardMindMapVm: Saving mind map changes...');
      debugPrint('BoardMindMapVm: Mind map has ${_mindMap.nodes.length} nodes');

      // Log current node positions
      for (final node in _mindMap.nodes) {
        debugPrint(
          'BoardMindMapVm: Node ${node.id} (${node.text}) at position ${node.position}',
        );
      }

      final updatedBoard = board.updateMindMap(_mindMap);
      await DatabaseHelper.instance.updateBoard(updatedBoard);

      // Update our board reference to the latest version
      board = updatedBoard;

      debugPrint('BoardMindMapVm: Mind map changes saved successfully');
    } catch (e) {
      debugPrint('Error saving mind map changes: $e');
    }
  }

  /// Get node color based on content type
  Color _getNodeColorForContentType(AppContentType type) {
    switch (type) {
      case AppContentType.note:
        return Colors.blue;
      case AppContentType.file:
        return Colors.green;
      case AppContentType.flashcardDeck:
        return Colors.orange;
      case AppContentType.mindmap:
        return Colors.purple;
      case AppContentType.mindmapNode:
        return Colors.indigo; // Different color for mind map nodes
      case AppContentType.notebook:
        return Colors.teal;
    }
  }

  /// Generate a position for a new node
  Offset _generateNodePosition(int nodeIndex) {
    // Arrange nodes in a spiral pattern
    const double centerX = 10000; // Center of canvas
    const double centerY = 7500;
    const double radius = 300;
    const double angleStep = 2.4; // Radians between nodes

    if (nodeIndex == 0) {
      return Offset(centerX, centerY);
    }

    final angle = nodeIndex * angleStep;
    final spiralRadius = radius + (nodeIndex * 50); // Expanding spiral

    return Offset(
      centerX + spiralRadius * math.cos(angle),
      centerY + spiralRadius * math.sin(angle),
    );
  }

  /// Center the view on existing nodes
  void _centerViewOnNodes() {
    if (_mindMap.nodes.isEmpty) return;

    // Calculate the bounding box of all nodes
    double minX = double.infinity;
    double minY = double.infinity;
    double maxX = double.negativeInfinity;
    double maxY = double.negativeInfinity;

    for (final node in _mindMap.nodes) {
      minX = math.min(minX, node.position.dx);
      minY = math.min(minY, node.position.dy);
      maxX = math.max(maxX, node.position.dx + node.width);
      maxY = math.max(maxY, node.position.dy + node.height);
    }

    // Calculate center of all nodes
    final centerX = (minX + maxX) / 2;
    final centerY = (minY + maxY) / 2;

    debugPrint(
      'BoardMindMapVm: Centering view on nodes at ($centerX, $centerY)',
    );
    debugPrint('BoardMindMapVm: Node bounds: ($minX, $minY) to ($maxX, $maxY)');

    // Store the target center for the bridge to use
    _targetViewCenter = Offset(centerX, centerY);
    notifyListeners();
  }

  Offset? _targetViewCenter;
  Offset? get targetViewCenter => _targetViewCenter;

  /// Clear the target view center after it's been applied
  void clearTargetViewCenter() {
    _targetViewCenter = null;
  }

  /// Public method to center view on content (for manual triggering)
  void centerViewOnContent() {
    _centerViewOnNodes();
  }

  // ========== Dragging Methods ==========

  /// Start dragging a node
  void startDraggingNode(String nodeId) {
    _draggingNodeId = nodeId;
    _dragStartGlobal = null; // Reset for next drag
    _dragStartNodePosition = null;
    notifyListeners();
  }

  /// Move the dragging node using global position for accurate tracking
  Future<void> dragNodeByGlobal(String nodeId, Offset globalPosition) async {
    if (_draggingNodeId != nodeId) return;
    final node = _mindMap.findNode(nodeId);
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
      final newPosition = _constrainPosition(
        _dragStartNodePosition! + canvasDelta,
      );
      node.position = newPosition;

      // Update the corresponding content's position
      await _updateContentPosition(node.id, newPosition);

      notifyListeners();
    }
  }

  /// End dragging and persist position
  void stopDraggingNode() {
    // Position is already saved in dragNodeByGlobal via _updateContentPosition
    _draggingNodeId = null;
    _dragStartGlobal = null;
    _dragStartNodePosition = null;
    notifyListeners();
  }

  /// Constrain node position to canvas bounds
  Offset _constrainPosition(Offset position) {
    const double canvasWidth = 20000;
    const double canvasHeight = 15000;

    final x = position.dx.clamp(
      0.0,
      canvasWidth - 200.0,
    ); // Leave space for node width
    final y = position.dy.clamp(
      0.0,
      canvasHeight - 200.0,
    ); // Leave space for node height

    return Offset(x, y);
  }

  /// Calculate distance from point to line segment
  double _distanceToLineSegment(
    Offset point,
    Offset lineStart,
    Offset lineEnd,
  ) {
    final dx = lineEnd.dx - lineStart.dx;
    final dy = lineEnd.dy - lineStart.dy;
    final length = math.sqrt(dx * dx + dy * dy);

    if (length == 0) return (point - lineStart).distance;

    final t = math.max(
      0,
      math.min(
        1,
        ((point.dx - lineStart.dx) * dx + (point.dy - lineStart.dy) * dy) /
            (length * length),
      ),
    );
    final projection = Offset(lineStart.dx + t * dx, lineStart.dy + t * dy);

    return (point - projection).distance;
  }

  // ========== Content-Based Mind Map Methods ==========

  /// Create a mind map node from content
  MindMapNode _createNodeFromContent(Content content) {
    final position = content.mindMapPosition ?? const Offset(10000, 7500);
    final color =
        content.nodeColor != null
            ? Color(int.parse(content.nodeColor!.replaceFirst('#', '0xff')))
            : _getNodeColorForContentType(content.type);

    return MindMapNode(
      id: content.id,
      text:
          content.title.isNotEmpty
              ? content.title
              : (content.file ?? 'Untitled'),
      position: position,
      color: color,
      width: content.nodeWidth ?? 200.0,
      height: content.nodeHeight ?? 100.0,
      contentID: content.id,
    );
  }

  /// Update content position from node
  Future<void> _updateContentPosition(String contentId, Offset position) async {
    final content = _contents.firstWhere((c) => c.id == contentId);
    final updatedContent = content.updateMindMapPosition(position);

    // Update in database
    await DatabaseHelper.instance.updateContent(updatedContent);

    // Update in local list
    final index = _contents.indexWhere((c) => c.id == contentId);
    if (index != -1) {
      _contents[index] = updatedContent;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
