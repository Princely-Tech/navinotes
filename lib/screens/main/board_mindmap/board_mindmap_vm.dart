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
  final Board board;
  
  // UI State
  bool _isLoading = true;
  bool _isDocumentPanelVisible = true;
  
  // Mind Map State
  MindMap _mindMap;
  String? selectedNodeId;
  String? selectedEdgeId;
  String? connectingFromNodeId;
  String? draggingNodeId;
  
  // Canvas transform state
  double scale = 1.0;
  Offset? pointerLogical;
  
  // Content state
  List<Content> _contents = [];
  
  // Getters
  bool get isLoading => _isLoading;
  bool get isDocumentPanelVisible => _isDocumentPanelVisible;
  MindMap get mindMap => _mindMap;
  List<Content> get contents => _contents;
  
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
        debugPrint('BoardMindMapVm: Initializing mind map with ${_contents.length} content items');
        await _initializeMindMapWithContent();
      } else {
        debugPrint('BoardMindMapVm: Mind map already has ${_mindMap.nodes.length} nodes');
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

  /// Initialize mind map with existing content as nodes
  Future<void> _initializeMindMapWithContent() async {
    try {
      debugPrint('BoardMindMapVm: Creating nodes for ${_contents.length} content items');
      
      // Get the current mind map and add nodes directly
      final currentMindMap = board.getOrCreateMindMap();
      
      for (int i = 0; i < _contents.length; i++) {
        final content = _contents[i];
        debugPrint('BoardMindMapVm: Adding node for content ${content.id} - ${content.title}');
        
        // Generate position for this node
        final position = _generateNodePosition(i);
        final color = _getNodeColorForContentType(content.type);
        final title = content.title.isNotEmpty ? content.title : (content.file ?? 'Untitled');
        
        // Add node to mind map
        currentMindMap.addNode(
          text: title,
          position: position,
          color: color,
          contentId: content.id,
        );
      }
      
      // Update the mind map reference
      _mindMap = currentMindMap;
      
      // Save the updated board to database
      final updatedBoard = board.updateMindMap(_mindMap);
      await DatabaseHelper.instance.updateBoard(updatedBoard);
      
      debugPrint('BoardMindMapVm: Successfully initialized mind map with ${_contents.length} content nodes');
    } catch (e) {
      debugPrint('Error initializing mind map with content: $e');
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

  /// Select a node
  void selectNode(String? nodeId) {
    selectedNodeId = nodeId;
    selectedEdgeId = null;
    notifyListeners();
  }

  /// Select an edge
  void selectEdge(String? edgeId) {
    selectedEdgeId = edgeId;
    selectedNodeId = null;
    notifyListeners();
  }

  /// Start connecting from a node
  void startConnecting(String nodeId) {
    connectingFromNodeId = nodeId;
    notifyListeners();
  }

  /// Cancel connecting
  void cancelConnecting() {
    connectingFromNodeId = null;
    notifyListeners();
  }

  /// Update canvas scale
  void setScale(double newScale) {
    scale = newScale;
    notifyListeners();
  }

  /// Update pointer position for drawing temporary edge
  void updatePointerFromVisual(Offset visualPosition) {
    // Convert visual position to logical coordinates
    pointerLogical = visualPosition;
    notifyListeners();
  }

  /// Try to select edge at visual position
  bool trySelectEdgeAtVisual(Offset visualPosition) {
    // Implementation for edge selection hit testing
    // This would need to be implemented based on edge rendering logic
    return false;
  }

  /// Update viewport info (called by canvas)
  void updateViewportInfo(Size viewportSize, TransformationController controller) {
    // Update viewport information for coordinate transformations
  }

  /// Get the center of the currently visible area in canvas coordinates
  Offset getCurrentViewportCenter() {
    // Default to canvas center if no viewport info
    return const Offset(10000, 7500); // Center of canvas
  }

  /// Save mind map changes to database
  Future<void> _saveMindMapChanges() async {
    try {
      final updatedBoard = board.updateMindMap(_mindMap);
      await DatabaseHelper.instance.updateBoard(updatedBoard);
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

  @override
  void dispose() {
    super.dispose();
  }
}
