import 'package:navinotes/packages.dart';
import 'vm.dart';

class SquaredNoteBackground extends StatelessWidget {
  const SquaredNoteBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<NoteCreationVm>(
      builder: (_, vm, _) {
        return VisibleController(
          mobile: vm.template == noteTemplateSquared,
          child: CustomPaint(size: Size.infinite, painter: GraphPaperPainter()),
        );
      },
    );
  }
}

class GraphPaperPainter extends CustomPainter {
  final Paint gridPaint =
      Paint()
        ..color = AppTheme.lightGray
        ..strokeWidth = 0.5;

  @override
  void paint(Canvas canvas, Size size) {
    const double gridSize = 10; // Adjust to make squares larger or smaller

    // Draw vertical lines
    for (double x = 0; x < size.width; x += gridSize) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }

    // Draw horizontal lines
    for (double y = 0; y < size.height; y += gridSize) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
