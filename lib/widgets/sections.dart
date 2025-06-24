import 'package:navinotes/packages.dart';

class EditHeaderSection extends StatelessWidget {
  const EditHeaderSection({
    super.key,
    required this.title,
    required this.child,
    required this.theme,
  });
  final String title;
  final Widget child;
  final BoardTheme theme;
  @override
  Widget build(BuildContext context) {
    BordThemeValues params = theme.values;
    Color dividerColor = params.color1.withAlpha(0x4C);
    switch (theme) {
      case BoardTheme.nature:
        dividerColor = AppTheme.sageMist.withAlpha(0x4C);
        break;
      default:
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTheme.text.copyWith(
            color: params.color1,
            fontSize: 18.0,
            fontFamily: params.fontFamily,
          ),
        ),
        Divider(color: dividerColor, height: 20),
        Padding(padding: const EdgeInsets.only(top: 8.0), child: child),
      ],
    );
  }
}

class ShadowCard extends StatelessWidget {
  const ShadowCard({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: AppTheme.lightGray),
          borderRadius: BorderRadius.circular(16),
        ),
        shadows: [
          BoxShadow(
            color: AppTheme.black.withAlpha(0x19),
            blurRadius: 6,
            offset: Offset(0, 4),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: AppTheme.black.withAlpha(0x19),
            blurRadius: 4,
            offset: Offset(0, 2),
            spreadRadius: 0,
          ),
        ],
      ),
      child: ResponsivePadding(
        mobile: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        laptop: const EdgeInsets.all(30),
        child: child,
      ),
    );
  }
}

class HeaderSectionTwo extends StatelessWidget {
  const HeaderSectionTwo({super.key, required this.title, required this.body});
  final String title;
  final String body;
  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 10,
      children: [
        Text(
          title,
          textAlign: TextAlign.center,
          style: AppTheme.text.copyWith(
            fontSize: 24.0,
            fontFamily: AppTheme.fontPoppins,
            fontWeight: getFontWeight(600),
          ),
        ),
        Text(
          body,
          textAlign: TextAlign.center,
          style: AppTheme.text.copyWith(
            color: AppTheme.stormGray,
            fontSize: 16.0,
            fontFamily: AppTheme.fontPoppins,
          ),
        ),
      ],
    );
  }
}
