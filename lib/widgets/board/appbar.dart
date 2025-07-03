import 'package:navinotes/packages.dart';

class BoardNoteAppBar extends StatelessWidget {
  const BoardNoteAppBar({
    super.key,
    required this.scaffoldKey,
    this.theme = BoardTheme.darkAcademia,
  });
  final GlobalKey<ScaffoldState> scaffoldKey;
  final BoardTheme theme;

  void openEndDrawer() {
    scaffoldKey.currentState?.openEndDrawer();
  }

  @override
  Widget build(BuildContext context) {
    BordThemeValues params = theme.values;
    return Container(
      decoration: BoxDecoration(
        color: params.backgroundColor,
        border: Border(bottom: BorderSide(color: params.borderColor)),
      ),
      padding: EdgeInsets.symmetric(vertical: 10),
      child: ResponsiveHorizontalPadding(
        child: Row(
          spacing: 20,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ResponsiveSection(
              mobile: _leading(),
              desktop: Flexible(child: _leading()),
            ),
            ResponsiveSection(
              mobile: Expanded(child: _searchField()),
              desktop: WidthLimiter(mobile: 512, child: _searchField()),
            ),
            ResponsiveSection(
              mobile: MenuButton(
                onPressed: openEndDrawer,
                decoration: BoxDecoration(color: params.color1),
              ),
              desktop: _actions(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _actions() {
    BordThemeValues params = theme.values;
    Color color = params.color1;
    if (theme.isMinimalist) {
      color = AppTheme.asbestos;
    }
    return Row(
      spacing: 15,
      children: [
        SVGImagePlaceHolder(imagePath: Images.settings, size: 16, color: color),
        SVGImagePlaceHolder(imagePath: Images.filter, size: 18, color: color),
        ProfilePic(borderColor: color),
      ],
    );
  }

  Widget _searchIcon() {
    return Icon(Icons.search, color: theme.values.color1, size: 20);
  }

  Widget _searchField() {
    BordThemeValues params = theme.values;
    bool iconIsSuffix = theme.isDarkAcademia;
    return CustomInputField(
      suffixIcon: iconIsSuffix ? _searchIcon() : null,
      prefixIcon: !iconIsSuffix ? _searchIcon() : null,
      hintText: 'Search notes...',
      fillColor: params.inputBackgroundColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(theme.isNature ? 999 : 8),
        borderSide: BorderSide(color: params.inputBorderColor),
      ),
      style: AppTheme.text.copyWith(
        color: params.color1,
        fontSize: 16.0,
        fontFamily: AppTheme.fontCrimsonPro,
        height: 1.50,
      ),
      hintStyle: AppTheme.text.copyWith(
        color: AppTheme.slateGray,
        fontSize: 16.0,
        fontFamily: AppTheme.fontCrimsonPro,
        height: 1.50,
      ),
    );
  }

  Widget _leading() {
    BordThemeValues params = theme.values;
    Color appNameColor = params.color1;
    Color subjectNameColor = params.color1;
    bool isDarkAcademia = theme.isDarkAcademia;
    if (isDarkAcademia) {
      appNameColor = AppTheme.vanillaDust.withAlpha(0xE5);
    }
    switch (theme) {
      case BoardTheme.darkAcademia:
        appNameColor = AppTheme.vanillaDust.withAlpha(0xE5);
        break;
      case BoardTheme.minimalist:
        subjectNameColor = AppTheme.asbestos;
        break;
      default:
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 10,
      children: [
        InkWell(
          onTap: NavigationHelper.pop,
          child: Icon(Icons.arrow_back, size: 24, color: params.color1),
        ),
        VisibleController(
          mobile: false,
          tablet: true,
          child: Flexible(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              spacing: 10,
              children: [
                if (isDarkAcademia)
                  Text(
                    'N',
                    style: AppTheme.text.copyWith(
                      color: AppTheme.royalGold,
                      fontSize: 24.0,
                      fontFamily: AppTheme.fontPlayfairDisplay,
                      fontWeight: getFontWeight(700),
                      height: 1.33,
                    ),
                  )
                else
                  _outlinedProfileName(),
                Flexible(
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: '${AppStrings.appName} /',
                          style: AppTheme.text.copyWith(
                            color: appNameColor,
                            fontSize: 16.0,
                            fontFamily: params.fontFamily,
                            height: 1.50,
                          ),
                        ),
                        TextSpan(
                          text: 'Physics 101',
                          style: AppTheme.text.copyWith(
                            color: subjectNameColor,
                            fontSize: 16.0,
                            fontFamily: params.fontFamily,
                            height: 1.50,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _outlinedProfileName() {
    BordThemeValues params = theme.values;
    Color color = params.color1;
    if (theme.isMinimalist) {
      color = AppTheme.steelBlue;
    }
    return OutlinedChild(
      size: 32,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      child: Text(
        'N',
        style: TextStyle(
          color: AppTheme.linen,
          fontSize: 16.0,
          fontFamily: params.fontFamily,
        ),
      ),
    );
  }
}
