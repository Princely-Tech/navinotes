import 'package:navinotes/models/mind_map_node.dart';
import 'package:navinotes/packages.dart';

enum BoardTheme {
  darkAcademia,
  lightAcademia,
  minimalist,
  nature,
  plain;

  bool get isDarkAcademia => this == darkAcademia;
  bool get isNature => this == nature;
  bool get isMinimalist => this == minimalist;
  bool get isPlain => this == plain;
  bool get isLightAcademia => this == lightAcademia;
}

class BordThemeValues {
  final Color backgroundColor;
  final Color borderColor;
  final Color color1;
  final String fontFamily;
  final Color inputBorderColor;
  final Color inputBackgroundColor;
  final Color nodeBackgroundColor;
  final Color nodeTextColor;
  final Color connectionColor;
  final MindMapBorderStyle nodeBorderStyle;

  final BoxDecoration mainHeaderDecoration;
  final BoxDecoration layoutBtnContainerDecoration;

  final Color toolBorderColor;

  BordThemeValues({
    required this.backgroundColor,
    required this.borderColor,
    required this.color1,
    required this.inputBorderColor,
    required this.fontFamily,
    required this.nodeBackgroundColor,
    required this.nodeTextColor,
    required this.connectionColor,
    required this.nodeBorderStyle,
    required this.inputBackgroundColor,
    required this.mainHeaderDecoration,
    required this.layoutBtnContainerDecoration,
    required this.toolBorderColor,
  });
}

extension BoardThemeExtension on BoardTheme {
  BordThemeValues get values {
    Color bgColor = AppTheme.transparent;
    Color borderColor = AppTheme.royalGold.withAlpha(0x4C);
    Color color1 = AppTheme.burntClove;
    String fontFamily = AppTheme.fontCrimsonPro;
    Color inputBorderColor = AppTheme.royalGold.withAlpha(0x4C);
    Color inputBackgroundColor = AppTheme.fadedEmber;
    Color nodeBackgroundColor = AppTheme.fadedEmber;
    Color nodeTextColor = AppTheme.burntClove;
    MindMapBorderStyle nodeBorderStyle = MindMapBorderStyle.border;
    Color connectionColor = AppTheme.royalGold;

    Color toolBorderColor = Colors.transparent;

    BoxDecoration mainHeaderDecoration = BoxDecoration();
    BoxDecoration layoutBtnContainerDecoration = BoxDecoration(
      borderRadius: BorderRadius.circular(4),
      color: AppTheme.burntClove,
      border: Border.all(color: AppTheme.royalGold),
    );
    switch (this) {
      case BoardTheme.darkAcademia:
        nodeBorderStyle = MindMapBorderStyle.shadow;
        nodeTextColor = AppTheme.white;
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
        toolBorderColor = AppTheme.burntClove;
      case BoardTheme.nature:
        bgColor = AppTheme.mintCream;
        borderColor = AppTheme.sageMist;
        color1 = AppTheme.deepMoss;
        fontFamily = AppTheme.fontLibreBaskerville;
        inputBorderColor = AppTheme.burntLeather.withAlpha(0x4C);
        inputBackgroundColor = AppTheme.lightSage;
        nodeBackgroundColor = AppTheme.lightSage;
        nodeTextColor = AppTheme.deepMoss;
        connectionColor = AppTheme.sageMist;
        layoutBtnContainerDecoration = layoutBtnContainerDecoration.copyWith(
          border: Border.all(color: AppTheme.sageMist.withAlpha(0x4C)),
          color: AppTheme.linen,
        );

        toolBorderColor = AppTheme.amber;

      case BoardTheme.minimalist:
        borderColor = AppTheme.aliceBlue;
        color1 = AppTheme.wetAsphalt;
        fontFamily = AppTheme.fontFamily;
        inputBorderColor = AppTheme.lightGray;
        inputBackgroundColor = AppTheme.white;
        nodeBackgroundColor = AppTheme.white;
        nodeTextColor = AppTheme.wetAsphalt;
        connectionColor = AppTheme.aliceBlue;

        toolBorderColor = AppTheme.wetAsphalt;

      case BoardTheme.plain:
        fontFamily = AppTheme.fontFamily;
        nodeBackgroundColor = AppTheme.white;
        nodeTextColor = AppTheme.black;
        nodeBorderStyle = MindMapBorderStyle.border;
        connectionColor = AppTheme.lightGray;
      case BoardTheme.lightAcademia:
        inputBackgroundColor = AppTheme.almondCream;
        color1 = AppTheme.sepiaBrown;
        fontFamily = AppTheme.fontCrimsonText;
        nodeBackgroundColor = AppTheme.almondCream;
        nodeTextColor = AppTheme.sepiaBrown;
        nodeBorderStyle = MindMapBorderStyle.shadow;

        connectionColor = AppTheme.sepiaBrown.withAlpha(0x80);
        mainHeaderDecoration = BoxDecoration(
          border: Border(
            bottom: BorderSide(color: AppTheme.sepiaBrown.withAlpha(0x19)),
          ),
        );
        toolBorderColor = AppTheme.sepiaBrown;
    }
    return BordThemeValues(
      backgroundColor: bgColor,
      borderColor: borderColor,
      color1: color1,
      fontFamily: fontFamily,
      inputBorderColor: inputBorderColor,
      inputBackgroundColor: inputBackgroundColor,
      nodeBackgroundColor: nodeBackgroundColor,
      nodeTextColor: nodeTextColor,
      connectionColor: connectionColor,
      nodeBorderStyle: nodeBorderStyle,
      mainHeaderDecoration: mainHeaderDecoration,
      layoutBtnContainerDecoration: layoutBtnContainerDecoration,
      toolBorderColor: toolBorderColor,
    );
  }
}
