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
    this.selectedTextStyle,
    this.style,
    this.inActiveBorderColor = AppTheme.transparent,
    this.fillWidth = true,
    this.btnStyle,
  });
  final List<String> items;
  final String selected;
  final Color? selectedTextColor;
  final Color? textColor;
  final Color borderColor;
  final EdgeInsetsGeometry? padding;
  final TextStyle? selectedTextStyle;
  final TextStyle? style;
  final Color inActiveBorderColor;
  final bool fillWidth;
  final ButtonStyle? btnStyle;
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
          child: Container(
            constraints: fillWidth ? BoxConstraints(minWidth: minWidth) : null,
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: inActiveBorderColor)),
            ),
            child: Row(
              spacing: 5,
              children:
                  items.map((str) {
                    bool isSelected = str == selected;
                    TextStyle? runTextStyle =
                        isSelected ? selectedTextStyle : style;
                    ButtonStyle buttonStyle = TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    );
                    if (isNotNull(btnStyle) && isSelected) {
                      buttonStyle = btnStyle!;
                    }
                    String? prefixImage;
                    switch (str) {
                      case 'Pre-Lab':
                        prefixImage = Images.flaskTestTube;
                      case 'Methods':
                        prefixImage = Images.menu2;
                      case 'Data':
                        prefixImage = Images.grid2;
                      case 'Results':
                        prefixImage = Images.chart3;
                    }
                    return Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom:
                              isSelected
                                  ? BorderSide(width: 2, color: borderColor)
                                  : BorderSide.none,
                        ),
                      ),
                      child: TextButton(
                        onPressed: () {},
                        style: buttonStyle.copyWith(),
                        child: Container(
                          padding: padding ?? EdgeInsets.only(bottom: 5),
                          child: Row(
                            spacing: 8,
                            children: [
                              if (isNotNull(prefixImage))
                                SVGImagePlaceHolder(
                                  imagePath: prefixImage!,
                                  size: 17,
                                  color:
                                      isSelected
                                          ? const Color(0xFF0284C7)
                                          : const Color(0xFF6B7280),
                                ),
                              Text(
                                str,
                                style:
                                    runTextStyle ??
                                    AppTheme.text.copyWith(
                                      color:
                                          isSelected
                                              ? selectedTextColor
                                              : textColor,
                                      fontSize: 16.0,
                                    ),
                              ),
                            ],
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
