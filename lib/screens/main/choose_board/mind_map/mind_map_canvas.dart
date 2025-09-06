// mind_map_canvas.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'vm.dart';
import 'mind_map_node_widget.dart';
import 'edge_painter.dart';

class MindMapCanvas extends StatelessWidget {
  const MindMapCanvas({super.key});

  // In mind_map_canvas.dart
  @override
  Widget build(BuildContext context) {
    return Consumer<MindMapVm>(
      builder: (_, vm, __) {
        return LayoutBuilder(
          builder: (context, constraints) {
            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTapDown: (details) {
                // Update pointer for connection line
                if (vm.connectingFromNodeId != null) {
                  vm.cancelConnecting();
                  
                  vm.updatePointerFromVisual(details.localPosition);
                }
                // Deselect if tapping empty space
                vm.selectNode(null);
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
                        width: 3000,
                        height: 2000,
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
              ),
            );
          },
        );
      },
    );
  }
}
