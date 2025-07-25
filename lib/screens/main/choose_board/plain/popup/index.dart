import 'package:navinotes/packages.dart';
import 'overview.dart';

class BoardPlainPopupScreen extends StatelessWidget {
  BoardPlainPopupScreen({super.key});
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => BoardEditVm(scaffoldKey: _scaffoldKey),
      child: Consumer<BoardEditVm>(
        builder: (_, vm, _) {
          return ScaffoldFrame(
            scaffoldKey: _scaffoldKey,
            drawer: CustomDrawer(child: NavigationSideBar()),
            body: Column(
              children: [
                _header(),
                Expanded(
                  child: ScrollableController(
                    mobilePadding: const EdgeInsets.symmetric(vertical: 20),
                    child: ResponsiveHorizontalPadding(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: WidthLimiter(
                              mobile: largeDesktopSize,
                              child: _returnTabItem(vm),
                            ),
                          ),
                        ],
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

  Widget _returnTabItem(BoardEditVm vm) {
    switch (vm.selectedTab) {
      case EditBoardTab.overview:
        return BoardPlainPopupOverview();
      case EditBoardTab.uploads:
        return BoardEditUploads(vm);
      case EditBoardTab.assignments:
        return const SizedBox.shrink();
    }
  }

  Widget _selectRows({Color inActiveBorderColor = AppTheme.transparent}) {
    return Consumer<BoardEditVm>(
      builder: (_, vm, _) {
        return TextRowSelect(
          items: EditBoardTab.values.map((item) => item.toString()).toList(),
          borderColor: AppTheme.strongBlue,
          inActiveBorderColor: inActiveBorderColor,
          padding: const EdgeInsets.symmetric(vertical: 10),
          onSelected: (value) {
            vm.updateSelectedTab(
              stringToEnum<EditBoardTab>(value, EditBoardTab.values),
            );
          },
          selectedTextStyle: TextStyle(
            color: const Color(0xFF3B82F6),
            fontSize: 16,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w500,
          ),
          style: TextStyle(
            color: const Color(0xFF6B7280),
            fontSize: 16,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w500,
            height: 1.50,
          ),
        );
      },
    );
  }

  Widget _header() {
    return Consumer<LayoutProviderVm>(
      builder: (_, layoutVm, _) {
        bool showBottomSelectRows = getDeviceResponsiveValue(
          deviceType: layoutVm.deviceType,
          mobile: true,
          desktop: false,
        );
        return Consumer<BoardEditVm>(
          builder: (_, vm, _) {
            return Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      bottom: BorderSide(color: Color(0xFFE5E7EB)),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: MenuButton(onPressed: vm.openDrawer),
                        ),
                        Expanded(
                          child: ResponsiveHorizontalPadding(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Flexible(
                                  child: WidthLimiter(
                                    mobile: largeDesktopSize,
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      spacing: 15,
                                      children: [
                                        Text(
                                          'BIOLOGY 101 - Fall Semester',
                                          style: TextStyle(
                                            color: const Color(0xFF1F2937),
                                            fontSize: 20,
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w600,
                                            height: 1.4,
                                          ),
                                        ),
                                        if (!showBottomSelectRows)
                                          Expanded(child: _selectRows()),

                                        Row(
                                          spacing: 10,
                                          children: [
                                            IconButton(
                                              onPressed:
                                                  NavigationHelper
                                                      .navigateToSettings,
                                              icon: SVGImagePlaceHolder(
                                                imagePath: Images.settings,
                                                size: 16,
                                                color: AppTheme.stormGray,
                                              ),
                                            ),
                                            ProfilePic(),
                                          ],
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
                    ),
                  ),
                ),
                if (showBottomSelectRows)
                  _selectRows(inActiveBorderColor: AppTheme.whiteSmoke),
              ],
            );
          },
        );
      },
    );
  }
}
