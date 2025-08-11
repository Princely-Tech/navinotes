import 'package:navinotes/packages.dart';
import 'package:navinotes/screens/main/choose_board/light_academia/popup/overview.dart';

class BoardLightAcadPopupScreen extends StatelessWidget {
  BoardLightAcadPopupScreen({super.key});
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    Board board = ModalRoute.of(context)?.settings.arguments as Board;
    return ChangeNotifierProvider(
      create: (context) {
        final vm = BoardEditVm(scaffoldKey: _scaffoldKey, board: board);
        vm.initialize();
        return vm;
      },
      child: Consumer<BoardEditVm>(
        builder: (_, vm, _) {
          return ScaffoldFrame(
            scaffoldKey: _scaffoldKey,
            drawer: CustomDrawer(child: NavigationSideBar()),
            backgroundColor: const Color(0xFFF5F2E8),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _header(),
                Expanded(
                  child: ScrollableController(
                    child: vm.returnSelectedTabItem(
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: BoardLightAcadPopupOverview(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _widthLimiter({required Widget child}) {
    return ResponsiveHorizontalPadding(
      child: LargeDesktopWidthLimiter(child: child),
    );
  }

  Widget _header() {
    return Consumer<BoardEditVm>(
      builder: (_, vm, _) {
        return Column(
          children: [
            Container(
              decoration: ShapeDecoration(
                color: const Color(0xFFFAF7F0),
                shape: RoundedRectangleBorder(
                  side: BorderSide(width: 1, color: const Color(0x4CFFB347)),
                ),
                shadows: [
                  BoxShadow(
                    color: Color(0x0C000000),
                    blurRadius: 2,
                    offset: Offset(0, 1),
                    spreadRadius: 0,
                  ),
                ],
              ),
              padding: EdgeInsets.symmetric(vertical: 10),
              child: _widthLimiter(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          MenuButton(
                            onPressed: vm.openDrawer,
                            decoration: BoxDecoration(
                              color: AppTheme.burntLeather.withAlpha(0XFF),
                            ),
                          ),
                          AppIconButton(
                            onPressed: NavigationHelper.pop,
                            icon: Icon(
                              Icons.arrow_back,
                              color: AppTheme.burntLeather.withAlpha(0XFF),
                            ),
                          ),
                          Flexible(
                            child: Text(
                              vm.board.name,
                              style: TextStyle(
                                color: const Color(0xFF654321),
                                fontSize: 16,
                                fontFamily: 'EB Garamond',
                                fontWeight: FontWeight.w400,
                                height: 1.50,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    VisibleController(
                      mobile: false,
                      laptop: true,
                      child: _textRowSelect(),
                    ),

                    Row(
                      children: [
                        AppIconButton(
                          onPressed: NavigationHelper.navigateToNotification,
                          icon: Badge(
                            backgroundColor: const Color(0xFFD4AF37),
                            textStyle: AppTheme.text.copyWith(
                              color: AppTheme.white,
                              fontSize: 8.0,
                            ),
                            label: Center(
                              child: Text('3', textAlign: TextAlign.center),
                            ),
                            child: Icon(
                              Icons.notifications,
                              color: const Color(0xFF8B4513),
                            ),
                          ),
                        ),
                        AppIconButton(
                          onPressed: () {},
                          icon: SVGImagePlaceHolder(
                            imagePath: Images.ques,
                            size: 16,
                            color: const Color(0xFF8B4513),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: ProfilePic(
                            borderColor: const Color(0xFFD4AF37),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            VisibleController(
              mobile: true,
              laptop: false,
              child: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: _textRowSelect(),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _textRowSelect() {
    return Consumer<LayoutProviderVm>(
      builder: (_, layoutVm, _) {
        bool isBottom = getDeviceResponsiveValue(
          deviceType: layoutVm.deviceType,
          mobile: true,
          laptop: false,
        );
        return Consumer<BoardEditVm>(
          builder: (_, vm, _) {
            return TextRowSelect(
              items:
                  EditBoardTab.values.map((item) => item.toString()).toList(),
              onSelected: (value) {
                vm.updateSelectedTab(
                  stringToEnum<EditBoardTab>(value, EditBoardTab.values),
                );
              },
              inActiveBorderColor:
                  isBottom
                      ? const Color(0xFFD4AF37).withAlpha(100)
                      : AppTheme.transparent,
              selectedTextStyle: TextStyle(
                color: const Color(0xFFD4AF37),
                fontSize: 16,
                fontFamily: 'EB Garamond',
                fontWeight: FontWeight.w400,
              ),
              fillWidth: isBottom,
              borderColor: const Color(0xFFD4AF37),
              style: TextStyle(
                color: const Color(0xFF8B4513),
                fontSize: 16,
                fontFamily: 'EB Garamond',
                fontWeight: FontWeight.w400,
                height: 1.50,
              ),
            );
          },
        );
      },
    );
  }
}
