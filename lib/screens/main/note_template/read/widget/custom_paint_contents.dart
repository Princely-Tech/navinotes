import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_drawing_board/paint_contents.dart';

/// Custom triangle paint content
class Triangle extends PaintContent {
  Triangle();

  Triangle.data({
    required this.startPoint,
    required this.endPoint,
    required Paint paint,
  }) : super.paint(paint);

  Offset startPoint = Offset.zero;
  Offset endPoint = Offset.zero;

  @override
  void startDraw(Offset startPoint) => this.startPoint = startPoint;

  @override
  void drawing(Offset nowPoint) => endPoint = nowPoint;

  @override
  void draw(Canvas canvas, Size size, bool repaint) {
    final double width = (endPoint.dx - startPoint.dx).abs();
    final double height = (endPoint.dy - startPoint.dy).abs();
    
    if (width < 2 || height < 2) return;

    final Path path = Path();
    
    // Create triangle points
    final Offset topPoint = Offset(startPoint.dx + width / 2, startPoint.dy);
    final Offset bottomLeft = Offset(startPoint.dx, startPoint.dy + height);
    final Offset bottomRight = Offset(startPoint.dx + width, startPoint.dy + height);
    
    path.moveTo(topPoint.dx, topPoint.dy);
    path.lineTo(bottomLeft.dx, bottomLeft.dy);
    path.lineTo(bottomRight.dx, bottomRight.dy);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  Triangle copy() => Triangle();

  @override
  Map<String, dynamic> toContentJson() {
    return <String, dynamic>{
      'type': 'Triangle',
      'startPoint': <String, dynamic>{
        'dx': startPoint.dx,
        'dy': startPoint.dy,
      },
      'endPoint': <String, dynamic>{
        'dx': endPoint.dx,
        'dy': endPoint.dy,
      },
      'paint': <String, dynamic>{
        'blendMode': paint.blendMode.index,
        'color': paint.color.value,
        'filterQuality': paint.filterQuality.index,
        'invertColors': paint.invertColors,
        'isAntiAlias': paint.isAntiAlias,
        'strokeCap': paint.strokeCap.index,
        'strokeJoin': paint.strokeJoin.index,
        'strokeWidth': paint.strokeWidth,
        'style': paint.style.index,
      },
    };
  }
}

/// Custom diamond paint content
class Diamond extends PaintContent {
  Diamond();

  Diamond.data({
    required this.startPoint,
    required this.endPoint,
    required Paint paint,
  }) : super.paint(paint);

  Offset startPoint = Offset.zero;
  Offset endPoint = Offset.zero;

  @override
  void startDraw(Offset startPoint) => this.startPoint = startPoint;

  @override
  void drawing(Offset nowPoint) => endPoint = nowPoint;

  @override
  void draw(Canvas canvas, Size size, bool repaint) {
    final double width = (endPoint.dx - startPoint.dx).abs();
    final double height = (endPoint.dy - startPoint.dy).abs();
    
    if (width < 2 || height < 2) return;

    final Path path = Path();
    
    // Create diamond points
    final Offset top = Offset(startPoint.dx + width / 2, startPoint.dy);
    final Offset right = Offset(startPoint.dx + width, startPoint.dy + height / 2);
    final Offset bottom = Offset(startPoint.dx + width / 2, startPoint.dy + height);
    final Offset left = Offset(startPoint.dx, startPoint.dy + height / 2);
    
    path.moveTo(top.dx, top.dy);
    path.lineTo(right.dx, right.dy);
    path.lineTo(bottom.dx, bottom.dy);
    path.lineTo(left.dx, left.dy);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  Diamond copy() => Diamond();

  @override
  Map<String, dynamic> toContentJson() {
    return <String, dynamic>{
      'type': 'Diamond',
      'startPoint': <String, dynamic>{
        'dx': startPoint.dx,
        'dy': startPoint.dy,
      },
      'endPoint': <String, dynamic>{
        'dx': endPoint.dx,
        'dy': endPoint.dy,
      },
      'paint': <String, dynamic>{
        'blendMode': paint.blendMode.index,
        'color': paint.color.value,
        'filterQuality': paint.filterQuality.index,
        'invertColors': paint.invertColors,
        'isAntiAlias': paint.isAntiAlias,
        'strokeCap': paint.strokeCap.index,
        'strokeJoin': paint.strokeJoin.index,
        'strokeWidth': paint.strokeWidth,
        'style': paint.style.index,
      },
    };
  }
}

/// Custom pentagon paint content
class Pentagon extends PaintContent {
  Pentagon();

  Pentagon.data({
    required this.startPoint,
    required this.endPoint,
    required Paint paint,
  }) : super.paint(paint);

  Offset startPoint = Offset.zero;
  Offset endPoint = Offset.zero;

  @override
  void startDraw(Offset startPoint) => this.startPoint = startPoint;

  @override
  void drawing(Offset nowPoint) => endPoint = nowPoint;

  @override
  void draw(Canvas canvas, Size size, bool repaint) {
    final double width = (endPoint.dx - startPoint.dx).abs();
    final double height = (endPoint.dy - startPoint.dy).abs();
    
    if (width < 2 || height < 2) return;

    final Path path = Path();
    final Offset center = Offset(startPoint.dx + width / 2, startPoint.dy + height / 2);
    final double radius = math.min(width, height) / 2;
    
    // Create pentagon points
    for (int i = 0; i < 5; i++) {
      final double angle = (i * 2 * math.pi / 5) - math.pi / 2; // Start from top
      final double x = center.dx + radius * math.cos(angle);
      final double y = center.dy + radius * math.sin(angle);
      
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  Pentagon copy() => Pentagon();

  @override
  Map<String, dynamic> toContentJson() {
    return <String, dynamic>{
      'type': 'Pentagon',
      'startPoint': <String, dynamic>{
        'dx': startPoint.dx,
        'dy': startPoint.dy,
      },
      'endPoint': <String, dynamic>{
        'dx': endPoint.dx,
        'dy': endPoint.dy,
      },
      'paint': <String, dynamic>{
        'blendMode': paint.blendMode.index,
        'color': paint.color.value,
        'filterQuality': paint.filterQuality.index,
        'invertColors': paint.invertColors,
        'isAntiAlias': paint.isAntiAlias,
        'strokeCap': paint.strokeCap.index,
        'strokeJoin': paint.strokeJoin.index,
        'strokeWidth': paint.strokeWidth,
        'style': paint.style.index,
      },
    };
  }
}

/// Custom hexagon paint content
class Hexagon extends PaintContent {
  Hexagon();

  Hexagon.data({
    required this.startPoint,
    required this.endPoint,
    required Paint paint,
  }) : super.paint(paint);

  Offset startPoint = Offset.zero;
  Offset endPoint = Offset.zero;

  @override
  void startDraw(Offset startPoint) => this.startPoint = startPoint;

  @override
  void drawing(Offset nowPoint) => endPoint = nowPoint;

  @override
  void draw(Canvas canvas, Size size, bool repaint) {
    final double width = (endPoint.dx - startPoint.dx).abs();
    final double height = (endPoint.dy - startPoint.dy).abs();
    
    if (width < 2 || height < 2) return;

    final Path path = Path();
    final Offset center = Offset(startPoint.dx + width / 2, startPoint.dy + height / 2);
    final double radius = math.min(width, height) / 2;
    
    // Create hexagon points
    for (int i = 0; i < 6; i++) {
      final double angle = (i * 2 * math.pi / 6) - math.pi / 2; // Start from top
      final double x = center.dx + radius * math.cos(angle);
      final double y = center.dy + radius * math.sin(angle);
      
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  Hexagon copy() => Hexagon();

  @override
  Map<String, dynamic> toContentJson() {
    return <String, dynamic>{
      'type': 'Hexagon',
      'startPoint': <String, dynamic>{
        'dx': startPoint.dx,
        'dy': startPoint.dy,
      },
      'endPoint': <String, dynamic>{
        'dx': endPoint.dx,
        'dy': endPoint.dy,
      },
      'paint': <String, dynamic>{
        'blendMode': paint.blendMode.index,
        'color': paint.color.value,
        'filterQuality': paint.filterQuality.index,
        'invertColors': paint.invertColors,
        'isAntiAlias': paint.isAntiAlias,
        'strokeCap': paint.strokeCap.index,
        'strokeJoin': paint.strokeJoin.index,
        'strokeWidth': paint.strokeWidth,
        'style': paint.style.index,
      },
    };
  }
}

/// Custom star paint content
class Star extends PaintContent {
  Star();

  Star.data({
    required this.startPoint,
    required this.endPoint,
    required Paint paint,
  }) : super.paint(paint);

  Offset startPoint = Offset.zero;
  Offset endPoint = Offset.zero;

  @override
  void startDraw(Offset startPoint) => this.startPoint = startPoint;

  @override
  void drawing(Offset nowPoint) => endPoint = nowPoint;

  @override
  void draw(Canvas canvas, Size size, bool repaint) {
    final double width = (endPoint.dx - startPoint.dx).abs();
    final double height = (endPoint.dy - startPoint.dy).abs();
    
    if (width < 2 || height < 2) return;

    final Path path = Path();
    final Offset center = Offset(startPoint.dx + width / 2, startPoint.dy + height / 2);
    final double outerRadius = math.min(width, height) / 2;
    final double innerRadius = outerRadius * 0.4;
    
    // Create 5-pointed star
    for (int i = 0; i < 10; i++) {
      final double angle = (i * math.pi / 5) - math.pi / 2; // Start from top
      final double radius = i.isEven ? outerRadius : innerRadius;
      final double x = center.dx + radius * math.cos(angle);
      final double y = center.dy + radius * math.sin(angle);
      
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  Star copy() => Star();

  @override
  Map<String, dynamic> toContentJson() {
    return <String, dynamic>{
      'type': 'Star',
      'startPoint': <String, dynamic>{
        'dx': startPoint.dx,
        'dy': startPoint.dy,
      },
      'endPoint': <String, dynamic>{
        'dx': endPoint.dx,
        'dy': endPoint.dy,
      },
      'paint': <String, dynamic>{
        'blendMode': paint.blendMode.index,
        'color': paint.color.value,
        'filterQuality': paint.filterQuality.index,
        'invertColors': paint.invertColors,
        'isAntiAlias': paint.isAntiAlias,
        'strokeCap': paint.strokeCap.index,
        'strokeJoin': paint.strokeJoin.index,
        'strokeWidth': paint.strokeWidth,
        'style': paint.style.index,
      },
    };
  }
}

/// Custom heart paint content
class Heart extends PaintContent {
  Heart();

  Heart.data({
    required this.startPoint,
    required this.endPoint,
    required Paint paint,
  }) : super.paint(paint);

  Offset startPoint = Offset.zero;
  Offset endPoint = Offset.zero;

  @override
  void startDraw(Offset startPoint) => this.startPoint = startPoint;

  @override
  void drawing(Offset nowPoint) => endPoint = nowPoint;

  @override
  void draw(Canvas canvas, Size size, bool repaint) {
    final double width = (endPoint.dx - startPoint.dx).abs();
    final double height = (endPoint.dy - startPoint.dy).abs();
    
    if (width < 2 || height < 2) return;

    final Path path = Path();
    final double centerX = startPoint.dx + width / 2;
    final double centerY = startPoint.dy + height * 0.3;
    final double heartWidth = width * 0.8;
    final double heartHeight = height * 0.8;
    
    // Create heart shape using cubic bezier curves
    path.moveTo(centerX, centerY + heartHeight * 0.3);
    
    // Left curve
    path.cubicTo(
      centerX - heartWidth * 0.5, centerY - heartHeight * 0.1,
      centerX - heartWidth * 0.5, centerY + heartHeight * 0.3,
      centerX, centerY + heartHeight * 0.7,
    );
    
    // Right curve
    path.cubicTo(
      centerX + heartWidth * 0.5, centerY + heartHeight * 0.3,
      centerX + heartWidth * 0.5, centerY - heartHeight * 0.1,
      centerX, centerY + heartHeight * 0.3,
    );

    canvas.drawPath(path, paint);
  }

  @override
  Heart copy() => Heart();

  @override
  Map<String, dynamic> toContentJson() {
    return <String, dynamic>{
      'type': 'Heart',
      'startPoint': <String, dynamic>{
        'dx': startPoint.dx,
        'dy': startPoint.dy,
      },
      'endPoint': <String, dynamic>{
        'dx': endPoint.dx,
        'dy': endPoint.dy,
      },
      'paint': <String, dynamic>{
        'blendMode': paint.blendMode.index,
        'color': paint.color.value,
        'filterQuality': paint.filterQuality.index,
        'invertColors': paint.invertColors,
        'isAntiAlias': paint.isAntiAlias,
        'strokeCap': paint.strokeCap.index,
        'strokeJoin': paint.strokeJoin.index,
        'strokeWidth': paint.strokeWidth,
        'style': paint.style.index,
      },
    };
  }
}

/// Custom arrow paint content
class ArrowStraight extends PaintContent {
  ArrowStraight();

  ArrowStraight.data({
    required this.startPoint,
    required this.endPoint,
    required Paint paint,
  }) : super.paint(paint);

  Offset startPoint = Offset.zero;
  Offset endPoint = Offset.zero;

  @override
  void startDraw(Offset startPoint) => this.startPoint = startPoint;

  @override
  void drawing(Offset nowPoint) => endPoint = nowPoint;

  @override
  void draw(Canvas canvas, Size size, bool repaint) {
    if ((endPoint - startPoint).distance < 2) return;

    final Path path = Path();
    
    // Calculate arrow direction
    final Offset direction = endPoint - startPoint;
    final double angle = math.atan2(direction.dy, direction.dx);
    final double arrowHeadLength = math.min(direction.distance * 0.3, 20);
    final double arrowHeadAngle = math.pi / 6; // 30 degrees
    
    // Draw main line
    path.moveTo(startPoint.dx, startPoint.dy);
    path.lineTo(endPoint.dx, endPoint.dy);
    
    // Draw arrow head
    final double leftArrowX = endPoint.dx - arrowHeadLength * math.cos(angle - arrowHeadAngle);
    final double leftArrowY = endPoint.dy - arrowHeadLength * math.sin(angle - arrowHeadAngle);
    final double rightArrowX = endPoint.dx - arrowHeadLength * math.cos(angle + arrowHeadAngle);
    final double rightArrowY = endPoint.dy - arrowHeadLength * math.sin(angle + arrowHeadAngle);
    
    path.moveTo(endPoint.dx, endPoint.dy);
    path.lineTo(leftArrowX, leftArrowY);
    path.moveTo(endPoint.dx, endPoint.dy);
    path.lineTo(rightArrowX, rightArrowY);

    canvas.drawPath(path, paint);
  }

  @override
  ArrowStraight copy() => ArrowStraight();

  @override
  Map<String, dynamic> toContentJson() {
    return <String, dynamic>{
      'type': 'ArrowStraight',
      'startPoint': <String, dynamic>{
        'dx': startPoint.dx,
        'dy': startPoint.dy,
      },
      'endPoint': <String, dynamic>{
        'dx': endPoint.dx,
        'dy': endPoint.dy,
      },
      'paint': <String, dynamic>{
        'blendMode': paint.blendMode.index,
        'color': paint.color.value,
        'filterQuality': paint.filterQuality.index,
        'invertColors': paint.invertColors,
        'isAntiAlias': paint.isAntiAlias,
        'strokeCap': paint.strokeCap.index,
        'strokeJoin': paint.strokeJoin.index,
        'strokeWidth': paint.strokeWidth,
        'style': paint.style.index,
      },
    };
  }
}

/// Custom highlighter paint content
class Highlighter extends PaintContent {
  Highlighter();

  Highlighter.data({
    required this.path,
    required Paint paint,
  }) : super.paint(paint);

  Path path = Path();

  @override
  void startDraw(Offset startPoint) {
    path = Path();
    path.moveTo(startPoint.dx, startPoint.dy);
  }

  @override
  void drawing(Offset nowPoint) {
    path.lineTo(nowPoint.dx, nowPoint.dy);
  }

  @override
  void draw(Canvas canvas, Size size, bool repaint) {
    // Create highlighter effect with transparency
    final Paint highlighterPaint = Paint()
      ..color = paint.color.withOpacity(0.3)
      ..strokeWidth = paint.strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    canvas.drawPath(path, highlighterPaint);
  }

  @override
  Highlighter copy() => Highlighter();

  @override
  Map<String, dynamic> toContentJson() {
    return <String, dynamic>{
      'type': 'Highlighter',
      'path': path.toString(), // Note: Path serialization is complex, this is a simplified approach
      'paint': <String, dynamic>{
        'blendMode': paint.blendMode.index,
        'color': paint.color.value,
        'filterQuality': paint.filterQuality.index,
        'invertColors': paint.invertColors,
        'isAntiAlias': paint.isAntiAlias,
        'strokeCap': paint.strokeCap.index,
        'strokeJoin': paint.strokeJoin.index,
        'strokeWidth': paint.strokeWidth,
        'style': paint.style.index,
      },
    };
  }
}
