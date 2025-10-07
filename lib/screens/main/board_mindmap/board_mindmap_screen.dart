import 'package:flutter/material.dart';
import 'package:navinotes/models/board.dart';
import 'package:navinotes/screens/main/board_mindmap/board_mindmap_vm.dart';
import 'package:navinotes/screens/main/board_mindmap/mind_map_vm_bridge.dart';
import 'package:navinotes/screens/main/choose_board/mind_map/mind_map_canvas.dart';
import 'package:navinotes/screens/main/choose_board/mind_map/mind_map_styling.dart';
import 'package:navinotes/screens/main/choose_board/mind_map/vm.dart';
import 'package:navinotes/settings/packages.dart';
import 'package:navinotes/widgets/board/mind_map_content_panel.dart';
import 'package:navinotes/widgets/index.dart';
import 'package:provider/provider.dart';

class BoardMindMapScreen extends StatelessWidget {
  BoardMindMapScreen({super.key});

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final Board board = ModalRoute.of(context)?.settings.arguments as Board;

    return ChangeNotifierProvider(
      create: (_) => BoardMindMapVm(board: board),
      child: Consumer<BoardMindMapVm>(
        builder: (_, boardVm, __) {
          // Show loading while initializing
          if (boardVm.isLoading) {
            return Scaffold(
              backgroundColor: AppTheme.white,
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text(
                      'Loading board...',
                      style: TextStyle(color: Colors.grey[600], fontSize: 16.0),
                    ),
                  ],
                ),
              ),
            );
          }

          // Create bridge to adapt BoardMindMapVm to MindMapVm interface
          final bridgeVm = MindMapVmBridge(boardVm);

          return ChangeNotifierProvider<MindMapVm>.value(
            value: bridgeVm,
            child: ScaffoldFrame(
              scaffoldKey: _scaffoldKey,
              backgroundColor:
                  boardVm.boardTheme.values.backgroundColor ==
                          AppTheme.transparent
                      ? AppTheme.white
                      : boardVm.boardTheme.values.backgroundColor,
              endDrawer: CustomDrawer(
                child: MindMapContentPanel(boardTheme: boardVm.boardTheme),
              ),

              body: Column(
                children: [
                  _buildBoardMindMapHeader(boardVm, bridgeVm),
                  Expanded(
                    child: Row(
                      children: [
                        // Left panel - Node styling (only show when mindmapNode is selected)
                        Consumer<MindMapVm>(
                          builder: (context, mindMapVm, child) {
                            // Check if there's a selected mindmapNode
                            final selectedNode =
                                mindMapVm.selectedNodeId != null
                                    ? mindMapVm.mindMap.findNode(
                                      mindMapVm.selectedNodeId!,
                                    )
                                    : null;
                            final selectedContent =
                                selectedNode?.contentID != null
                                    ? mindMapVm.getContentById(
                                      selectedNode!.contentID!,
                                    )
                                    : null;

                            // Only show styling panel for mindmapNode content type
                            final isMindMapNode =
                                selectedContent?.type ==
                                    AppContentType.mindmapNode ||
                                (selectedNode != null &&
                                    selectedContent == null);

                            if (!isMindMapNode) {
                              return const SizedBox.shrink();
                            }

                            return VisibleController(
                              mobile: false,
                              desktop: true,
                              child: WidthLimiter(
                                mobile: 280,
                                child: MindMapStyling(
                                  boardTheme: boardVm.boardTheme,
                                  vm: bridgeVm,
                                ),
                              ),
                            );
                          },
                        ),
                        // Center - Mind map canvas
                        Expanded(
                          child: Container(
                            color: Colors.transparent,
                            child: const MindMapCanvas(),
                          ),
                        ),
                        // Right panel - Content preview (only show when content is selected)
                        Consumer<MindMapVm>(
                          builder: (context, mindMapVm, child) {
                            // Check if there's a selected node with content
                            final selectedNode =
                                mindMapVm.selectedNodeId != null
                                    ? mindMapVm.mindMap.findNode(
                                      mindMapVm.selectedNodeId!,
                                    )
                                    : null;
                            final hasSelectedContent =
                                selectedNode?.contentID != null ||
                                (selectedNode != null &&
                                    selectedNode.text.isNotEmpty);

                            // Only show panel if there's selected content
                            if (!hasSelectedContent) {
                              return const SizedBox.shrink();
                            }

                            return VisibleController(
                              mobile: false,
                              laptop: true,
                              child: WidthLimiter(
                                mobile: 320,
                                child: MindMapContentPanel(
                                  boardTheme: boardVm.boardTheme,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBoardMindMapHeader(BoardMindMapVm boardVm, MindMapVm bridgeVm) {
    final themeValues = boardVm.boardTheme.values;
    return Container(
      decoration: themeValues.mainHeaderDecoration.copyWith(
        color:
            themeValues.mainHeaderDecoration.color ??
            (themeValues.backgroundColor == AppTheme.transparent
                ? AppTheme.ghostWhite
                : themeValues.backgroundColor),
        border:
            themeValues.mainHeaderDecoration.border ??
            Border(bottom: BorderSide(color: themeValues.borderColor)),
      ),
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return ScrollableController(
            scrollDirection: Axis.horizontal,
            child: Container(
              constraints: BoxConstraints(minWidth: constraints.maxWidth),
              child: Row(
                spacing: 30,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // _stylingToggleButton(boardVm),
                  _menuButton(boardVm),
                  Row(
                    children: [
                      InkWell(
                        onTap: NavigationHelper.pop,
                        child: Icon(
                          Icons.arrow_back,
                          color: themeValues.color1,
                        ),
                      ),
                      SizedBox(width: 10),
                      _title(boardVm),
                    ],
                  ),
                  Row(
                    children: [
                      VisibleController(
                        mobile: true,
                        laptop: false,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: MenuButton(
                            decoration: BoxDecoration(
                              color: AppTheme.darkMossGreen,
                            ),
                            onPressed:
                                () =>
                                    _scaffoldKey.currentState?.openEndDrawer(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  _boardMindMapControlButtons(context, boardVm, bridgeVm),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _title(BoardMindMapVm vm) {
    final themeValues = vm.boardTheme.values;
    return Text(
      vm.board.name,
      style: AppTheme.text.copyWith(
        color: themeValues.color1,
        fontSize: 20.0,
        fontFamily: themeValues.fontFamily,
        fontWeight: getFontWeight(500),
      ),
    );
  }

  Widget _menuButton(BoardMindMapVm boardVm) {
    Color color = AppTheme.darkMossGreen;
    switch (boardVm.boardTheme) {
      case BoardTheme.plain:
        color = AppTheme.black;
        break;
      default:
    }
    return VisibleController(
      mobile: true,
      desktop: false,
      child: Padding(
        padding: const EdgeInsets.only(right: 10),
        child: MenuButton(
          decoration: BoxDecoration(color: color),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
      ),
    );
  }

  Widget stylingToggleButton(BoardMindMapVm boardVm) {
    Color color = AppTheme.darkMossGreen;
    switch (boardVm.boardTheme) {
      case BoardTheme.plain:
        color = AppTheme.black;
        break;
      default:
    }
    return VisibleController(
      mobile: false,
      desktop: true,
      child: Padding(
        padding: const EdgeInsets.only(right: 5),
        child: MenuButton(
          decoration: BoxDecoration(color: color),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
      ),
    );
  }

  Widget _boardMindMapControlButtons(
    BuildContext context,
    BoardMindMapVm boardVm,
    MindMapVm bridgeVm,
  ) {
    return Row(
      spacing: 8,
      children: [
        // Add Node button
        ElevatedButton.icon(
          onPressed: () {
            // Add node at center of currently visible viewport
            final centerPosition = bridgeVm.getCurrentViewportCenter();
            bridgeVm.addNodeAt(
              text: 'New node',
              logicalPosition: centerPosition,
            );
          },
          icon: const Icon(Icons.add, size: 16),
          label: const Text('Add node'),
          style: ElevatedButton.styleFrom(
            minimumSize: Size(0, 32),
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            textStyle: TextStyle(fontSize: 12),
          ),
        ),

        // Add Content button
        PopupMenuButton<String>(
          icon: Icon(Icons.library_add, size: 18),
          tooltip: 'Add Content',
          onSelected: (value) => boardVm.handleAddContent(value),
          itemBuilder:
              (context) => [
                PopupMenuItem(
                  value: 'note',
                  child: Row(
                    children: [
                      Icon(Icons.note_add, size: 16),
                      SizedBox(width: 8),
                      Text('Add Note'),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'file',
                  child: Row(
                    children: [
                      Icon(Icons.upload_file, size: 16),
                      SizedBox(width: 8),
                      Text('Import File'),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'flashcard',
                  child: Row(
                    children: [
                      Icon(Icons.quiz, size: 16),
                      SizedBox(width: 8),
                      Text('Create Flashcards'),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'notebook',
                  child: Row(
                    children: [
                      Icon(Icons.book, size: 16),
                      SizedBox(width: 8),
                      Text('Create Notebook'),
                    ],
                  ),
                ),
              ],
        ),

        // Zoom controls
        IconButton(
          tooltip: 'Zoom in',
          onPressed: bridgeVm.zoomIn,
          icon: const Icon(Icons.zoom_in, size: 18),
          constraints: BoxConstraints(minWidth: 32, minHeight: 32),
        ),
        IconButton(
          tooltip: 'Zoom out',
          onPressed: bridgeVm.zoomOut,
          icon: const Icon(Icons.zoom_out, size: 18),
          constraints: BoxConstraints(minWidth: 32, minHeight: 32),
        ),
        IconButton(
          tooltip: 'Reset zoom & pan',
          onPressed: bridgeVm.resetZoom,
          icon: const Icon(Icons.center_focus_strong, size: 18),
          constraints: BoxConstraints(minWidth: 32, minHeight: 32),
        ),
        IconButton(
          tooltip: 'Fit to content',
          onPressed: () {
            // Trigger view centering on content
            boardVm.centerViewOnContent();
          },
          icon: const Icon(Icons.fit_screen, size: 18),
          constraints: BoxConstraints(minWidth: 32, minHeight: 32),
        ),
      ],
    );
  }
}
