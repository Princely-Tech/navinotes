import 'package:navinotes/packages.dart';

class BoardPageMainHeader extends StatelessWidget {
  const BoardPageMainHeader({super.key, required this.theme});
  final BoardTheme theme;
  @override
  Widget build(BuildContext context) {
    BordThemeValues params = theme.values;
    return Container(
      decoration: params.mainHeaderDecoration,
      padding: EdgeInsets.all(10),
      child: Row(
        spacing: 20,
        children: [
          Text(
            '8 Note Pages',
            style: AppTheme.text.copyWith(
              color: params.color1,
              fontSize: 20.0,
              fontFamily: params.fontFamily,
              height: 1.40,
            ),
          ),
          VisibleController(
            mobile: false,
            tablet: true,
            child: Expanded(
              child: LayoutBuilder(
                builder: (_, constraints) {
                  return ScrollableController(
                    scrollDirection: Axis.horizontal,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minWidth: constraints.maxWidth,
                      ),
                      child: ResponsiveSection(
                        mobile: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          spacing: 10,
                          children: [
                            DisplayFormatSelect(theme: theme),
                            _sortBy(),
                            VisibleController(
                              mobile: false,
                              desktop: true,
                              child: GoNewNoteButton(theme: theme),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sortBy() {
    Color txtColor = AppTheme.vanillaDust.withAlpha(0xCC);
    Color fillColor = AppTheme.burntLeather;
    BordThemeValues params = theme.values;
    switch (theme) {
      case BoardTheme.nature:
        txtColor = AppTheme.coffee;
        fillColor = AppTheme.transparent;
        break;
      default:
    }
    return WidthLimiter(
      mobile: 200,
      child: Row(
        spacing: 10,
        children: [
          Text(
            'Sort by:',
            style: AppTheme.text.copyWith(
              color: txtColor,
              fontSize: 16.0,
              fontFamily: AppTheme.fontCrimsonPro,
              height: 1.50,
            ),
          ),
          Expanded(
            child: CustomInputField(
              fillColor: fillColor,
              side: BorderSide(color: params.color1),
              selectItems: [],
              style: AppTheme.text.copyWith(color: params.color1),
              constraints: BoxConstraints(maxHeight: 40),
            ),
          ),
        ],
      ),
    );
  }
}

class DisplayFormatSelect extends StatefulWidget {
  const DisplayFormatSelect({super.key, required this.theme});
  final BoardTheme theme;

  @override
  State<DisplayFormatSelect> createState() => _DisplayFormatSelectState();
}

class _DisplayFormatSelectState extends State<DisplayFormatSelect> {
  PageDisplayFormat pageDisplayFormat = PageDisplayFormat.list;

  @override
  Widget build(BuildContext context) {
    BordThemeValues params = widget.theme.values;
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(4)),
      child: Padding(
        padding: EdgeInsets.all(5),
        child: Row(
          spacing: 15,
          children: [
            SVGImagePlaceHolder(
              imagePath: Images.ques,
              color:
                  widget.theme == BoardTheme.darkAcademia
                      ? AppTheme.vanillaDust.withAlpha(204)
                      : params.color1,
              size: 16,
            ),
            Container(
              decoration: params.layoutBtnContainerDecoration,
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _layoutBtn(PageDisplayFormat.list),
                    _layoutBtn(PageDisplayFormat.grid),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _layoutBtn(PageDisplayFormat format) {
    BordThemeValues params = widget.theme.values;
    bool isGrid = format == PageDisplayFormat.grid;
    bool isActive = pageDisplayFormat == format;
    Color activeBgColor = AppTheme.burntLeather.withAlpha(102);
    Color inActiveColor = AppTheme.vanillaDust;
    switch (widget.theme) {
      case BoardTheme.nature:
        activeBgColor = AppTheme.lightSage;
        inActiveColor = params.color1;
        break;
      default:
    }
    return InkWell(
      onTap: () => setState(() => pageDisplayFormat = format),
      child: OutlinedChild(
        size: 40,
        decoration: BoxDecoration(
          color: isActive ? activeBgColor : AppTheme.transparent,
          borderRadius: BorderRadius.circular(0),
        ),
        child: SVGImagePlaceHolder(
          imagePath: isGrid ? Images.grid : Images.menu,
          color: isActive ? params.color1 : inActiveColor,
          size: isGrid ? 16 : 18,
        ),
      ),
    );
  }
}
