import 'package:navinotes/packages.dart';
import 'package:navinotes/screens/main/note_template/compare_contrast/widget.dart';

class NoteCompareContrastCategories extends StatelessWidget {
  const NoteCompareContrastCategories({super.key});

  @override
  Widget build(BuildContext context) {
    return WrapperContainerWithTitle(
      title: 'Comparison Categories',
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          spacing: 10,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Default Categories',
              style: TextStyle(
                color: const Color(0xFF374151),
                fontSize: 16.0,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w500,
                height: 1.50,
              ),
            ),
            Column(
              spacing: 4,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ActiveIndicatorWidget('Structure', checked: true),
                ActiveIndicatorWidget('Function', checked: true),
                ActiveIndicatorWidget('Examples', checked: true),
                ActiveIndicatorWidget('Key Features', checked: true),
                ActiveIndicatorWidget('Advantages', checked: false),
                ActiveIndicatorWidget('Disadvantages', checked: false),
                ActiveIndicatorWidget('Applications', checked: false),
              ],
            ),

            Text(
              'Custom Categories',
              style: TextStyle(
                color: const Color(0xFF374151),
                fontSize: 16.0,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w500,
                height: 1.50,
              ),
            ),

            CustomInputField(
              hintText: 'Add new category',
              suffixIcon: Icon(Icons.add, color: Color(0xFF0284C7)),
              contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              hintStyle: TextStyle(
                color: const Color(0xFFADAEBC),
                fontSize: 14.0,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
                height: 1.43,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
