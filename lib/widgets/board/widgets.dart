import 'package:navinotes/packages.dart';

class GoNewNoteButton extends StatelessWidget {
  const GoNewNoteButton({super.key, this.theme = BoardTheme.darkAcademia});
  final BoardTheme theme;

  @override
  Widget build(BuildContext context) {
    BordThemeValues params = theme.values;
    Color bgColor = AppTheme.burntLeather.withAlpha(0xFF);
    Color txtColor = params.color1;
    String fontFamily = AppTheme.fontCrimsonPro;
    Color borderColor = params.color1;
    double radius = 4;
    switch (theme) {
      case BoardTheme.nature:
        bgColor = params.color1;
        txtColor = AppTheme.white;
        fontFamily = AppTheme.fontCrimsonText;
        radius = 999;
      case BoardTheme.minimalist:
        bgColor = AppTheme.strongBlue;
        borderColor = AppTheme.strongBlue;
        txtColor = AppTheme.white;
        fontFamily = AppTheme.fontFamily;
        radius = 8;
      default:
    }
    return AppButton(
      onTap: NavigationHelper.gotToNoteTemplate,
      text: 'New Note Page',
      mainAxisSize: MainAxisSize.min,
      minHeight: 40,
      color: bgColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius),
        side: BorderSide(color: borderColor),
      ),
      prefix: Icon(Icons.add, color: txtColor, size: 20),
      style: AppTheme.text.copyWith(
        color: txtColor,
        fontSize: 16.0,
        fontFamily: fontFamily,
      ),
    );
  }
}
