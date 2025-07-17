import 'package:navinotes/packages.dart';
import 'package:navinotes/screens/main/note_template/compare_contrast/widget.dart';

class NoteCompareContrastSetup extends StatelessWidget {
  const NoteCompareContrastSetup({super.key});

  @override
  Widget build(BuildContext context) {
    return WrapperContainerWithTitle(
      title: 'Comparison Setup',
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          spacing: 10,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Content Source',
              style: TextStyle(
                color: const Color(0xFF374151),
                fontSize: 16,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w500,
                height: 1.50,
              ),
            ),
            Text(
              'From My Notes',
              style: TextStyle(
                color: const Color(0xFF4B5563),
                fontSize: 14,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w500,
                height: 1.43,
              ),
            ),
            CustomInputField(),
            CustomCard(
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(6)),
              addBorder: true,
              padding: const EdgeInsets.all(9),
              child: Column(
                spacing: 4,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ActiveIndicatorWidget('Cell Structure', checked: true),

                  ActiveIndicatorWidget(
                    'Prokaryotic vs Eukaryotic',
                    checked: true,
                  ),

                  ActiveIndicatorWidget('Cell Division', checked: false),

                  ActiveIndicatorWidget('Cell Metabolism', checked: false),
                ],
              ),
            ),
            Row(spacing: 8, children: [_squareBox(), _squareBox()]),
            CustomInputField(
              hintText: 'Add custom topics to compare',
              suffixIcon: Icon(Icons.add, color: Color(0xFF0284C7)),
              contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              hintStyle: TextStyle(
                color: const Color(0xFFADAEBC),
                fontSize: 14,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
                height: 1.43,
              ),
            ),
            _aiSuggestion(),
          ],
        ),
      ),
    );
  }

  Widget _aiSuggestion() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'AI Suggestions',
          style: TextStyle(
            color: const Color(0xFF4B5563),
            fontSize: 14,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w500,
            height: 1.43,
          ),
        ),
        CustomCard(
          decoration: BoxDecoration(
            color: const Color(0xFFF9FAFB),
            borderRadius: BorderRadius.circular(6),
          ),
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Commonly compared concepts in Biology',
                style: TextStyle(
                  color: const Color(0xFF6B7280),
                  fontSize: 12,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: 8),
              Column(
                children: [
                  _conceptRow('Prokaryotic vs Eukaryotic'),
                  SizedBox(height: 4),
                  _conceptRow('Plant vs Animal Cells'),
                  SizedBox(height: 4),
                  _conceptRow('Mitosis vs Meiosis'),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// Helper Widget for each concept row
Widget _conceptRow(String text) {
  return Container(
    width: 244,
    height: 20,
    padding: const EdgeInsets.symmetric(horizontal: 0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          text,
          style: TextStyle(
            color: Colors.black,
            fontSize: 14,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w400,
            height: 1.43,
          ),
        ),
        Container(
          width: 23,
          height: 16,
          alignment: Alignment.center,
          child: Text(
            'Use',
            style: TextStyle(
              color: const Color(0xFF0284C7),
              fontSize: 12,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    ),
  );
}

// Helper for note item

// Helper for square box at bottom
Widget _squareBox() {
  return Container(
    width: 64,
    height: 64,
    decoration: ShapeDecoration(
      color: const Color(0xFFF3F4F6),
      shape: RoundedRectangleBorder(
        side: BorderSide(color: const Color(0xFFE5E7EB)),
        borderRadius: BorderRadius.circular(6),
      ),
    ),
    child: Center(
      child: Container(
        width: 16,
        height: 16,
        decoration: ShapeDecoration(
          color: Colors.transparent,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: const Color(0xFFE5E7EB)),
          ),
        ),
      ),
    ),
  );
}


// this uses stack and positioned. Can you rewrite using rows and columns instead?