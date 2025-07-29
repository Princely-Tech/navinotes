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
      case BoardTheme.lightAcademia:
        bgColor = AppTheme.royalGold.withAlpha(0xE5);
        borderColor = bgColor;
        txtColor = AppTheme.eggShell.withAlpha(0xFF);
        fontFamily = AppTheme.fontCrimsonText;
        radius = 8;
      default:
    }
    return Consumer<BoardNotePageVm>(
      builder: (_, vm, _) {
        return AppButton(
          onTap: () => NavigationHelper.gotToNewNoteTemplate(vm.board),
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
      },
    );
  }
}

class BoardPageFooter extends StatelessWidget {
  const BoardPageFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 50),
      child: Text(
        '© 2023 Academic Board Builder',
        textAlign: TextAlign.center,
        style: AppTheme.text.copyWith(
          color: AppTheme.sepiaBrown,
          fontFamily: AppTheme.fontOpenSans,
        ),
      ),
    );
  }
}
