import 'dart:async';
import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:navinotes/models/board.dart';
import 'package:navinotes/models/content.dart';
import 'package:navinotes/models/mind_map.dart';
import 'package:navinotes/models/mind_map_node.dart';
import 'package:navinotes/models/mind_map_edge.dart';
import 'package:navinotes/settings/packages.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class BoardMindMapVm extends ChangeNotifier {
  Board board; // Make it mutable so we can update it with the latest mind map
  final GlobalKey<ScaffoldState> scaffoldKey;

  /// Canvas dimensions
  static const double canvasWidth = 20000;
  static const double canvasHeight = 15000;

  bool _isLoading = true;
  bool _isDocumentPanelVisible = true;
  bool _isStylingPanelVisible = false; // Only show when design icon is clicked
  bool _needsInitialCentering = false;

  // Mind Map State
  MindMap _mindMap;
  String? _selectedNodeId;
  String? _selectedEdgeId;
  String? _connectingFromNodeId;
  String? _draggingNodeId;
  String?
  _attachingNodeId; // When not null, the next document/deck tapped will attach to this node

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

  /// Persistence state
  String title = "Mind Map";

  /// Autosave state
  Timer? _autoSaveTimer;
  final Duration autoSaveDelay = const Duration(seconds: 5);
  bool _suppressAutoSave = false; // used during load/save
  bool _isSaving = false;

  // Getters
  bool get isLoading => _isLoading;
  bool get isDocumentPanelVisible => _isDocumentPanelVisible;
  bool get isStylingPanelVisible => _isStylingPanelVisible;
  MindMap get mindMap => _mindMap;
  List<Content> get contents => _contents;
  String? get selectedNodeId => _selectedNodeId;
  String? get selectedEdgeId => _selectedEdgeId;
  String? get connectingFromNodeId => _connectingFromNodeId;
  String? get draggingNodeId => _draggingNodeId;
  String? get attachingNodeId => _attachingNodeId;

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

  BoardMindMapVm({required this.board, required this.scaffoldKey})
    : _mindMap = MindMap(name: '${board.name} Mind Map') {
    debugPrint(
      'BoardMindMapVm: Constructor - initializing content-based mind map for board ${board.name}',
    );
    debugPrint('BoardMindMapVm: Using simplified content-only architecture');
    _initialize();
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

  updateTitle(String newTitle) {
    if (newTitle.trim().isEmpty) return;
    title = newTitle;
    _saveMindMapChanges();
    notifyListeners();
  }

  Future<void> _initialize() async {
    debugPrint('BoardMindMapVm: Starting initialization for board ${board.id}');

    try {
      // Load board contents
      debugPrint('BoardMindMapVm: Loading contents for board ${board.id}');
      _contents = await DatabaseHelper.instance.getAllContents(board.id);
      debugPrint('BoardMindMapVm: Loaded ${_contents.length} contents');

      // Always initialize mind map with content-based approach
      if (_contents.isNotEmpty) {
        debugPrint(
          'BoardMindMapVm: Initializing content-based mind map with ${_contents.length} content items',
        );
        await _initializeMindMapWithContent();
      } else {
        debugPrint('BoardMindMapVm: No content found, mind map will be empty');
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

  /// Initialize mind map with all content as nodes (Simplified Content-Only Architecture)
  Future<void> _initializeMindMapWithContent() async {
    try {
      debugPrint(
        'BoardMindMapVm: Initializing simplified content-only mind map with ${_contents.length} content items',
      );

      // Create fresh mind map - all nodes will be generated from content
      final contentBasedMindMap = MindMap(name: '${board.name} Mind Map');

      int nodesWithPositions = 0;
      int nodesNeedingPositions = 0;

      // Convert ALL content to mind map nodes (no standalone nodes)
      for (final content in _contents) {
        // Check if content already has mind map position
        Offset position;
        if (content.mindMapPosition != null) {
          position = content.mindMapPosition!;
          nodesWithPositions++;
          debugPrint(
            'BoardMindMapVm: Content ${content.id} (${content.title}) has position ${position}',
          );
        } else {
          // Generate new position for content without mind map data
          position = _generateNodePosition(contentBasedMindMap.nodes.length);
          nodesNeedingPositions++;

          // Update content with new mind map position and default styling
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
        contentBasedMindMap.nodes.add(node);
      }

      // Load connections between content from database
      await _loadContentConnections(contentBasedMindMap);

      // Replace mind map with content-based version (no board storage needed)
      _mindMap = contentBasedMindMap;

      debugPrint(
        'BoardMindMapVm: Created content-only mind map with ${_mindMap.nodes.length} nodes, ${_mindMap.edges.length} connections',
      );
      debugPrint(
        'BoardMindMapVm: (${nodesWithPositions} had positions, ${nodesNeedingPositions} needed new positions)',
      );

      // Set flag to indicate we need initial centering
      _needsInitialCentering = true;

      // Try immediate centering
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

  /// Toggle styling panel visibility
  void toggleStylingPanel() {
    _isStylingPanelVisible = !_isStylingPanelVisible;
    notifyListeners();
  }

  /// Show styling panel
  void showStylingPanel() {
    _isStylingPanelVisible = true;
    notifyListeners();
  }

  /// Hide styling panel
  void hideStylingPanel() {
    _isStylingPanelVisible = false;
    notifyListeners();
  }

  /// Refresh content and regenerate mind map (Content-Only Architecture)
  Future<void> _refreshContent() async {
    try {
      _contents = await DatabaseHelper.instance.getAllContents(board.id);

      // Regenerate mind map from content (no board mind map data needed)
      await _initializeMindMapWithContent();

      notifyListeners();
    } catch (e) {
      debugPrint('Error refreshing content: $e');
    }
  }

  /// Add a new content-based node to the mind map (Simplified Architecture)
  Future<MindMapNode> addNode({
    required String text,
    required Offset position,
    Color? color,
    String? contentId,
  }) async {
    // In simplified architecture, ALL nodes must be content-based
    // Create new content if contentId not provided
    if (contentId == null) {
      // Create new mind map content
      final newContent = Content(
        title: text.isEmpty ? 'New Node' : text,
        type: AppContentType.mindmapNode,
        boardId: board.id,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        updatedAt: DateTime.now().millisecondsSinceEpoch,
        metaData: {},
        mindMapX: _constrainPosition(position).dx,
        mindMapY: _constrainPosition(position).dy,
        nodeColor:
            '#${(color ?? _getNodeColorForContentType(AppContentType.mindmapNode)).value.toRadixString(16).padLeft(8, '0')}',
        nodeWidth: 200.0,
        nodeHeight: 100.0,
        connectedContentIds: '[]',
      );

      // Save to database
      await DatabaseHelper.instance.insertContent(newContent);

      // Add to local content list
      _contents.add(newContent);
      contentId = newContent.id;
    }

    // Create node from content
    final content = _contents.firstWhere((c) => c.id == contentId);
    final node = _createNodeFromContent(content);
    _mindMap.nodes.add(node);

    notifyListeners();
    return node;
  }

  /// Create a new node with attached content at the specified position
  Future<MindMapNode> addNodeAt({
    required String text,
    required Offset logicalPosition,
    Color? color,
    String? contentID,
  }) async {
    return await addNode(
      text: text,
      position: logicalPosition,
      color: color,
      contentId: contentID,
    );
  }

  /// Add a node with linked content
  Future<MindMapNode> addNodeWithContent({
    required String text,
    required Offset logicalPosition,
    required String contentId,
  }) async {
    final content = _contents.firstWhere((c) => c.id == contentId);
    final color = _getNodeColorForContentType(content.type);

    return await addNode(
      text: text,
      position: logicalPosition,
      color: color,
      contentId: contentId,
    );
  }

  /// Connect two content nodes with an edge (Content-Based Architecture)
  Future<MindMapEdge> connectNodes({
    required String sourceId,
    required String targetId,
    String? label,
    Color? color,
  }) async {
    // prevent self connect
    if (sourceId == targetId) throw Exception('Cannot connect node to itself');

    // prevent duplicate edge
    final exists = _mindMap.edges.any(
      (e) =>
          (e.sourceId == sourceId && e.targetId == targetId) ||
          (e.sourceId == targetId && e.targetId == sourceId),
    );
    if (exists) {
      final existing = _mindMap.edges.firstWhere(
        (e) =>
            (e.sourceId == sourceId && e.targetId == targetId) ||
            (e.sourceId == targetId && e.targetId == sourceId),
      );
      return existing;
    }

    // Create edge in mind map
    final edge = _mindMap.connectNodes(
      sourceId: sourceId,
      targetId: targetId,
      label: label,
      color: color ?? boardTheme.values.connectionColor,
    );

    // Update content connections in database
    await _updateContentConnections(sourceId, targetId);

    notifyListeners();
    return edge;
  }

  /// Remove a content node and its connections (Content-Based Architecture)
  Future<void> removeNode(String nodeId) async {
    // Find the content
    final content = _contents.where((c) => c.id == nodeId).firstOrNull;
    if (content != null) {
      // Remove from database
      await DatabaseHelper.instance.deleteContent(nodeId);

      // Remove from local list
      _contents.removeWhere((c) => c.id == nodeId);

      // Remove connections from other content
      await _removeAllConnectionsToContent(nodeId);
    }

    // Remove from mind map
    _mindMap.removeNode(nodeId);
    if (_selectedNodeId == nodeId) _selectedNodeId = null;

    notifyListeners();
  }

  /// Remove an edge and update content connections
  Future<void> removeEdge(String edgeId) async {
    final edge = _mindMap.findEdge(edgeId);
    if (edge != null) {
      // Remove connection from content
      await _removeContentConnection(edge.sourceId, edge.targetId);
    }

    // Remove from mind map
    _mindMap.removeEdge(edgeId);
    if (_selectedEdgeId == edgeId) _selectedEdgeId = null;

    notifyListeners();
  }

  /// Update node text and corresponding content
  Future<void> updateNodeText(String nodeId, String newText) async {
    final node = _mindMap.findNode(nodeId);
    if (node != null) {
      node.text = newText;

      // Update corresponding content
      final content = _contents.where((c) => c.id == nodeId).firstOrNull;
      if (content != null) {
        final updatedContent = content.getUpdatedContent(
          title: newText,
          updatedAt: DateTime.now().millisecondsSinceEpoch,
        );

        await DatabaseHelper.instance.updateContent(updatedContent);

        // Update in local list
        final index = _contents.indexWhere((c) => c.id == nodeId);
        if (index != -1) {
          _contents[index] = updatedContent;
        }
      }

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
        _isStylingPanelVisible =
            false; // hide styling panel when selected node is deleted
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
        await NavigationHelper.navigateToContent(content, replace: true);
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

  /// Select a node
  void selectNode(String? nodeId) {
    debugPrint("Selected node: $nodeId");

    _selectedNodeId = nodeId;
    debugPrint("Selected node: $nodeId");
    if (nodeId != null) {
      _selectedEdgeId = null; // deselect edges when node is selected
    } else {
      // Hide styling panel when no node is selected
      _isStylingPanelVisible = false;
    }
    // if switching selection, exit attach mode
    if (_attachingNodeId != null && _attachingNodeId != nodeId) {
      _attachingNodeId = null;
    }
    notifyListeners();
  }

  /// Select an edge
  void selectEdge(String? edgeId) {
    _selectedEdgeId = edgeId;
    if (edgeId != null) {
      _selectedNodeId = null; // deselect nodes when edge is selected
      _isStylingPanelVisible =
          false; // hide styling panel when edge is selected
    }
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
    debugPrint("trySelectEdgeAtVisual");
    // Convert visual to logical coordinates
    if (_transformationController == null) {
      debugPrint("No _transformationController");
      return false;
    }

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
          debugPrint("Selected Edge == ${edge.id}");

          return true;
        }
      }
    }

    return false;
  }

  /// Update viewport info (called by canvas)
  // void updateViewportInfo(
  //   Size viewportSize,
  //   TransformationController controller,
  // ) {
  //   _viewportSize = viewportSize;
  //   _transformationController = controller;
  //   debugPrint(
  //     'BoardMindMapVm: Viewport info updated - size: $viewportSize, controller set',
  //   );

  //   // If we need initial centering or have a target view center waiting, apply it now
  //   if (_needsInitialCentering || _targetViewCenter != null) {
  //     debugPrint(
  //       'BoardMindMapVm: Applying centering now that controller is available (needsInitial: $_needsInitialCentering, hasTarget: ${_targetViewCenter != null})',
  //     );
  //     _centerViewOnNodes();
  //     _needsInitialCentering = false; // Clear the flag
  //   }
  // }

  void updateViewportInfo(
    Size viewportSize,
    TransformationController controller,
  ) {
    _viewportSize = viewportSize;
    _transformationController = controller;

    // Use post-frame callback for any notifications
    WidgetsBinding.instance.addPostFrameCallback((_) {
      debugPrint(
        'BoardMindMapVm: Viewport info updated - size: $viewportSize, controller set',
      );
      _centerViewOnNodes(); // This will now be called after build completes
    });
  }

  /// Check if initial centering is needed (for canvas to handle)
  bool get needsInitialCentering => _needsInitialCentering;

  /// Get content by ID
  Content? getContentById(String contentId) {
    try {
      return _contents.firstWhere((c) => c.id == contentId);
    } catch (e) {
      return null;
    }
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

  /// Content-based architecture doesn't need board mind map saving
  /// All data is stored in individual content records
  Future<void> _saveMindMapChanges() async {
    // In simplified architecture, all data is already saved in content records
    // This method is kept for compatibility but does nothing
    debugPrint(
      'BoardMindMapVm: Content-based architecture - no board mind map to save',
    );
  }

  /// Save node styling changes to corresponding content record
  Future<void> _saveNodeStylingToContent(String nodeId) async {
    try {
      final node = _mindMap.findNode(nodeId);
      if (node == null) return;

      // Find the corresponding content
      final content = _contents.where((c) => c.id == nodeId).firstOrNull;
      if (content == null) return;

      // Create enhanced styling object for metaData storage
      final nodeStyleData = {
        'textColor':
            '#${node.textColor.value.toRadixString(16).padLeft(8, '0')}',
        'fontSize': node.fontSize,
        'fontWeight': node.fontWeight,
        'opacity': node.opacity,
        'colorTone': node.colorTone,
        'borderStyle': node.borderStyle.toString(),
        'borderRadius': node.borderRadius,
      };

      // Update metaData with styling info
      final updatedMetaData = Map<String, dynamic>.from(content.metaData);
      updatedMetaData['nodeStyle'] = nodeStyleData;

      // Update content with current node styling (basic fields + enhanced metaData)
      final updatedContent = content.getUpdatedContentWithMeta(
        nodeColor: '#${node.color.value.toRadixString(16).padLeft(8, '0')}',
        nodeWidth: node.width,
        nodeHeight: node.height,
        nodeShape: node.shape.toString(),
        metaData: updatedMetaData,
        updatedAt: DateTime.now().millisecondsSinceEpoch,
      );

      // Save to database
      await DatabaseHelper.instance.updateContent(updatedContent);

      // Update in local list
      final index = _contents.indexWhere((c) => c.id == nodeId);
      if (index != -1) {
        _contents[index] = updatedContent;
      }

      debugPrint(
        'BoardMindMapVm: Saved ALL styling for node $nodeId (color: ${node.color}, shape: ${node.shape}, opacity: ${node.opacity})',
      );
    } catch (e) {
      debugPrint('Error saving node styling to content: $e');
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
        return Colors.purple;
      case AppContentType.mindmapNode:
        return Colors.indigo;
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
    if (_mindMap.nodes.isEmpty) {
      debugPrint('BoardMindMapVm: No nodes to center on');
      return;
    }

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

    // If transformation controller is available, apply centering immediately
    if (_transformationController != null && _viewportSize != null) {
      debugPrint('BoardMindMapVm: Applying immediate centering transformation');

      // Calculate the translation needed to center the content
      final viewportCenter = Offset(
        _viewportSize!.width / 2,
        _viewportSize!.height / 2,
      );

      // Current scale
      final currentScale = _transformationController!.value.getMaxScaleOnAxis();

      // Calculate translation to center the nodes
      final translation =
          viewportCenter -
          Offset(centerX * currentScale, centerY * currentScale);

      // Create new transformation matrix
      final newMatrix =
          Matrix4.identity()
            ..translate(translation.dx, translation.dy)
            ..scale(currentScale);

      _transformationController!.value = newMatrix;
      debugPrint('BoardMindMapVm: Applied centering transformation');
    } else {
      debugPrint(
        'BoardMindMapVm: Transformation controller or viewport size not available, storing target center',
      );
    }

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

  /// Start dragging a content-based node
  void startDraggingNode(String nodeId) {
    _draggingNodeId = nodeId;
    _dragStartGlobal = null; // Reset for next drag
    _dragStartNodePosition = null;
    notifyListeners();
  }

  /// Move the dragging content node using global position for accurate tracking
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

      // Update the corresponding content's position (primary data storage)
      await _updateContentPosition(node.id, newPosition);

      notifyListeners();
    }
  }

  /// End dragging content node (position already persisted in content)
  void stopDraggingNode() {
    // Position is already saved in dragNodeByGlobal via _updateContentPosition
    // No additional board mind map saving needed in simplified architecture
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

    // Parse saved shape or use default
    MindMapShape shape = MindMapShape.rounded;
    if (content.nodeShape != null) {
      try {
        shape = MindMapShape.values.firstWhere(
          (e) => e.toString() == content.nodeShape,
          orElse: () => MindMapShape.rounded,
        );
      } catch (e) {
        debugPrint('Error parsing node shape: $e');
      }
    }

    // Load enhanced styling from metaData
    final nodeStyleData =
        content.metaData['nodeStyle'] as Map<String, dynamic>?;

    // Parse advanced styling properties
    Color textColor = Colors.black;
    double fontSize = 14.0;
    int fontWeight = 500;
    double opacity = 1.0;
    double colorTone = 0.0;
    MindMapBorderStyle borderStyle = MindMapBorderStyle.none;
    double borderRadius = 8.0;

    if (nodeStyleData != null) {
      try {
        // Parse text color
        if (nodeStyleData['textColor'] != null) {
          textColor = Color(
            int.parse(nodeStyleData['textColor'].replaceFirst('#', '0xff')),
          );
        }

        // Parse numeric properties
        fontSize = (nodeStyleData['fontSize'] as num?)?.toDouble() ?? fontSize;
        fontWeight =
            (nodeStyleData['fontWeight'] as num?)?.toInt() ?? fontWeight;
        opacity = (nodeStyleData['opacity'] as num?)?.toDouble() ?? opacity;
        colorTone =
            (nodeStyleData['colorTone'] as num?)?.toDouble() ?? colorTone;
        borderRadius =
            (nodeStyleData['borderRadius'] as num?)?.toDouble() ?? borderRadius;

        // Parse border style
        if (nodeStyleData['borderStyle'] != null) {
          borderStyle = MindMapBorderStyle.values.firstWhere(
            (e) => e.toString() == nodeStyleData['borderStyle'],
            orElse: () => MindMapBorderStyle.none,
          );
        }
      } catch (e) {
        debugPrint('Error parsing enhanced node styling: $e');
      }
    }

    debugPrint(
      'BoardMindMapVm: Loaded node ${content.id} with styling - opacity: $opacity, textColor: $textColor, fontSize: $fontSize',
    );

    return MindMapNode(
      id: content.id,
      text:
          content.title.isNotEmpty
              ? content.title
              : (content.file ?? 'Untitled'),
      position: position,
      color: color,
      textColor: textColor,
      width: content.nodeWidth ?? 200.0,
      height: content.nodeHeight ?? 100.0,
      fontSize: fontSize,
      fontWeight: fontWeight,
      opacity: opacity,
      colorTone: colorTone,
      shape: shape,
      borderStyle: borderStyle,
      borderRadius: borderRadius,
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

  // ========== Content Connection Management (Simplified Architecture) ==========

  /// Load connections between content and create edges in mind map
  Future<void> _loadContentConnections(MindMap mindMap) async {
    debugPrint('BoardMindMapVm: Loading content connections...');

    int connectionCount = 0;

    for (final content in _contents) {
      final connections = content.connectedContentIdsList;

      for (final connectedId in connections) {
        // Check if connected content exists and edge doesn't already exist
        final connectedContent =
            _contents.where((c) => c.id == connectedId).firstOrNull;
        if (connectedContent != null) {
          final existingEdge = mindMap.edges.any(
            (e) =>
                (e.sourceId == content.id && e.targetId == connectedId) ||
                (e.sourceId == connectedId && e.targetId == content.id),
          );

          if (!existingEdge) {
            mindMap.connectNodes(
              sourceId: content.id,
              targetId: connectedId,
              color: boardTheme.values.connectionColor,
            );
            connectionCount++;
          }
        }
      }
    }

    debugPrint(
      'BoardMindMapVm: Loaded $connectionCount connections from content',
    );
  }

  /// Update content connections when nodes are connected
  Future<void> _updateContentConnections(
    String sourceId,
    String targetId,
  ) async {
    try {
      // Update source content
      final sourceContent = _contents.firstWhere((c) => c.id == sourceId);
      final updatedSourceContent = sourceContent.addConnection(targetId);
      await DatabaseHelper.instance.updateContent(updatedSourceContent);

      // Update target content
      final targetContent = _contents.firstWhere((c) => c.id == targetId);
      final updatedTargetContent = targetContent.addConnection(sourceId);
      await DatabaseHelper.instance.updateContent(updatedTargetContent);

      // Update local lists
      final sourceIndex = _contents.indexWhere((c) => c.id == sourceId);
      if (sourceIndex != -1) {
        _contents[sourceIndex] = updatedSourceContent;
      }

      final targetIndex = _contents.indexWhere((c) => c.id == targetId);
      if (targetIndex != -1) {
        _contents[targetIndex] = updatedTargetContent;
      }

      debugPrint(
        'BoardMindMapVm: Updated connection between $sourceId and $targetId',
      );
    } catch (e) {
      debugPrint('Error updating content connections: $e');
    }
  }

  /// Remove connection between two content items
  Future<void> _removeContentConnection(
    String sourceId,
    String targetId,
  ) async {
    try {
      // Remove from source content
      final sourceContent =
          _contents.where((c) => c.id == sourceId).firstOrNull;
      if (sourceContent != null) {
        final updatedSourceContent = sourceContent.removeConnection(targetId);
        await DatabaseHelper.instance.updateContent(updatedSourceContent);

        final sourceIndex = _contents.indexWhere((c) => c.id == sourceId);
        if (sourceIndex != -1) {
          _contents[sourceIndex] = updatedSourceContent;
        }
      }

      // Remove from target content
      final targetContent =
          _contents.where((c) => c.id == targetId).firstOrNull;
      if (targetContent != null) {
        final updatedTargetContent = targetContent.removeConnection(sourceId);
        await DatabaseHelper.instance.updateContent(updatedTargetContent);

        final targetIndex = _contents.indexWhere((c) => c.id == targetId);
        if (targetIndex != -1) {
          _contents[targetIndex] = updatedTargetContent;
        }
      }

      debugPrint(
        'BoardMindMapVm: Removed connection between $sourceId and $targetId',
      );
    } catch (e) {
      debugPrint('Error removing content connection: $e');
    }
  }

  /// Remove all connections to a specific content (when content is deleted)
  Future<void> _removeAllConnectionsToContent(String contentId) async {
    try {
      int removedConnections = 0;

      for (final content in _contents) {
        final connections = content.connectedContentIdsList;
        if (connections.contains(contentId)) {
          final updatedContent = content.removeConnection(contentId);
          await DatabaseHelper.instance.updateContent(updatedContent);

          final index = _contents.indexWhere((c) => c.id == content.id);
          if (index != -1) {
            _contents[index] = updatedContent;
          }
          removedConnections++;
        }
      }

      debugPrint(
        'BoardMindMapVm: Removed $removedConnections connections to deleted content $contentId',
      );
    } catch (e) {
      debugPrint('Error removing all connections to content: $e');
    }
  }

  // ---------- Autosave internals (Simplified for Content-Only Architecture) ----------
  void _onVmChanged() {
    if (_suppressAutoSave || _isSaving) return;
    _autoSaveTimer?.cancel();
    _autoSaveTimer = Timer(autoSaveDelay, () async {
      // In content-based architecture, auto-save is handled per content item
      // This is kept for compatibility but minimal action needed
      debugPrint(
        'BoardMindMapVm: Auto-save triggered (content-based architecture)',
      );
    });
  }

  // ---------- Attachment mode control ----------
  void startAttachToNode(String nodeId) {
    _attachingNodeId = nodeId;
    notifyListeners();
  }

  void cancelAttachMode() {
    if (_attachingNodeId != null) {
      _attachingNodeId = null;
      notifyListeners();
    }
  }

  bool isAttachModeFor(String nodeId) => _attachingNodeId == nodeId;

  void attachContentToNodeById(String nodeId, String contentId) {
    final node = _mindMap.findNode(nodeId);
    if (node == null) return;
    node.contentID = contentId;
    // exit attach mode after attaching
    _attachingNodeId = null;
    _saveMindMapChanges();
    notifyListeners();
  }

  // ---------- Canvas pan/zoom & pointer handling ----------
  /// Convert a visual/screen-local pointer into logical coordinates (the coordinate space of nodes).
  Offset visualToLogical(Offset visualLocal) => visualLocal / scale;

  // ---------- Styling methods for UI ----------
  void updateSelectedEdgeColor(Color color) {
    final edge =
        _selectedEdgeId != null ? _mindMap.findEdge(_selectedEdgeId!) : null;
    if (edge != null) {
      edge.color = color;
      _saveMindMapChanges();
      notifyListeners();
    }
  }

  void updateSelectedEdgeThickness(double thickness) {
    final edge =
        _selectedEdgeId != null ? _mindMap.findEdge(_selectedEdgeId!) : null;
    if (edge != null) {
      edge.thickness = thickness;
      _saveMindMapChanges();
      notifyListeners();
    }
  }

  void updateSelectedEdgeOpacity(double opacity) {
    final edge =
        _selectedEdgeId != null ? _mindMap.findEdge(_selectedEdgeId!) : null;
    if (edge != null) {
      edge.opacity = opacity;
      _saveMindMapChanges();
      notifyListeners();
    }
  }

  void deleteEdgeWithConfirmation(BuildContext context, String edgeId) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Delete Connection'),
            content: const Text(
              'Are you sure you want to delete this connection?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  removeEdge(edgeId);
                  Navigator.of(context).pop();
                },
                child: const Text('Delete'),
              ),
            ],
          ),
    );
  }

  void updateSelectedNodeBackgroundColor(Color color) {
    final node =
        _selectedNodeId != null ? _mindMap.findNode(_selectedNodeId!) : null;
    if (node != null) {
      node.color = color;
      _saveNodeStylingToContent(node.id);
      notifyListeners();
    }
  }

  void updateSelectedNodeTextColor(Color color) {
    final node =
        _selectedNodeId != null ? _mindMap.findNode(_selectedNodeId!) : null;
    if (node != null) {
      node.textColor = color;
      _saveNodeStylingToContent(node.id);
      notifyListeners();
    }
  }

  void updateNodeSize(String nodeId, double width, double height) {
    final node = _mindMap.findNode(nodeId);
    if (node != null) {
      node.width = width;
      node.height = height;
      _saveNodeStylingToContent(nodeId);
      notifyListeners();
    }
  }

  void updateSelectedNodeFontSize(double fontSize) {
    final node =
        _selectedNodeId != null ? _mindMap.findNode(_selectedNodeId!) : null;
    if (node != null) {
      node.fontSize = fontSize;
      _saveNodeStylingToContent(node.id);
      notifyListeners();
    }
  }

  void updateSelectedNodeOpacity(double opacity) {
    final node =
        _selectedNodeId != null ? _mindMap.findNode(_selectedNodeId!) : null;
    if (node != null) {
      node.opacity = opacity;
      _saveNodeStylingToContent(node.id);
      notifyListeners();
    }
  }

  void updateSelectedNodeColorTone(double tone) {
    final node =
        _selectedNodeId != null ? _mindMap.findNode(_selectedNodeId!) : null;
    if (node != null) {
      node.colorTone = tone;
      _saveNodeStylingToContent(node.id);
      notifyListeners();
    }
  }

  void updateSelectedNodeFontWeight(int weight) {
    final node =
        _selectedNodeId != null ? _mindMap.findNode(_selectedNodeId!) : null;
    if (node != null) {
      node.fontWeight = weight;
      _saveNodeStylingToContent(node.id);
      notifyListeners();
    }
  }

  void updateSelectedNodeBorderStyle(MindMapBorderStyle style) {
    final node =
        _selectedNodeId != null ? _mindMap.findNode(_selectedNodeId!) : null;
    if (node != null) {
      node.borderStyle = style;
      _saveNodeStylingToContent(node.id);
      notifyListeners();
    }
  }

  void updateSelectedNodeShape(MindMapShape shape) {
    final node =
        _selectedNodeId != null ? _mindMap.findNode(_selectedNodeId!) : null;
    if (node != null) {
      node.shape = shape;
      _saveNodeStylingToContent(node.id);
      notifyListeners();
    }
  }

  void updateSelectedNodeBorderRadius(double radius) {
    final node =
        _selectedNodeId != null ? _mindMap.findNode(_selectedNodeId!) : null;
    if (node != null) {
      node.borderRadius = radius;
      _saveNodeStylingToContent(node.id);
      notifyListeners();
    }
  }

  void updateSelectedEdgeType(EdgeLineType type) {
    final edge =
        _selectedEdgeId != null ? _mindMap.findEdge(_selectedEdgeId!) : null;
    if (edge != null) {
      edge.lineType = type;
      _saveMindMapChanges();
      notifyListeners();
    }
  }

  // ---------- Export functionality ----------
  /// Save mind map to database
  Future<void> saveToDb() async {
    await _saveMindMapChanges();
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
    if (_mindMap.nodes.isEmpty) return Rect.zero;

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

    return Rect.fromLTRB(minX - 50, minY - 50, maxX + 50, maxY + 50);
  }

  /// Draw mind map to Flutter canvas
  void _drawMindMapToCanvas(Canvas canvas, Rect bounds) {
    // Draw edges first
    for (final edge in _mindMap.edges) {
      final fromNode = _mindMap.findNode(edge.sourceId);
      final toNode = _mindMap.findNode(edge.targetId);
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
    for (final node in _mindMap.nodes) {
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

  @override
  void dispose() {
    removeListener(_onVmChanged);
    _autoSaveTimer?.cancel();
    super.dispose();
  }
}
