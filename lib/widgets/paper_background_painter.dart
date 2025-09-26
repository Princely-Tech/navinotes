import 'package:flutter/material.dart';
import 'package:navinotes/models/paper_template.dart';

/// Custom painter for drawing paper backgrounds with lines, dots, grids, etc.
class PaperBackgroundPainter extends CustomPainter {
  final PaperTemplate template;
  final double scale;

  PaperBackgroundPainter({
    required this.template,
    this.scale = 1.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = template.color.lineColor
      ..strokeWidth = 0.5 * scale
      ..style = PaintingStyle.stroke;

    // Fill background
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = template.color.backgroundColor,
    );

    // Draw margins if enabled
    if (template.showMargins) {
      _drawMargins(canvas, size, paint);
    }

    // Draw pattern based on paper type
    switch (template.type) {
      case PaperType.blank:
        // No pattern needed
        break;
      case PaperType.lined:
        _drawLines(canvas, size, paint);
        break;
      case PaperType.dotted:
        _drawDots(canvas, size, paint);
        break;
      case PaperType.grid:
        _drawGrid(canvas, size, paint);
        break;
      case PaperType.cornell:
        _drawCornellLayout(canvas, size, paint);
        break;
      case PaperType.music:
        _drawMusicStaff(canvas, size, paint);
        break;
      case PaperType.calendar:
        _drawCalendarGrid(canvas, size, paint);
        break;
      case PaperType.planner:
        _drawPlannerLayout(canvas, size, paint);
        break;
    }
  }

  void _drawMargins(Canvas canvas, Size size, Paint paint) {
    final marginPaint = Paint()
      ..color = template.color.lineColor.withOpacity(0.3)
      ..strokeWidth = 1.0 * scale
      ..style = PaintingStyle.stroke;

    // Left margin
    canvas.drawLine(
      Offset(template.marginLeft * scale, 0),
      Offset(template.marginLeft * scale, size.height),
      marginPaint,
    );

    // Right margin
    canvas.drawLine(
      Offset(size.width - template.marginRight * scale, 0),
      Offset(size.width - template.marginRight * scale, size.height),
      marginPaint,
    );

    // Top margin
    canvas.drawLine(
      Offset(0, template.marginTop * scale),
      Offset(size.width, template.marginTop * scale),
      marginPaint,
    );

    // Bottom margin
    canvas.drawLine(
      Offset(0, size.height - template.marginBottom * scale),
      Offset(size.width, size.height - template.marginBottom * scale),
      marginPaint,
    );
  }

  void _drawLines(Canvas canvas, Size size, Paint paint) {
    final spacing = template.lineSpacing.spacing * scale;
    final startY = template.marginTop * scale;
    final endY = size.height - template.marginBottom * scale;
    final startX = template.marginLeft * scale;
    final endX = size.width - template.marginRight * scale;

    for (double y = startY + spacing; y < endY; y += spacing) {
      canvas.drawLine(
        Offset(startX, y),
        Offset(endX, y),
        paint,
      );
    }
  }

  void _drawDots(Canvas canvas, Size size, Paint paint) {
    final spacing = template.lineSpacing.spacing * scale;
    final startY = template.marginTop * scale;
    final endY = size.height - template.marginBottom * scale;
    final startX = template.marginLeft * scale;
    final endX = size.width - template.marginRight * scale;

    final dotPaint = Paint()
      ..color = template.color.lineColor
      ..style = PaintingStyle.fill;

    for (double y = startY; y < endY; y += spacing) {
      for (double x = startX; x < endX; x += spacing) {
        canvas.drawCircle(
          Offset(x, y),
          1.0 * scale,
          dotPaint,
        );
      }
    }
  }

  void _drawGrid(Canvas canvas, Size size, Paint paint) {
    final spacing = template.lineSpacing.spacing * scale;
    final startY = template.marginTop * scale;
    final endY = size.height - template.marginBottom * scale;
    final startX = template.marginLeft * scale;
    final endX = size.width - template.marginRight * scale;

    // Horizontal lines
    for (double y = startY; y <= endY; y += spacing) {
      canvas.drawLine(
        Offset(startX, y),
        Offset(endX, y),
        paint,
      );
    }

    // Vertical lines
    for (double x = startX; x <= endX; x += spacing) {
      canvas.drawLine(
        Offset(x, startY),
        Offset(x, endY),
        paint,
      );
    }
  }

  void _drawCornellLayout(Canvas canvas, Size size, Paint paint) {
    final startY = template.marginTop * scale;
    final endY = size.height - template.marginBottom * scale;
    final startX = template.marginLeft * scale;
    final endX = size.width - template.marginRight * scale;

    // Cornell layout dimensions
    final cueColumnWidth = 150.0 * scale;
    final summaryHeight = 80.0 * scale;

    // Draw main lines first
    _drawLines(canvas, size, paint);

    // Cue column line
    canvas.drawLine(
      Offset(startX + cueColumnWidth, startY),
      Offset(startX + cueColumnWidth, endY - summaryHeight),
      Paint()
        ..color = template.color.lineColor
        ..strokeWidth = 1.5 * scale,
    );

    // Summary section line
    canvas.drawLine(
      Offset(startX, endY - summaryHeight),
      Offset(endX, endY - summaryHeight),
      Paint()
        ..color = template.color.lineColor
        ..strokeWidth = 1.5 * scale,
    );

    // Add labels
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    // Cue label
    textPainter.text = TextSpan(
      text: 'Cue',
      style: TextStyle(
        color: template.color.lineColor,
        fontSize: 10 * scale,
        fontWeight: FontWeight.w300,
      ),
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(startX + 10 * scale, startY + 10 * scale),
    );

    // Notes label
    textPainter.text = TextSpan(
      text: 'Notes',
      style: TextStyle(
        color: template.color.lineColor,
        fontSize: 10 * scale,
        fontWeight: FontWeight.w300,
      ),
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(startX + cueColumnWidth + 10 * scale, startY + 10 * scale),
    );

    // Summary label
    textPainter.text = TextSpan(
      text: 'Summary',
      style: TextStyle(
        color: template.color.lineColor,
        fontSize: 10 * scale,
        fontWeight: FontWeight.w300,
      ),
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(startX + 10 * scale, endY - summaryHeight + 10 * scale),
    );
  }

  void _drawMusicStaff(Canvas canvas, Size size, Paint paint) {
    final startY = template.marginTop * scale;
    final endY = size.height - template.marginBottom * scale;
    final startX = template.marginLeft * scale;
    final endX = size.width - template.marginRight * scale;

    final staffHeight = 32.0 * scale; // Height of one staff (5 lines)
    final lineSpacing = 8.0 * scale; // Space between staff lines
    final staffSpacing = 60.0 * scale; // Space between different staffs

    double currentY = startY + 40 * scale;

    while (currentY + staffHeight < endY) {
      // Draw 5 lines for each staff
      for (int i = 0; i < 5; i++) {
        final y = currentY + (i * lineSpacing);
        canvas.drawLine(
          Offset(startX, y),
          Offset(endX, y),
          paint,
        );
      }
      currentY += staffHeight + staffSpacing;
    }
  }

  void _drawCalendarGrid(Canvas canvas, Size size, Paint paint) {
    final startY = template.marginTop * scale;
    final endY = size.height - template.marginBottom * scale;
    final startX = template.marginLeft * scale;
    final endX = size.width - template.marginRight * scale;

    final cellWidth = (endX - startX) / 7; // 7 days
    final cellHeight = (endY - startY - 40 * scale) / 6; // 6 weeks max

    // Draw title area
    canvas.drawLine(
      Offset(startX, startY + 40 * scale),
      Offset(endX, startY + 40 * scale),
      Paint()
        ..color = template.color.lineColor
        ..strokeWidth = 2.0 * scale,
    );

    // Draw grid
    // Vertical lines
    for (int i = 0; i <= 7; i++) {
      canvas.drawLine(
        Offset(startX + (i * cellWidth), startY + 40 * scale),
        Offset(startX + (i * cellWidth), endY),
        paint,
      );
    }

    // Horizontal lines
    for (int i = 0; i <= 6; i++) {
      canvas.drawLine(
        Offset(startX, startY + 40 * scale + (i * cellHeight)),
        Offset(endX, startY + 40 * scale + (i * cellHeight)),
        paint,
      );
    }

    // Add day headers
    final days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    final textPainter = TextPainter(textDirection: TextDirection.ltr);

    for (int i = 0; i < days.length; i++) {
      textPainter.text = TextSpan(
        text: days[i],
        style: TextStyle(
          color: template.color.lineColor,
          fontSize: 12 * scale,
          fontWeight: FontWeight.w500,
        ),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(
          startX + (i * cellWidth) + (cellWidth - textPainter.width) / 2,
          startY + 10 * scale,
        ),
      );
    }
  }

  void _drawPlannerLayout(Canvas canvas, Size size, Paint paint) {
    final startY = template.marginTop * scale;
    final endY = size.height - template.marginBottom * scale;
    final startX = template.marginLeft * scale;
    final endX = size.width - template.marginRight * scale;

    // Time column width
    final timeColumnWidth = 60.0 * scale;
    final hourHeight = 40.0 * scale;

    // Draw time column separator
    canvas.drawLine(
      Offset(startX + timeColumnWidth, startY),
      Offset(startX + timeColumnWidth, endY),
      Paint()
        ..color = template.color.lineColor
        ..strokeWidth = 1.5 * scale,
    );

    // Draw hourly lines
    final textPainter = TextPainter(textDirection: TextDirection.ltr);
    
    for (int hour = 6; hour <= 22; hour++) {
      final y = startY + ((hour - 6) * hourHeight);
      if (y < endY) {
        // Hour line
        canvas.drawLine(
          Offset(startX + timeColumnWidth, y),
          Offset(endX, y),
          paint,
        );

        // Time label
        final timeText = hour <= 12 
            ? '${hour == 0 ? 12 : hour}:00 ${hour < 12 ? 'AM' : 'PM'}'
            : '${hour - 12}:00 PM';
            
        textPainter.text = TextSpan(
          text: timeText,
          style: TextStyle(
            color: template.color.lineColor,
            fontSize: 8 * scale,
          ),
        );
        textPainter.layout();
        textPainter.paint(
          canvas,
          Offset(startX + 5 * scale, y - 6 * scale),
        );
      }
    }
  }

  @override
  bool shouldRepaint(PaperBackgroundPainter oldDelegate) {
    return oldDelegate.template != template || oldDelegate.scale != scale;
  }
}
