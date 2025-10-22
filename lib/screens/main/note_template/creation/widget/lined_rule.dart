import 'package:navinotes/packages.dart';

class LinedNoteBackground extends StatelessWidget {
  const LinedNoteBackground({super.key});

  @override
  Widget build(BuildContext context) {
    // Always show the lined background - no need for Consumer
    return CustomPaint(size: Size.infinite, painter: LinedPaperPainter());
  }
}

class LinedPaperPainter extends CustomPainter {
  final Paint linePaint =
      Paint()
        ..color = AppTheme.lightGray
        ..strokeWidth = 0.5;

  @override
  void paint(Canvas canvas, Size size) {
    const double lineSpacing = 16; // Adjust line spacing to your font size
    const double topPadding =
        28; // Padding before first line to align with text baseline
    for (double y = topPadding; y < size.height; y += lineSpacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), linePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
