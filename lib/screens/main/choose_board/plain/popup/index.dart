import 'package:navinotes/packages.dart';
import 'overview.dart';

class BoardPlainPopupScreen extends StatelessWidget {
  BoardPlainPopupScreen({super.key});
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
          return ChooseBoardWrapper(
            child: ScaffoldFrame(
              scaffoldKey: _scaffoldKey,
              backgroundColor: AppTheme.ghostWhite,
              drawer: CustomDrawer(child: NavigationSideBar()),
              body: Column(
                children: [
                  _header(),
                  Expanded(
                    child: ScrollableController(child: vm.returnSelectedTabItem(BoardPlainPopupOverview())),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
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
            fontSize: 16.0,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w500,
          ),
          style: TextStyle(
            color: const Color(0xFF6B7280),
            fontSize: 16.0,
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
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      spacing: 20,
                      children: [
                        MenuButton(onPressed: vm.openDrawer),
                        Expanded(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            spacing: 15,
                            children: [
                              IconButton(
                                onPressed: NavigationHelper.pop,
                                icon: Icon(
                                  Icons.arrow_back,
                                  color: const Color(0xFF6B7280),
                                ),
                              ),
                              ExpandableController(
                                mobile: true,
                                desktop: false,
                                child: Text(
                                  vm.board.name ?? '',
                                  style: TextStyle(
                                    color: const Color(0xFF1F2937),
                                    fontSize: getDeviceResponsiveValue(
                                      deviceType: layoutVm.deviceType,
                                      mobile: 16,
                                      tablet: 18,
                                      laptop: 20,
                                    ),
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w600,
                                    height: 1.4,
                                  ),
                                ),
                              ),
                              if (!showBottomSelectRows)
                                Expanded(child: _selectRows()),

                              Row(
                                spacing: 10,
                                children: [
                                  IconButton(
                                    onPressed:
                                        NavigationHelper.navigateToSettings,
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
                      ],
                    ),
                  ),
                ),
                if (showBottomSelectRows)
                  _selectRows(inActiveBorderColor: AppTheme.lightGray),
              ],
            );
          },
        );
      },
    );
  }
}
