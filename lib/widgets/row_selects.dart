import 'package:navinotes/packages.dart';

class TextRowSelect extends StatelessWidget {
  const TextRowSelect({
    super.key,
    required this.items,
    required this.selected,
    this.borderColor = AppTheme.caramelMist,
    this.selectedTextColor = AppTheme.white,
    this.textColor = AppTheme.white,
    this.padding,
    // this.minWidth,
  });
  final List<String> items;
  final String selected;
  final Color? selectedTextColor;
  final Color? textColor;
  final Color borderColor;
  final EdgeInsetsGeometry? padding;
  // final double? minWidth;
  @override
  Widget build(_) {
    return LayoutBuilder(
      builder: (_, constraints) {
        double minWidth = constraints.maxWidth;
        if (minWidth == double.infinity) {
          minWidth = 0;
        }
        return ScrollableController(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: minWidth),
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
                          style: AppTheme.text.copyWith(
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

class CustomRowSelect extends StatefulWidget {
  const CustomRowSelect({super.key});

  @override
  State<CustomRowSelect> createState() => _CustomRowSelectState();
}

class _CustomRowSelectState extends State<CustomRowSelect> {
  String selected = 'Daily';
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: BorderSide(color: AppTheme.lightGray),
          borderRadius: BorderRadius.circular(6),
        ),
      ),
      child: Row(
        children:
            ['Daily', 'Weekly', 'Monthly'].map((str) {
              bool isSelected = str == selected;
              return InkWell(
                onTap: () {
                  setState(() {
                    selected = str;
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    color:
                        isSelected ? AppTheme.paleBlue : AppTheme.transparent,
                    border: Border(
                      right: BorderSide(color: AppTheme.lightGray),
                    ),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Text(
                    str,
                    textAlign: TextAlign.center,
                    style: AppTheme.text.copyWith(
                      color:
                          isSelected
                              ? AppTheme.persianBlue
                              : AppTheme.stormGray,
                      fontWeight: getFontWeight(500),
                    ),
                  ),
                ),
              );
            }).toList(),
      ),
    );
  }
}
