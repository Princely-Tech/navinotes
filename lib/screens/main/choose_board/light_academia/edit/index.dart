import 'package:navinotes/packages.dart';
import 'package:navinotes/screens/main/choose_board/light_academia/edit/overview.dart';

class BoardLightAcadEditScreen extends StatelessWidget {
  BoardLightAcadEditScreen({super.key});
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    Board board = ModalRoute.of(context)?.settings.arguments as Board;
    return ChangeNotifierProvider(
      create: (context) {
        final vm = BoardEditVm(scaffoldKey: _scaffoldKey);
        if (isNotNull(board)) {
          vm.initialize(board.id!);
        }
        return vm;
      },
      child: Consumer<BoardEditVm>(
        builder: (_, vm, _) {
          return ChooseBoardWrapper(
            //Essential; add loading until ready!!
            child: ScaffoldFrame(
              scaffoldKey: _scaffoldKey,
              drawer: CustomDrawer(child: NavigationSideBar()),
              backgroundColor: AppTheme.eggShell.withAlpha(0xFF),
              body: ApiServiceComponent(child: _buildContent(vm)),
            ),
          );
        },
      ),
    );
  }

  Widget _buildContent(BoardEditVm vm) {
    final board = vm.board!;
    return Column(
      children: [
        _header(board),
        Expanded(
          child: ScrollableController(
            mobilePadding: EdgeInsets.only(top: 40),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: ResponsivePadding(
                    mobile: EdgeInsets.symmetric(horizontal: tabletPadding),
                    tablet: EdgeInsets.symmetric(horizontal: 30),
                    child: WidthLimiter(
                      mobile: largeDesktopSize,
                      child: vm.returnSelectedTabItem(
                        BoardLightAcademiaEditOverview(),
                      ),
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

  Widget _header(Board board) {
    return Consumer<BoardEditVm>(
      builder: (context, vm, _) {
        return Consumer<ApiServiceProvider>(
          builder: (_, apiServiceProvider, _) {
            return Consumer<LayoutProviderVm>(
              builder: (_, layoutVm, _) {
                return Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: AppTheme.royalGold.withAlpha(0x4C),
                      ),
                    ),
                    color: AppTheme.ivoryCream,
                    boxShadow: [
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
                  padding: EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: WidthLimiter(
                          mobile: largeDesktopSize,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  spacing: 10,
                                  children: [
                                    MenuButton(
                                      onPressed: vm.openDrawer,
                                      decoration: BoxDecoration(
                                        color: AppTheme.sepiaBrown,
                                      ),
                                    ),
                                    AppButton.text(
                                      wrapWithFlexible: true,
                                      mainAxisSize: MainAxisSize.min,
                                      prefix: Icon(
                                        Icons.arrow_back,
                                        color: AppTheme.sepiaBrown,
                                        size: 18,
                                      ),
                                      onTap: NavigationHelper.pop,
                                      text: board.name,
                                      style: AppTheme.text.copyWith(
                                        color: AppTheme.jetCharcoal,
                                        fontSize: 20.0,
                                        fontFamily: AppTheme.fontEBGaramond,
                                        height: 1.40,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              VisibleController(
                                mobile: false,
                                desktop: true,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: _selectRows(),
                                ),
                              ),

                              VisibleController(
                                mobile: false,
                                tablet: true,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Row(
                                    // spacing: 10,
                                    children: [
                                      AppButton(
                                        mainAxisSize: MainAxisSize.min,
                                        color: AppTheme.lightBrown,
                                        text: 'Upload Syllabus',
                                        loading: vm.uploadingSyllabus,
                                        onTap:
                                            () => vm.uploadSyllabus(
                                              context: context,
                                              apiServiceProvider:
                                                  apiServiceProvider,
                                            ),
                                        style: AppTheme.text.copyWith(
                                          color: AppTheme.white,
                                          fontSize: 16.0,
                                          fontFamily: AppTheme.fontEBGaramond,
                                        ),
                                      ),
                                      //TODO ask about this
                                      // Icon(
                                      //   Icons.search,
                                      //   color: AppTheme.sepiaBrown,
                                      //   size: 24,
                                      // ),
                                      AppIconButton(
                                        onPressed:
                                            NavigationHelper
                                                .navigateToNotification,
                                        icon: Icon(
                                          Icons.notifications,
                                          color: AppTheme.sepiaBrown,
                                          size: 24,
                                        ),
                                      ),
                                      ProfilePic(
                                        borderColor: AppTheme.royalGold
                                            .withAlpha(0x7F),
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
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _selectRows() {
    return Consumer<BoardEditVm>(
      builder: (_, vm, __) {
        return TextRowSelect(
          fillWidth: false,
          items: EditBoardTab.values.map((item) => item.toString()).toList(),
          onSelected: (value) {
            vm.updateSelectedTab(
              stringToEnum<EditBoardTab>(value, EditBoardTab.values),
            );
          },
          borderColor: AppTheme.yellowishOrange.withAlpha(0xFF),
          padding: EdgeInsets.symmetric(vertical: 10),
          btnStyle: TextButton.styleFrom(
            shape: RoundedRectangleBorder(),
            backgroundColor: AppTheme.yellowishOrange.withAlpha(0x19),
          ),
          selectedTextStyle: AppTheme.text.copyWith(
            color: AppTheme.burntLeather.withAlpha(0xFF),
            fontSize: 16.0,
            fontFamily: AppTheme.fontEBGaramond,
          ),
          style: AppTheme.text.copyWith(
            color: AppTheme.sepiaBrown,
            fontSize: 16.0,
            fontFamily: AppTheme.fontEBGaramond,
            height: 1.50,
          ),
        );
      },
    );
  }
}
