// mind_map_canvas.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'vm.dart';
import 'mind_map_node_widget.dart';
import 'edge_painter.dart';

class MindMapCanvas extends StatelessWidget {
  const MindMapCanvas({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MindMapVm>(builder: (_, vm, __) {
      return LayoutBuilder(builder: (context, constraints) {
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapDown: (details) {
            vm.updatePointerFromVisual(details.localPosition);
            // deselect if tapped background
            vm.selectNode(null);
          },
          onPanStart: (details) {
            // If we are dragging a node, don't pan canvas here (node will handle movement)
            if (vm.draggingNodeId != null) return;
            // start panning
          },
          onPanUpdate: (details) {
            // update pointer for temporary edge
            vm.updatePointerFromVisual(details.localPosition);
            // if dragging node, ignore canvas pan here
            if (vm.draggingNodeId != null) return;
            // pan canvas
            vm.panCanvasBy(details.delta);
          },
          onPanEnd: (_) {
            vm.pointerLogical = null;
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
                    // make a large virtual canvas to allow space
                    width: 3000,
                    height: 2000,
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
        );
      });
    });
  }
}