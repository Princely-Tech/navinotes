// edge_painter.dart
import 'package:flutter/material.dart';
import 'package:navinotes/models/mind_map_node.dart';
import 'package:navinotes/models/mind_map_edge.dart';
import 'board_mindmap_vm.dart';

extension OffsetExtensions on Offset {
  Offset normalized() {
    final d = distance;
    return d == 0 ? Offset.zero : this / d;
  }
}

class EdgePainter extends CustomPainter {
  final BoardMindMapVm vm;
  EdgePainter(this.vm) : super(repaint: vm);

  @override
  void paint(Canvas canvas, Size size) {
    final basePaint = Paint()..style = PaintingStyle.stroke;

    // Draw each edge as line between node boundaries
    for (final edge in vm.mindMap.edges) {
      final source = vm.mindMap.findNode(edge.sourceId);
      final target = vm.mindMap.findNode(edge.targetId);
      if (source == null || target == null) continue;
      final center1 = _nodeCenter(source);
      final center2 = _nodeCenter(target);
      final p1 = _edgePoint(source, center2);
      final p2 = _edgePoint(target, center1);

      // style
      final bool isSelected = vm.selectedEdgeId == edge.id;
      final Color color = (edge.color).withOpacity(edge.opacity);
      final double thickness = edge.thickness + (isSelected ? 1.5 : 0.0);
      final Paint paint =
          basePaint
            ..color = color
            ..strokeWidth = thickness
            ..strokeCap = StrokeCap.round;

      // draw line by type
      switch (edge.lineType) {
        case EdgeLineType.straight:
          _drawStraight(canvas, paint, p1, p2);
          break;
        case EdgeLineType.dashed:
          _drawDashed(canvas, paint, p1, p2, dash: 10, gap: 6);
          break;
        case EdgeLineType.dotted:
          _drawDashed(canvas, paint, p1, p2, dash: 2, gap: 6);
          break;
        case EdgeLineType.curved:
          _drawCurved(canvas, paint, p1, p2);
          break;
        case EdgeLineType.elbow:
          _drawElbow(canvas, paint, p1, p2);
          break;
      }

      // highlight overlay for selected edge
      if (isSelected) {
        final highlight =
            Paint()
              ..color = color.withOpacity((edge.opacity * 0.6).clamp(0.0, 1.0))
              ..strokeWidth = thickness + 3
              ..style = PaintingStyle.stroke
              ..strokeCap = StrokeCap.round;
        switch (edge.lineType) {
          case EdgeLineType.straight:
            _drawStraight(canvas, highlight, p1, p2);
            break;
          case EdgeLineType.dashed:
            _drawDashed(canvas, highlight, p1, p2, dash: 10, gap: 6);
            break;
          case EdgeLineType.dotted:
            _drawDashed(canvas, highlight, p1, p2, dash: 2, gap: 6);
            break;
          case EdgeLineType.curved:
            _drawCurved(canvas, highlight, p1, p2);
            break;
          case EdgeLineType.elbow:
            _drawElbow(canvas, highlight, p1, p2);
            break;
        }
      }

      // label
      if (edge.label != null && edge.label!.isNotEmpty) {
        final textPainter = TextPainter(
          text: TextSpan(
            text: edge.label!,
            style: const TextStyle(color: Colors.black, fontSize: 12),
          ),
          textDirection: TextDirection.ltr,
        )..layout();
        final mid = Offset((p1.dx + p2.dx) / 2, (p1.dy + p2.dy) / 2);
        textPainter.paint(
          canvas,
          mid - Offset(textPainter.width / 2, textPainter.height / 2),
        );
      }
    }

    // Draw temporary connecting line if in connect mode (Heptabase-style)
    if (vm.connectingFromNodeId != null) {
      final fromNode = vm.mindMap.findNode(vm.connectingFromNodeId!);
      if (fromNode != null && vm.pointerLogical != null) {
        final to = vm.pointerLogical!;
        final from = _edgePoint(fromNode, to);
        
        // Draw a more prominent connection line like Heptabase
        final tempPaint = Paint()
          ..color = Colors.blue.withOpacity(0.8)
          ..strokeWidth = 3.0
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round;
        
        // Draw background glow for better visibility
        final glowPaint = Paint()
          ..color = Colors.blue.withOpacity(0.3)
          ..strokeWidth = 6.0
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round;
        
        // Draw smooth curved line instead of dashed
        _drawSmoothConnectionLine(canvas, glowPaint, from, to);
        _drawSmoothConnectionLine(canvas, tempPaint, from, to);
        
        // Draw connection point indicator at mouse/touch position
        final pointPaint = Paint()
          ..color = Colors.blue
          ..style = PaintingStyle.fill;
        canvas.drawCircle(to, 8.0, pointPaint);
        
        // Draw inner white circle for better visibility
        final innerPaint = Paint()
          ..color = Colors.white
          ..style = PaintingStyle.fill;
        canvas.drawCircle(to, 4.0, innerPaint);
      }
    }
  }

  Offset _nodeCenter(MindMapNode node) {
    return Offset(
      node.position.dx + node.width / 2,
      node.position.dy + node.height / 2,
    );
  }

  /// Returns the point on the boundary of [node] in the direction of [towards].
  /// Handles common shapes; defaults to rectangle for unhandled ones.
  Offset _edgePoint(MindMapNode node, Offset towards) {
    final cx = node.position.dx + node.width / 2;
    final cy = node.position.dy + node.height / 2;
    final center = Offset(cx, cy);
    final v = towards - center;
    if (v == Offset.zero) return center;

    final halfW = node.width / 2;
    final halfH = node.height / 2;

    switch (node.shape) {
      case MindMapShape.circle:
        {
          final len = v.distance;
          if (len == 0) return center;
          final radius = halfW < halfH ? halfW : halfH;
          final dir = v / len;
          return center + dir * radius;
        }
      case MindMapShape.diamond:
        {
          // diamond (rhombus) boundary scaling using L1 norm
          final vx = v.dx.abs();
          final vy = v.dy.abs();
          final denom = (vx / halfW) + (vy / halfH);
          if (denom == 0) return center;
          final t = 1 / denom;
          return center + v * t;
        }
      case MindMapShape.pill:
      case MindMapShape.rounded:
      case MindMapShape.sharp:
      case MindMapShape.hexagon:
      case MindMapShape.parallelogram:
      case MindMapShape.octagon:
      case MindMapShape.trapezoid:
        {
          // Axis-aligned rectangle approximation for general shapes
          final vx = v.dx;
          final vy = v.dy;
          final sx = vx == 0 ? double.infinity : (halfW / vx.abs());
          final sy = vy == 0 ? double.infinity : (halfH / vy.abs());
          final t = sx < sy ? sx : sy;
          return center + v * t;
        }
    }
  }

  // -------- draw helpers --------
  void _drawStraight(Canvas canvas, Paint paint, Offset a, Offset b) {
    canvas.drawLine(a, b, paint);
  }

  void _drawDashed(
    Canvas canvas,
    Paint paint,
    Offset a,
    Offset b, {
    double dash = 8,
    double gap = 4,
  }) {
    final total = (b - a).distance;
    if (total == 0) return;
    final dir = (b - a) / total;
    double traveled = 0;
    while (traveled <= total) {
      final start = a + dir * traveled;
      final end = a + dir * (traveled + dash).clamp(0, total);
      canvas.drawLine(start, end, paint);
      traveled += dash + gap;
    }
  }

  void _drawCurved(Canvas canvas, Paint paint, Offset a, Offset b) {
    final mid = (a + b) / 2;
    // Offset control for a gentle arc; could be based on orientation
    final control = mid + const Offset(0, -40);
    final path =
        Path()
          ..moveTo(a.dx, a.dy)
          ..quadraticBezierTo(control.dx, control.dy, b.dx, b.dy);
    canvas.drawPath(path, paint);
  }

  void _drawElbow(Canvas canvas, Paint paint, Offset a, Offset b) {
    final mid = Offset(a.dx, b.dy);
    canvas.drawLine(a, mid, paint);
    canvas.drawLine(mid, b, paint);
  }
  
  void _drawSmoothConnectionLine(Canvas canvas, Paint paint, Offset a, Offset b) {
    // Calculate control points for a smooth S-curve like Heptabase
    final distance = (b - a).distance;
    final midPoint = (a + b) / 2;
    
    // Create control points based on the direction and distance
    final direction = (b - a);
    final perpendicular = Offset(-direction.dy, direction.dx).normalized();
    
    // Adjust curve intensity based on distance
    final curveIntensity = (distance * 0.3).clamp(30.0, 100.0);
    
    final controlPoint1 = a + direction * 0.3 + perpendicular * curveIntensity * 0.1;
    final controlPoint2 = b - direction * 0.3 - perpendicular * curveIntensity * 0.1;
    
    final path = Path()
      ..moveTo(a.dx, a.dy)
      ..cubicTo(
        controlPoint1.dx, controlPoint1.dy,
        controlPoint2.dx, controlPoint2.dy,
        b.dx, b.dy,
      );
    
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant EdgePainter oldDelegate) => true;
}
