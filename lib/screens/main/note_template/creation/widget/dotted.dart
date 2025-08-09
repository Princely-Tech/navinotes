import 'package:navinotes/packages.dart';
import '../vm.dart';

class DottedNoteBackground extends StatelessWidget {
  const DottedNoteBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<NoteCreationVm>(
      builder: (_, vm, _) {
        return VisibleController(
          mobile: vm.template == noteTemplateDotted,
          child: CustomPaint(
            size: Size.infinite,
            painter: DottedGraphPaperPainter(),
          ),
        );
      },
    );
  }
}

class DottedGraphPaperPainter extends CustomPainter {
  final Paint dotPaint =
      Paint()
        ..color = AppTheme.lightGray
        ..style = PaintingStyle.fill;

  @override
  void paint(Canvas canvas, Size size) {
    const double gridSize = 15; // Spacing between dots
    const double dotRadius = 2; // Size of each dot

    for (double x = 0; x < size.width; x += gridSize) {
      for (double y = 0; y < size.height; y += gridSize) {
        canvas.drawCircle(Offset(x, y), dotRadius, dotPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
