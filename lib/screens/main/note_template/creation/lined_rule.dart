import 'package:navinotes/packages.dart';

class LinedNoteBackground extends StatelessWidget {
  const LinedNoteBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(size: Size.infinite, painter: LinedPaperPainter());
  }
}

class LinedPaperPainter extends CustomPainter {
  final Paint linePaint =
      Paint()
        ..color = AppTheme.lightGray
        ..strokeWidth = 1;

  @override
  void paint(Canvas canvas, Size size) {
    const double lineSpacing = 40; // Adjust line spacing to your font size
    for (double y = lineSpacing; y < size.height; y += lineSpacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), linePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
