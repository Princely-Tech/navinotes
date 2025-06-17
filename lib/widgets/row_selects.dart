import 'package:navinotes/packages.dart';

class TextRowSelect extends StatelessWidget {
  const TextRowSelect({
    super.key,
    required this.items,
    required this.selected,
    this.borderColor = Apptheme.caramelMist,
    this.selectedTextColor = Apptheme.white,
    this.textColor = Apptheme.white,
    this.padding,
  });
  final List<String> items;
  final String selected;
  final Color? selectedTextColor;
  final Color? textColor;
  final Color borderColor;
  final EdgeInsetsGeometry? padding;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return ScrollableController(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: constraints.maxWidth),
            child: Row(
              children:
                  items.map((str) {
                    bool isSelected = str == selected;
                    return TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom:
                                isSelected
                                    ? BorderSide(color: borderColor)
                                    : BorderSide.none,
                          ),
                        ),
                        padding: padding ?? EdgeInsets.only(bottom: 5),
                        child: Text(
                          str,
                          style: Apptheme.text.copyWith(
                            color: isSelected ? selectedTextColor : textColor,
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
            ),
          ),
        );
      },
    );
  }
}
