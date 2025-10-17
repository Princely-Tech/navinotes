import 'package:flutter/material.dart';
import 'package:navinotes/models/board.dart';
import 'package:navinotes/screens/main/board_mindmap/board_mindmap_vm.dart';
import 'mind_map_canvas.dart';
import 'mind_map_styling.dart';
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
      create: (_) => BoardMindMapVm(board: board, scaffoldKey: _scaffoldKey),
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

          return ChangeNotifierProvider<BoardMindMapVm>.value(
            value: boardVm,
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
              drawer: CustomDrawer(
                child: MindMapStyling(
                  boardTheme: boardVm.boardTheme,
                  vm: boardVm,
                ),
              ),
              body: Column(
                children: [
                  _buildBoardMindMapHeader(boardVm),
                  Expanded(
                    child: Row(
                      children: [
                        // Left panel - Node styling (only show when design icon is clicked AND node is selected)
                        Consumer<BoardMindMapVm>(
                          builder: (context, mindMapVm, child) {
                            // Check if there's a selected node
                            final hasSelectedNode =
                                mindMapVm.selectedNodeId != null;

                            // Show styling panel only when node is selected AND design icon was clicked
                            if (!mindMapVm.isStylingPanelVisible ||
                                !hasSelectedNode) {
                              return const SizedBox.shrink();
                            }

                            return VisibleController(
                              mobile: true,
                              desktop: true,
                              child: WidthLimiter(
                                mobile: 280,
                                child: MindMapStyling(
                                  boardTheme: boardVm.boardTheme,
                                  vm: boardVm,
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
                        Consumer<BoardMindMapVm>(
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
                              mobile: true,
                              laptop: true,
                              child: WidthLimiter(
                                mobile: 500,
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

  Widget _buildBoardMindMapHeader(BoardMindMapVm boardVm) {
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
                  _boardMindMapControlButtons(context, boardVm),
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

  Widget _boardMindMapControlButtons(
    BuildContext context,
    BoardMindMapVm boardVm,
  ) {
    return Row(
      spacing: 8,
      children: [
        // Add Node button
        ElevatedButton.icon(
          onPressed: () {
            // Add node at center of currently visible viewport
            final centerPosition = boardVm.getCurrentViewportCenter();
            boardVm.addNodeAt(
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

        // Zoom controls
        IconButton(
          tooltip: 'Zoom in',
          onPressed: boardVm.zoomIn,
          icon: const Icon(Icons.zoom_in, size: 18),
          constraints: BoxConstraints(minWidth: 32, minHeight: 32),
        ),
        IconButton(
          tooltip: 'Zoom out',
          onPressed: boardVm.zoomOut,
          icon: const Icon(Icons.zoom_out, size: 18),
          constraints: BoxConstraints(minWidth: 32, minHeight: 32),
        ),
        IconButton(
          tooltip: 'Reset zoom & pan',
          onPressed: boardVm.resetZoom,
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
