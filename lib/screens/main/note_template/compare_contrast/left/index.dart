import 'package:navinotes/packages.dart';
import 'package:navinotes/screens/main/note_template/compare_contrast/left/comparison_categories.dart';
import 'setup.dart';

class NoteCompareContrastLeft extends StatelessWidget {
  const NoteCompareContrastLeft({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 10,
      children: [
        WidthLimiter(mobile: 255, child: NoteCompareContrastSetup()),
        WidthLimiter(mobile: 255, child: NoteCompareContrastCategories()),
      ],
    );
  }
}
