// edge_painter.dart
import 'package:flutter/material.dart';
import 'package:navinotes/models/mind_map_node.dart';
import 'vm.dart';

class EdgePainter extends CustomPainter {
  final MindMapVm vm;
  EdgePainter(this.vm) : super(repaint: vm);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.shade700
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    // Draw each edge as smooth line (simple straight line here)
    for (final edge in vm.mindMap.edges) {
      final source = vm.mindMap.findNode(edge.sourceId);
      final target = vm.mindMap.findNode(edge.targetId);
      if (source == null || target == null) continue;
      final p1 = _nodeCenter(source);
      final p2 = _nodeCenter(target);

      // draw line
      canvas.drawLine(p1, p2, paint);

      // label
      if (edge.label != null && edge.label!.isNotEmpty) {
        final textPainter = TextPainter(
          text: TextSpan(text: edge.label!, style: const TextStyle(color: Colors.black, fontSize: 12)),
          textDirection: TextDirection.ltr,
        )..layout();
        final mid = Offset((p1.dx + p2.dx) / 2, (p1.dy + p2.dy) / 2);
        textPainter.paint(canvas, mid - Offset(textPainter.width / 2, textPainter.height / 2));
      }
    }

    // Draw temporary connecting line if in connect mode
    if (vm.connectingFromNodeId != null) {
      final fromNode = vm.mindMap.findNode(vm.connectingFromNodeId!);
      if (fromNode != null && vm.pointerLogical != null) {
        final from = _nodeCenter(fromNode);
        final to = vm.pointerLogical!;
        final tempPaint = Paint()
          ..color = Colors.blueAccent
          ..strokeWidth = 2.0
          ..style = PaintingStyle.stroke;
        canvas.drawLine(from, to, tempPaint);
      }
    }
  }

  Offset _nodeCenter(MindMapNode node) {
    return Offset(node.position.dx + node.width / 2, node.position.dy + node.height / 2);
  }

  @override
  bool shouldRepaint(covariant EdgePainter oldDelegate) => true;
}