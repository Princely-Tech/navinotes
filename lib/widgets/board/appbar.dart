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
    dynamic params = theme.values;
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
    return Row(
      spacing: 15,
      children: [
        SVGImagePlaceHolder(
          imagePath: Images.settings,
          size: 16,
          color: params.color1,
        ),
        SVGImagePlaceHolder(
          imagePath: Images.filter,
          size: 18,
          color: params.color1,
        ),
        ProfilePic(borderColor: params.color1),
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
      style: Apptheme.text.copyWith(
        color: params.color1,
        fontSize: 16.0,
        fontFamily: Apptheme.fontCrimsonPro,
        height: 1.50,
      ),
      hintStyle: Apptheme.text.copyWith(
        color: Apptheme.slateGray,
        fontSize: 16.0,
        fontFamily: Apptheme.fontCrimsonPro,
        height: 1.50,
      ),
    );
  }

  Widget _leading() {
    BordThemeValues params = theme.values;
    Color appNameColor = params.color1;
    bool isDarkAcademia = theme.isDarkAcademia;
    if (isDarkAcademia) {
      appNameColor = Apptheme.vanilaDust.withAlpha(0xE5);
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
                    style: Apptheme.text.copyWith(
                      color: Apptheme.royalGold,
                      fontSize: 24.0,
                      fontFamily: Apptheme.fontPlayfairDisplay,
                      fontWeight: getFontWeight(700),
                      height: 1.33,
                    ),
                  )
                else
                  OutlinedChild(
                    size: 32,
                    decoration: BoxDecoration(
                      color: params.color1,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      'N',
                      style: TextStyle(
                        color: Apptheme.linen,
                        fontSize: 16.0,
                        fontFamily: params.fontFamily,
                      ),
                    ),
                  ),
                Flexible(
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: '${AppStrings.appName} /',
                          style: Apptheme.text.copyWith(
                            color: appNameColor,
                            fontSize: 16.0,
                            fontFamily: params.fontFamily,
                            height: 1.50,
                          ),
                        ),
                        TextSpan(
                          text: 'Physics 101',
                          style: Apptheme.text.copyWith(
                            color: params.color1,
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
}
