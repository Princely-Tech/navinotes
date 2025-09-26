import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:navinotes/models/paper_template.dart';
import 'package:navinotes/widgets/paper_background_painter.dart';

/// Stroke data for handwriting/drawing
class HandwritingStroke {
  final List<HandwritingPoint> points;
  final Color color;
  final double strokeWidth;
  final BlendMode blendMode;
  final int timestamp;

  HandwritingStroke({
    required this.points,
    required this.color,
    required this.strokeWidth,
    this.blendMode = BlendMode.srcOver,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'points': points.map((p) => p.toMap()).toList(),
      'color': color.value,
      'strokeWidth': strokeWidth,
      'blendMode': blendMode.index,
      'timestamp': timestamp,
    };
  }

  factory HandwritingStroke.fromMap(Map<String, dynamic> map) {
    return HandwritingStroke(
      points: (map['points'] as List)
          .map((p) => HandwritingPoint.fromMap(p as Map<String, dynamic>))
          .toList(),
      color: Color(map['color'] ?? 0xFF000000),
      strokeWidth: map['strokeWidth']?.toDouble() ?? 2.0,
      blendMode: BlendMode.values[map['blendMode'] ?? 0],
      timestamp: map['timestamp'] ?? 0,
    );
  }
}

/// Individual point in a handwriting stroke
class HandwritingPoint {
  final Offset offset;
  final double pressure;
  final double tiltX;
  final double tiltY;
  final int timestamp;

  HandwritingPoint({
    required this.offset,
    this.pressure = 1.0,
    this.tiltX = 0.0,
    this.tiltY = 0.0,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'x': offset.dx,
      'y': offset.dy,
      'pressure': pressure,
      'tiltX': tiltX,
      'tiltY': tiltY,
      'timestamp': timestamp,
    };
  }

  factory HandwritingPoint.fromMap(Map<String, dynamic> map) {
    return HandwritingPoint(
      offset: Offset(
        map['x']?.toDouble() ?? 0.0,
        map['y']?.toDouble() ?? 0.0,
      ),
      pressure: map['pressure']?.toDouble() ?? 1.0,
      tiltX: map['tiltX']?.toDouble() ?? 0.0,
      tiltY: map['tiltY']?.toDouble() ?? 0.0,
      timestamp: map['timestamp'] ?? 0,
    );
  }
}

/// Drawing tool types
enum DrawingTool {
  pen,
  pencil,
  marker,
  eraser,
  highlighter,
}

/// Handwriting canvas widget with stylus support
class HandwritingCanvas extends StatefulWidget {
  final PaperTemplate paperTemplate;
  final List<HandwritingStroke> initialStrokes;
  final Function(List<HandwritingStroke>) onStrokesChanged;
  final DrawingTool currentTool;
  final Color currentColor;
  final double currentStrokeWidth;
  final bool isReadOnly;
  final double scale;
  final Offset panOffset;

  const HandwritingCanvas({
    super.key,
    required this.paperTemplate,
    this.initialStrokes = const [],
    required this.onStrokesChanged,
    this.currentTool = DrawingTool.pen,
    this.currentColor = Colors.black,
    this.currentStrokeWidth = 2.0,
    this.isReadOnly = false,
    this.scale = 1.0,
    this.panOffset = Offset.zero,
  });

  @override
  State<HandwritingCanvas> createState() => _HandwritingCanvasState();
}

class _HandwritingCanvasState extends State<HandwritingCanvas> {
  List<HandwritingStroke> _strokes = [];
  HandwritingStroke? _currentStroke;

  void initState() {
    super.initState();
    _strokes = List.from(widget.initialStrokes);
  }

  @override
  void didUpdateWidget(HandwritingCanvas oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialStrokes != widget.initialStrokes) {
      _strokes = List.from(widget.initialStrokes);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: _onPanStart,
      onPanUpdate: _onPanUpdate,
      onPanEnd: _onPanEnd,
      child: CustomPaint(
        painter: HandwritingCanvasPainter(
          paperTemplate: widget.paperTemplate,
          strokes: _strokes,
          currentStroke: _currentStroke,
          scale: widget.scale,
          panOffset: widget.panOffset,
        ),
        size: Size.infinite,
      ),
    );
  }

  void _onPanStart(DragStartDetails details) {
    if (widget.isReadOnly) return;

    // Check if this is a multi-finger gesture (for panning)
    // For touch, we might want to implement palm rejection
    // For now, treat all touch as drawing

    final localPosition = details.localPosition;
    final adjustedPosition = _adjustPositionForTransform(localPosition);

    _currentStroke = HandwritingStroke(
      points: [
        HandwritingPoint(
          offset: adjustedPosition,
          pressure: _getPressure(details),
          timestamp: DateTime.now().millisecondsSinceEpoch,
        ),
      ],
      color: _getToolColor(),
      strokeWidth: _getToolStrokeWidth(),
      blendMode: _getToolBlendMode(),
      timestamp: DateTime.now().millisecondsSinceEpoch,
    );

    setState(() {});
    
    // Provide haptic feedback for stylus
    HapticFeedback.lightImpact();
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (widget.isReadOnly || _currentStroke == null) return;

    final localPosition = details.localPosition;
    final adjustedPosition = _adjustPositionForTransform(localPosition);

    final newPoint = HandwritingPoint(
      offset: adjustedPosition,
      pressure: _getPressure(details),
      timestamp: DateTime.now().millisecondsSinceEpoch,
    );

    _currentStroke = HandwritingStroke(
      points: [..._currentStroke!.points, newPoint],
      color: _currentStroke!.color,
      strokeWidth: _currentStroke!.strokeWidth,
      blendMode: _currentStroke!.blendMode,
      timestamp: _currentStroke!.timestamp,
    );

    setState(() {});
  }

  void _onPanEnd(DragEndDetails details) {
    if (widget.isReadOnly || _currentStroke == null) return;

    // Only add stroke if it has enough points
    if (_currentStroke!.points.length > 1) {
      _strokes.add(_currentStroke!);
      widget.onStrokesChanged(_strokes);
    }

    _currentStroke = null;
    setState(() {});
  }

  Offset _adjustPositionForTransform(Offset position) {
    // Adjust for scale and pan
    return Offset(
      (position.dx - widget.panOffset.dx) / widget.scale,
      (position.dy - widget.panOffset.dy) / widget.scale,
    );
  }

  double _getPressure(dynamic details) {
    // Try to get pressure from stylus input
    // Note: Flutter doesn't directly expose pressure in DragDetails
    // This would need platform-specific implementation or a plugin
    return 1.0; // Default pressure
  }

  Color _getToolColor() {
    switch (widget.currentTool) {
      case DrawingTool.eraser:
        return widget.paperTemplate.color.backgroundColor;
      case DrawingTool.highlighter:
        return widget.currentColor.withOpacity(0.3);
      default:
        return widget.currentColor;
    }
  }

  double _getToolStrokeWidth() {
    switch (widget.currentTool) {
      case DrawingTool.pen:
        return widget.currentStrokeWidth;
      case DrawingTool.pencil:
        return widget.currentStrokeWidth * 0.8;
      case DrawingTool.marker:
        return widget.currentStrokeWidth * 1.5;
      case DrawingTool.highlighter:
        return widget.currentStrokeWidth * 3.0;
      case DrawingTool.eraser:
        return widget.currentStrokeWidth * 2.0;
    }
  }

  BlendMode _getToolBlendMode() {
    switch (widget.currentTool) {
      case DrawingTool.eraser:
        return BlendMode.clear;
      case DrawingTool.highlighter:
        return BlendMode.multiply;
      default:
        return BlendMode.srcOver;
    }
  }

  void clearCanvas() {
    setState(() {
      _strokes.clear();
      _currentStroke = null;
    });
    widget.onStrokesChanged(_strokes);
  }

  void undoLastStroke() {
    if (_strokes.isNotEmpty) {
      setState(() {
        _strokes.removeLast();
      });
      widget.onStrokesChanged(_strokes);
    }
  }
}

/// Custom painter for the handwriting canvas
class HandwritingCanvasPainter extends CustomPainter {
  final PaperTemplate paperTemplate;
  final List<HandwritingStroke> strokes;
  final HandwritingStroke? currentStroke;
  final double scale;
  final Offset panOffset;

  HandwritingCanvasPainter({
    required this.paperTemplate,
    required this.strokes,
    this.currentStroke,
    required this.scale,
    required this.panOffset,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Apply transformations
    canvas.save();
    canvas.translate(panOffset.dx, panOffset.dy);
    canvas.scale(scale);

    // Draw paper background
    final paperPainter = PaperBackgroundPainter(
      template: paperTemplate,
      scale: 1.0, // Paper background should not scale with zoom
    );
    paperPainter.paint(canvas, size);

    // Draw all completed strokes
    for (final stroke in strokes) {
      _drawStroke(canvas, stroke);
    }

    // Draw current stroke being drawn
    if (currentStroke != null) {
      _drawStroke(canvas, currentStroke!);
    }

    canvas.restore();
  }

  void _drawStroke(Canvas canvas, HandwritingStroke stroke) {
    if (stroke.points.length < 2) return;

    final paint = Paint()
      ..color = stroke.color
      ..strokeWidth = stroke.strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke
      ..blendMode = stroke.blendMode;

    // Create path from points
    final path = Path();
    path.moveTo(stroke.points.first.offset.dx, stroke.points.first.offset.dy);

    for (int i = 1; i < stroke.points.length; i++) {
      final point = stroke.points[i];
      final prevPoint = stroke.points[i - 1];

      // Use quadratic curves for smoother lines
      final controlPoint = Offset(
        (prevPoint.offset.dx + point.offset.dx) / 2,
        (prevPoint.offset.dy + point.offset.dy) / 2,
      );

      path.quadraticBezierTo(
        prevPoint.offset.dx,
        prevPoint.offset.dy,
        controlPoint.dx,
        controlPoint.dy,
      );
    }

    // Draw the path
    canvas.drawPath(path, paint);

    // For pencil tool, add texture effect
    if (stroke.color == Colors.grey[700]) {
      final texturePaint = Paint()
        ..color = stroke.color.withOpacity(0.3)
        ..strokeWidth = stroke.strokeWidth * 1.2
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke;
      canvas.drawPath(path, texturePaint);
    }
  }

  @override
  bool shouldRepaint(HandwritingCanvasPainter oldDelegate) {
    return oldDelegate.strokes != strokes ||
        oldDelegate.currentStroke != currentStroke ||
        oldDelegate.scale != scale ||
        oldDelegate.panOffset != panOffset ||
        oldDelegate.paperTemplate != paperTemplate;
  }
}
