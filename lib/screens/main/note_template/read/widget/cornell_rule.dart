import 'package:navinotes/packages.dart';

/// Cornell note-taking format background with:
/// - Left cue column (30% width)
/// - Right main notes area (70% width)
/// - Bottom summary section (15% height)
/// - Ruled lines in both columns
class CornellNoteBackground extends StatelessWidget {
  const CornellNoteBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.infinite,
      painter: CornellPaperPainter(),
    );
  }
}

class CornellPaperPainter extends CustomPainter {
  final Paint linePaint = Paint()
    ..color = AppTheme.lightGray
    ..strokeWidth = 0.5;

  final Paint dividerPaint = Paint()
    ..color = AppTheme.lightGray
    ..strokeWidth = 1.5;

  @override
  void paint(Canvas canvas, Size size) {
    const double lineSpacing = 16; // Line spacing for ruled lines
    const double topPadding = 28; // Padding before first line
    const double cueColumnWidth = 0.30; // 30% of page width for cue column
    const double summaryHeight = 0.15; // 15% of page height for summary

    // Calculate positions
    final double verticalLineX = size.width * cueColumnWidth;
    final double horizontalLineY = size.height * (1 - summaryHeight);

    // Draw vertical line separating cue column from notes area
    canvas.drawLine(
      Offset(verticalLineX, 0),
      Offset(verticalLineX, horizontalLineY),
      dividerPaint,
    );

    // Draw horizontal line separating summary section
    canvas.drawLine(
      Offset(0, horizontalLineY),
      Offset(size.width, horizontalLineY),
      dividerPaint,
    );

    // Draw ruled lines in cue column
    for (double y = topPadding; y < horizontalLineY; y += lineSpacing) {
      canvas.drawLine(
        Offset(0, y),
        Offset(verticalLineX, y),
        linePaint,
      );
    }

    // Draw ruled lines in main notes area
    for (double y = topPadding; y < horizontalLineY; y += lineSpacing) {
      canvas.drawLine(
        Offset(verticalLineX, y),
        Offset(size.width, y),
        linePaint,
      );
    }

    // Optional: Draw ruled lines in summary section
    final double summaryLineSpacing = lineSpacing * 1.2; // Slightly wider spacing
    for (double y = horizontalLineY + topPadding;
        y < size.height;
        y += summaryLineSpacing) {
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        linePaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
