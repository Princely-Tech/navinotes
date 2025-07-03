import 'package:navinotes/packages.dart';

enum BoardTheme {
  darkAcademia,
  minimalist,
  nature;

  bool get isDarkAcademia => this == darkAcademia;
  bool get isNature => this == nature;
  bool get isMinimalist => this == minimalist;
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
    Color bgColor = AppTheme.transparent;
    Color borderColor = AppTheme.royalGold.withAlpha(0x4C);
    Color color1 = AppTheme.royalGold;
    Color inputBorderColor = AppTheme.royalGold;
    String fontFamily = AppTheme.fontPlayfairDisplay;
    Color inputBackgroundColor = AppTheme.burntLeather;
    BoxDecoration mainHeaderDecoration = BoxDecoration();
    BoxDecoration layoutBtnContainerDecoration = BoxDecoration(
      borderRadius: BorderRadius.circular(4),
      color: AppTheme.burntClove,
      border: Border.all(color: AppTheme.royalGold),
    );
    switch (this) {
      case BoardTheme.darkAcademia:
        mainHeaderDecoration = BoxDecoration(
          color: AppTheme.fadedEmber,
          borderRadius: BorderRadius.circular(4),
          border: Border(
            bottom: BorderSide(
              width: 1,
              color: AppTheme.royalGold.withAlpha(0x4C),
            ),
          ),
        );
      case BoardTheme.nature:
        bgColor = AppTheme.mintCream;
        borderColor = AppTheme.sageMist;
        color1 = AppTheme.deepMoss;
        fontFamily = AppTheme.fontLibreBaskerville;
        inputBorderColor = AppTheme.burntLeather.withAlpha(0x4C);
        inputBackgroundColor = AppTheme.lightSage;
        layoutBtnContainerDecoration = layoutBtnContainerDecoration.copyWith(
          border: Border.all(color: AppTheme.sageMist.withAlpha(0x4C)),
          color: AppTheme.linen,
        );
      case BoardTheme.minimalist:
        // bgColor = AppTheme.mintCream;
        borderColor = AppTheme.aliceBlue;
        color1 = AppTheme.wetAsphalt;
        fontFamily = AppTheme.fontFamily;
        inputBorderColor = AppTheme.lightGray;
        inputBackgroundColor = AppTheme.transparent;
      // layoutBtnContainerDecoration = layoutBtnContainerDecoration.copyWith(
      //   border: Border.all(color: AppTheme.sageMist.withAlpha(0x4C)),
      //   color: AppTheme.linen,
      // );
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
