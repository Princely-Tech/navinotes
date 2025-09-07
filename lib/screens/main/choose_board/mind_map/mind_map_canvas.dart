// mind_map_canvas.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'vm.dart';
import 'mind_map_node_widget.dart';
import 'edge_painter.dart';
import 'package:navinotes/models/content.dart';
import 'package:navinotes/models/flashcard_deck.dart';

class MindMapCanvas extends StatelessWidget {
  const MindMapCanvas({super.key});

  // In mind_map_canvas.dart
  @override
  Widget build(BuildContext context) {
    return Consumer<MindMapVm>(
      builder: (_, vm, __) {
        return LayoutBuilder(
          builder: (context, constraints) {
            return DragTarget<Object>(
              onWillAcceptWithDetails: (details) {
                // Accept Content or FlashCardDeck objects
                return details.data is Content || details.data is FlashCardDeck;
              },
              onAcceptWithDetails: (details) {
                // Handle the drop - create a new node with the content attached
                _handleDrop(context, vm, details.data, details.offset);
              },
              builder: (context, candidateData, rejectedData) {
                final isDragOver = candidateData.isNotEmpty;
                return Container(
                  decoration:
                      isDragOver
                          ? BoxDecoration(
                            border: Border.all(
                              color: Colors.blue.withOpacity(0.5),
                              width: 2,
                            ),
                            color: Colors.blue.withOpacity(0.1),
                          )
                          : null,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTapDown: (details) {
                      // Update pointer for connection line
                      if (vm.connectingFromNodeId != null) {
                        vm.cancelConnecting();

                        vm.updatePointerFromVisual(details.localPosition);
                      } else {
                        // Try select an edge first
                        final hit = vm.trySelectEdgeAtVisual(
                          details.localPosition,
                        );
                        if (!hit) {
                          // Deselect both if tapping empty space
                          vm.selectEdge(null);
                          vm.selectNode(null);
                        }
                      }
                    },
                    onPanUpdate: (details) {
                      // Always update pointer position during pan
                      if (vm.connectingFromNodeId != null) {
                        // Convert to local position within the canvas
                        final box = context.findRenderObject() as RenderBox;
                        final localPosition = box.globalToLocal(
                          details.globalPosition,
                        );
                        vm.updatePointerFromVisual(localPosition);
                      }
                      // Only pan the canvas if we're not connecting or dragging a node
                      if (vm.draggingNodeId == null &&
                          vm.connectingFromNodeId == null) {
                        vm.panCanvasBy(details.delta);
                      }
                    },
                    onPanEnd: (_) {
                      if (vm.connectingFromNodeId != null) {
                        // If we were connecting and didn't connect to a node, cancel
                        vm.cancelConnecting();
                      }
                    },
                    child: ClipRect(
                      child: Container(
                        color: Colors.transparent,
                        child: Transform.scale(
                          scale: vm.scale,
                          alignment: Alignment.topLeft,
                          child: Transform.translate(
                            offset: vm.canvasOffset,
                            child: SizedBox(
                              width: 20000,
                              height: 15000,
                              child: Stack(
                                children: [
                                  // edges painter (below nodes)
                                  Positioned.fill(
                                    child: CustomPaint(
                                      painter: EdgePainter(vm),
                                    ),
                                  ),

                                  // nodes
                                  for (final node in vm.mindMap.nodes)
                                    Positioned(
                                      left: node.position.dx,
                                      top: node.position.dy,
                                      width: node.width,
                                      height: node.height,
                                      child: MindMapNodeWidget(node: node),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  void _handleDrop(
    BuildContext context,
    MindMapVm vm,
    dynamic data,
    Offset offset,
  ) {
    // Calculate drop position in logical coordinates
    final dropPosition = vm.visualToLogical(offset);

    if (data is Content) {
      if (data.id != null) {
        final title =
            data.title.isNotEmpty ? data.title : (data.file ?? 'Untitled');
        vm.addNodeWithContent(
          text: title,
          logicalPosition: dropPosition,
          contentId: data.id!,
        );
      }
    } else if (data is FlashCardDeck) {
      if (data.id != null) {
        vm.addNodeWithDeck(
          text: data.name,
          logicalPosition: dropPosition,
          deckId: data.id!,
        );
      }
    }
  }
}
