import 'package:navinotes/packages.dart';

class BoardPageMainHeader extends StatelessWidget {
  const BoardPageMainHeader({super.key, required this.theme});
  final BoardTheme theme;
  @override
  Widget build(BuildContext context) {
    BordThemeValues params = theme.values;
    return Consumer<BoardNotePageVm>(
      builder: (_, vm, _) {
        return Container(
          decoration: params.mainHeaderDecoration,
          padding: EdgeInsets.all(10),
          child: Row(
            spacing: 20,
            children: [
              Text(
                getNoteCountText(vm.contents),
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
                                if (theme.isMinimalist)
                                  Row(
                                    spacing: 15,
                                    children: [
                                      SVGImagePlaceHolder(
                                        imagePath: Images.menu,
                                        color: AppTheme.asbestos,
                                        size: 16,
                                      ),
                                    ],
                                  )
                                else
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
      },
    );
  }

  Widget _sortBy() {
    //TODO make input width follow text style
    BordThemeValues params = theme.values;
    Color txtColor = AppTheme.vanillaDust.withAlpha(0xCC);
    Color fillColor = AppTheme.burntLeather;
    Color borderColor = params.color1;
    Widget? prefixIcon;
    switch (theme) {
      case BoardTheme.nature:
        txtColor = AppTheme.coffee;
        fillColor = AppTheme.transparent;
        break;
      case BoardTheme.minimalist:
        txtColor = AppTheme.asbestos;
        fillColor = AppTheme.transparent;
        break;
      case BoardTheme.lightAcademia:
        txtColor = AppTheme.asbestos;
        fillColor = AppTheme.almondCream;
        borderColor = AppTheme.royalGold.withAlpha(0x4C);
        prefixIcon = Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Text(
            'Sort by:',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: const Color(0xFF654321),
              fontSize: 16.0,
              fontFamily: 'Crimson Text',
              fontWeight: FontWeight.w400,
            ),
          ),
        );
        break;
      default:
    }
    return Consumer<BoardNotePageVm>(
      builder: (_, vm, _) {
        return ValueListenableBuilder(
          valueListenable: vm.sortByController,
          builder: (_, value, _) {
            final sortByTxt = 'Sort by:';
            final sortByStyle = AppTheme.text.copyWith(
              color: txtColor,
              fontSize: 16.0,
              fontFamily: AppTheme.fontCrimsonPro,
              height: 1.50,
            );
            final style = AppTheme.text.copyWith(color: params.color1);
            final textWidth = calculateTextWidth(value.text, style) + 45;
            final sortByTextWidth =
                calculateTextWidth(sortByTxt, sortByStyle) + 30;
            return WidthLimiter(
              mobile: sortByTextWidth + textWidth,
              // mobile: 200,
              child: Row(
                spacing: 10,
                children: [
                  if (isNull(prefixIcon)) Text(sortByTxt, style: sortByStyle),
                  Expanded(
                    child: CustomInputField(
                      prefixIcon: prefixIcon,
                      fillColor: fillColor,
                      side: BorderSide(color: borderColor),
                      controller: vm.sortByController,
                      selectItems:
                          NoteSortType.values
                              .map((type) => noteSortTypeToString(type))
                              .toList(),
                      style: style,
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class DisplayFormatSelect extends StatelessWidget {
  const DisplayFormatSelect({super.key, required this.theme});
  final BoardTheme theme;

  @override
  Widget build(BuildContext context) {
    BordThemeValues params = theme.values;
    return Consumer<BoardNotePageVm>(
      builder: (_, vm, _) {
        return Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(4)),
          child: Padding(
            padding: EdgeInsets.all(5),
            child: Row(
              spacing: 15,
              children: [
                Container(
                  decoration: params.layoutBtnContainerDecoration,
                  child: IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _layoutBtn(PageDisplayFormat.list, vm),
                        _layoutBtn(PageDisplayFormat.grid, vm),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _layoutBtn(PageDisplayFormat format, BoardNotePageVm vm) {
    BordThemeValues params = theme.values;
    bool isGrid = format == PageDisplayFormat.grid;
    bool isActive = vm.pageDisplayFormat == format;
    Color activeBgColor = AppTheme.burntLeather.withAlpha(102);
    Color inActiveBgColor = AppTheme.transparent;
    Color inActiveColor = AppTheme.vanillaDust;
    switch (theme) {
      case BoardTheme.nature:
        activeBgColor = AppTheme.lightSage;
        inActiveColor = params.color1;
        break;
      case BoardTheme.lightAcademia:
        activeBgColor = AppTheme.almondCream;
        inActiveBgColor = AppTheme.eggShell.withAlpha(0xFF);
        inActiveColor = params.color1;
        break;
      default:
    }
    return InkWell(
      onTap: () => vm.updatePageDisplayFormat(format),
      child: OutlinedChild(
        size: 40,
        decoration: BoxDecoration(
          color: isActive ? activeBgColor : inActiveBgColor,
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
