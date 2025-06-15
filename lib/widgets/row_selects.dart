import 'package:navinotes/packages.dart';

class TextRowSelect extends StatelessWidget {
  const TextRowSelect({super.key, required this.items, required this.selected});
  final List<String> items;
  final String selected;
  @override
  Widget build(BuildContext context) {
    return Row(
      children:
          items.map((str) {
            bool isSelected = str == selected;
            return TextButton(
              onPressed: () {},
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom:
                        isSelected
                            ? BorderSide(color: Apptheme.caramelMist)
                            : BorderSide.none,
                  ),
                ),
                padding: EdgeInsets.only(bottom: 5),
                child: Text(
                  str,
                  style: Apptheme.text.copyWith(
                    color: Apptheme.white,
                    fontSize: 16.0,
                  ),
                ),
              ),
            );
          }).toList(),
    );
  }
}
