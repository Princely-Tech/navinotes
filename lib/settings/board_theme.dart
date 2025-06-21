import 'package:navinotes/packages.dart';

enum BoardTheme {
  darkAcademia,
  nature;

  bool get isDarkAcademia => this == darkAcademia;
  bool get isNature => this == nature;
}

class BordThemeValues {
  final Color backgroundColor;
  final Color borderColor;
  final Color color1;
  final String fontFamily;
  final Color inputBorderColor;
  final Color inputBackgroundColor;

  final BoxDecoration mainHeaderDecoration;
  final BoxDecoration layoutBtnContainerDecoration;

  BordThemeValues({
    required this.backgroundColor,
    required this.borderColor,
    required this.color1,
    required this.inputBorderColor,
    required this.fontFamily,
    required this.inputBackgroundColor,
    required this.mainHeaderDecoration,
    required this.layoutBtnContainerDecoration,
  });
}

extension BoardThemeExtension on BoardTheme {
  BordThemeValues get values {
    Color bgColor = Apptheme.transparent;
    Color borderColor = Apptheme.royalGold.withAlpha(0x4C);
    Color color1 = Apptheme.royalGold;
    Color inputBorderColor = Apptheme.royalGold;
    String fontFamily = Apptheme.fontPlayfairDisplay;
    Color inputBackgroundColor = Apptheme.burntLeather;
    BoxDecoration mainHeaderDecoration = BoxDecoration();
    BoxDecoration layoutBtnContainerDecoration = BoxDecoration(
      borderRadius: BorderRadius.circular(4),
      color: Apptheme.burntClove,
      border: Border.all(color: Apptheme.royalGold),
    );
    switch (this) {
      case BoardTheme.darkAcademia:
        mainHeaderDecoration = BoxDecoration(
          color: Apptheme.fadedEmber,
          borderRadius: BorderRadius.circular(4),
          border: Border(
            bottom: BorderSide(
              width: 1,
              color: Apptheme.royalGold.withAlpha(0x4C),
            ),
          ),
        );
      case BoardTheme.nature:
        bgColor = Apptheme.mintCream;
        borderColor = Apptheme.sageMist;
        color1 = Apptheme.deepMoss;
        fontFamily = Apptheme.fontLibreBaskerville;
        inputBorderColor = Apptheme.burntLeather.withAlpha(0x4C);
        inputBackgroundColor = Apptheme.lightSage;
        layoutBtnContainerDecoration = layoutBtnContainerDecoration.copyWith(
          border: Border.all(color: Apptheme.sageMist.withAlpha(0x4C)),
          color: Apptheme.linen,
        );
    }
    return BordThemeValues(
      backgroundColor: bgColor,
      borderColor: borderColor,
      color1: color1,
      fontFamily: fontFamily,
      inputBorderColor: inputBorderColor,
      inputBackgroundColor: inputBackgroundColor,
      mainHeaderDecoration: mainHeaderDecoration,
      layoutBtnContainerDecoration: layoutBtnContainerDecoration,
    );
  }
}
