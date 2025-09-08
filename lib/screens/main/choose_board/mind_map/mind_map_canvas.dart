// mind_map_canvas.dart
import 'package:flutter/material.dart';
import 'package:navinotes/settings/packages.dart';
import 'package:provider/provider.dart';
import 'package:vector_math/vector_math_64.dart';
import 'vm.dart';
import 'mind_map_node_widget.dart';
import 'edge_painter.dart';
import 'package:navinotes/models/content.dart';
import 'package:navinotes/models/flashcard_deck.dart';

class MindMapCanvas extends StatefulWidget {
  const MindMapCanvas({super.key});

  @override
  State<MindMapCanvas> createState() => _MindMapCanvasState();
}

class _MindMapCanvasState extends State<MindMapCanvas> {
  final TransformationController _transformationController =
      TransformationController();

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MindMapVm>(
      builder: (_, vm, __) {
        return LayoutBuilder(
          builder: (context, constraints) {
            // Update VM with current viewport info
            vm.updateViewportInfo(
              constraints.biggest,
              _transformationController,
            );

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
                return ClipRect(
                  child: Container(
                    decoration:
                        isDragOver
                            ? BoxDecoration(
                              border: Border.all(
                                color: AppTheme.cerulean.withValues(alpha: 0.5),
                                width: 2,
                              ),
                              color: AppTheme.cerulean.withValues(alpha: 0.1),
                            )
                            : null,
                    child: InteractiveViewer(
                      transformationController: _transformationController,
                      boundaryMargin: EdgeInsets.all(50),
                      minScale: 0.1,
                      maxScale: 4.0,
                      constrained: false,
                      scaleEnabled: true,
                      panEnabled: true,
                      clipBehavior: Clip.none,
                      onInteractionUpdate: (details) {
                        // Update VM scale when user zooms
                        vm.setScale(details.scale);
                      },
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTapDown: (details) {
                          if (vm.connectingFromNodeId != null) {
                            vm.cancelConnecting();
                            vm.updatePointerFromVisual(details.localPosition);
                          } else {
                            final hit = vm.trySelectEdgeAtVisual(
                              details.localPosition,
                            );
                            if (!hit) {
                              vm.selectEdge(null);
                              vm.selectNode(null);
                            }
                          }
                        },
                        child: Container(
                          width: MindMapVm.canvasWidth,
                          height: MindMapVm.canvasHeight,
                          color: AppTheme.transparent,
                          child: Stack(
                            children: [
                              // edges painter (below nodes)
                              Positioned.fill(
                                child: CustomPaint(painter: EdgePainter(vm)),
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
    // Convert global screen coordinates to logical canvas coordinates
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final localOffset = renderBox.globalToLocal(offset);

    // Transform the local offset through the InteractiveViewer's transformation
    final Matrix4 transform = _transformationController.value;
    final Matrix4 invertedTransform = Matrix4.inverted(transform);
    final Vector3 transformedPoint = invertedTransform.transform3(
      Vector3(localOffset.dx, localOffset.dy, 0),
    );
    final dropPosition = Offset(transformedPoint.x, transformedPoint.y);

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
