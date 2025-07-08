import 'package:navinotes/packages.dart';

class CustomMindMapHeader extends StatelessWidget {
  const CustomMindMapHeader({
    super.key,
    required this.openDrawer,
    required this.openEndDrawer,
    required this.boardTheme,
  });
  final VoidCallback openDrawer;
  final VoidCallback openEndDrawer;
  final BoardTheme boardTheme;

  @override
  Widget build(BuildContext context) {
    Color bgColor = AppTheme.sageMist;
    Color borderColor = AppTheme.deepMoss.withAlpha(0x19);
    switch (boardTheme) {
      case BoardTheme.plain:
        bgColor = AppTheme.ghostWhite;
        break;
      case BoardTheme.minimalist:
        bgColor = AppTheme.white;
        break;
      default:
    }
    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        border: Border(bottom: BorderSide(color: borderColor)),
      ),
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // BordThemeValues params = boardTheme.values;
          return ScrollableController(
            scrollDirection: Axis.horizontal,
            child: Container(
              constraints: BoxConstraints(minWidth: constraints.maxWidth),
              child: Row(
                spacing: 30,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(children: [ InkWell(
                            onTap: NavigationHelper.pop,
                            child: 
                                Icon(
                                  Icons.arrow_back,
                                  color: AppTheme.vividRose,
                                ),),
                                   _menuButton(), _title()]),
                  VisibleController(
                    mobile: false,
                    laptop: true,
                    child: Row(
                      spacing: 25,
                      children: [
                        if (boardTheme.isNature) ...[
                          _imgItem(img: Images.leaf),
                          _imgItem(img: Images.plant),
                          _imgItem(img: Images.tree),
                        ],
                        if (boardTheme.isPlain || boardTheme.isMinimalist) ...[
                          _imgItem(img: Images.edit),
                          _imgItem(img: Images.hook),
                          _imgItem(img: Images.sdCard),
                        ],
                        _searchField(),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Row(
                        children: [
                          _shareBtn(),
                          _customizationTxt(),
                          Padding(
                            padding: const EdgeInsets.only(left: 15),
                            child: ProfilePic(size: 32),
                          ),
                        ],
                      ),
                      VisibleController(
                        mobile: true,
                        laptop: false,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: MenuButton(
                            decoration: BoxDecoration(
                              color: AppTheme.darkMossGreen,
                            ),
                            onPressed: openEndDrawer,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _customizationTxt() {
    Color color = AppTheme.darkMossGreen;
    BordThemeValues params = boardTheme.values;
    switch (boardTheme) {
      case BoardTheme.plain:
        color = AppTheme.graphite;
        break;
      default:
    }
    return VisibleController(
      mobile: false,
      desktop: true,
      child: Padding(
        padding: const EdgeInsets.only(left: 15),
        child: Text(
          'Customization',
          style: AppTheme.text.copyWith(
            color: color,
            fontFamily: params.fontFamily,
            height: 1.43,
          ),
        ),
      ),
    );
  }

  Widget _shareBtn() {
    Color color = AppTheme.deepMoss;
    Color textColor = AppTheme.white;
    Color iconColor = AppTheme.white;
    Color? borderColor;
    BordThemeValues params = boardTheme.values;
    switch (boardTheme) {
      case BoardTheme.plain:
      case BoardTheme.minimalist:
        color = AppTheme.white;
        borderColor = AppTheme.lightGray;
        textColor = AppTheme.graphite;
        iconColor = AppTheme.black;
        break;
      default:
    }
    return AppButton(
      mainAxisSize: MainAxisSize.min,
      spacing: 10,
      onTap: () {},
      minHeight: 32,
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      text: 'Share',
      color: color,
      borderColor: borderColor,
      prefix: SVGImagePlaceHolder(
        imagePath: Images.share2,
        color: iconColor,
        size: 14,
      ),
      style: AppTheme.text.copyWith(
        color: textColor,
        fontFamily: params.fontFamily,
      ),
    );
  }

  Widget _title() {
    BordThemeValues params = boardTheme.values;
    Color color = AppTheme.darkMossGreen;
    FontWeight? fontWeight;
    switch (boardTheme) {
      case BoardTheme.plain:
        color = AppTheme.black;
        break;
      case BoardTheme.minimalist:
        color = AppTheme.wetAsphalt;
        fontWeight = getFontWeight(500);
        break;
      default:
    }
    return Text(
      'Advanced Biology',
      style: AppTheme.text.copyWith(
        color: color,
        fontSize: 20.0,
        fontFamily: params.fontFamily,
        fontWeight: fontWeight,
      ),
    );
  }

  Widget _menuButton() {
    Color color = AppTheme.darkMossGreen;
    switch (boardTheme) {
      case BoardTheme.plain:
        color = AppTheme.black;
        break;
      default:
    }
    return VisibleController(
      mobile: true,
      desktop: false,
      child: Padding(
        padding: const EdgeInsets.only(right: 10),
        child: MenuButton(
          decoration: BoxDecoration(color: color),
          onPressed: openDrawer,
        ),
      ),
    );
  }

  Widget _imgItem({required String img}) {
    Color color = AppTheme.coffee;
    switch (boardTheme) {
      case BoardTheme.plain:
        color = AppTheme.graphite;
        break;
      case BoardTheme.minimalist:
        color = AppTheme.asbestos;
        break;
      default:
    }
    return SVGImagePlaceHolder(imagePath: img, color: color, size: 16);
  }

  Widget _searchField() {
    Color iconColor = AppTheme.coffee;
    Color borderColor = AppTheme.burntLeather.withAlpha(0x33);
    String fontFamily = AppTheme.fontCrimsonText;
    switch (boardTheme) {
      case BoardTheme.plain:
      case BoardTheme.minimalist:
        iconColor = AppTheme.graphite;
        borderColor = AppTheme.lightGray;
        fontFamily = AppTheme.fontFamily;
        break;
      default:
    }
    TextStyle style = AppTheme.text.copyWith(
      color: iconColor,
      fontSize: 16.0,
      fontFamily: fontFamily,
      height: 1.50,
    );
    return WidthLimiter(
      mobile: 192,
      child: CustomInputField(
        prefixIcon: Icon(Icons.search, color: iconColor, size: 20),
        hintText: 'Search...',
        fillColor: AppTheme.white,
        constraints: BoxConstraints(maxHeight: 34),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(color: borderColor),
        ),
        style: style,
        hintStyle: AppTheme.text.copyWith(
          color: AppTheme.slateGray,
          fontFamily: fontFamily,
          height: 1.50,
        ),
      ),
    );
  }
}
