import 'package:navinotes/packages.dart';

class GoNewNoteButton extends StatelessWidget {
  const GoNewNoteButton({super.key, this.theme = BoardTheme.darkAcademia});
  final BoardTheme theme;

  @override
  Widget build(BuildContext context) {
    BordThemeValues params = theme.values;
    Color bgColor = Apptheme.burntLeather.withAlpha(0xFF);
    Color txtColor = params.color1;
    String fontFamily = Apptheme.fontCrimsonPro;
    double radius = 4;
    switch (theme) {
      case BoardTheme.nature:
        bgColor = params.color1;
        txtColor = Apptheme.white;
        fontFamily = Apptheme.fontCrimsonText;
        radius = 999;
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
        side: BorderSide(color: params.color1),
      ),
      prefix: Icon(Icons.add, color: txtColor, size: 20),
      style: Apptheme.text.copyWith(
        color: txtColor,
        fontSize: 16.0,
        fontFamily: fontFamily,
      ),
    );
  }
}
