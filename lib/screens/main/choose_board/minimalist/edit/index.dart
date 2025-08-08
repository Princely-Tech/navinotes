import 'package:navinotes/packages.dart';
import 'package:navinotes/screens/main/choose_board/minimalist/edit/overview.dart';

class BoardMinimalistEditScreen extends StatelessWidget {
  BoardMinimalistEditScreen({super.key});
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
            //Essential; add loading until ready!!
            child: ScaffoldFrame(
              scaffoldKey: _scaffoldKey,
              drawer: CustomDrawer(child: NavigationSideBar()),
              backgroundColor: AppTheme.white,
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
        _selectRows(),
        Expanded(
          child: ScrollableController(
            mobilePadding: EdgeInsets.only(top: 40),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: ResponsivePadding(
                    mobile: EdgeInsets.symmetric(horizontal: tabletPadding),
                    child: WidthLimiter(
                      mobile: largeDesktopSize,
                      child: vm.returnSelectedTabItem(
                        BoardMinimalistEditOverview(),
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

  Widget _selectRows() {
    return Consumer<LayoutProviderVm>(
      builder: (_, layoutVm, _) {
        double padding = getDeviceResponsiveValue(
          deviceType: layoutVm.deviceType,
          mobile: mobilePadding,
          tablet: tabletPadding,
        );
        return Consumer<BoardEditVm>(
          builder: (_, vm, __) {
            return Container(
              color: AppTheme.white,
              child: Padding(
                padding: EdgeInsets.only(
                  top: 10,
                  right: padding,
                  left: padding,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: WidthLimiter(
                        mobile: largeDesktopSize,
                        child: TextRowSelect(
                          items:
                              EditBoardTab.values
                                  .map((item) => item.toString())
                                  .toList(),
                          onSelected: (value) {
                            vm.updateSelectedTab(
                              stringToEnum<EditBoardTab>(
                                value,
                                EditBoardTab.values,
                              ),
                            );
                          },
                          borderColor: AppTheme.strongBlue,
                          inActiveBorderColor: AppTheme.lightGray,
                          padding: EdgeInsets.symmetric(vertical: 10),
                          selectedTextStyle: AppTheme.text.copyWith(
                            color: AppTheme.strongBlue,
                            fontSize: 16.0,
                            fontWeight: getFontWeight(300),
                          ),
                          style: AppTheme.text.copyWith(
                            color: AppTheme.midGray,
                            fontSize: 16.0,
                            fontWeight: getFontWeight(300),
                            height: 1.50,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
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
                      bottom: BorderSide(color: AppTheme.offWhite),
                    ),
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
                              Expanded(
                                child: Row(
                                  spacing: 10,
                                  children: [
                                    MenuButton(
                                      onPressed: vm.openDrawer,
                                      decoration: BoxDecoration(
                                        color: AppTheme.graniteGray,
                                      ),
                                    ),
                                    AppButton.text(
                                      wrapWithFlexible: true,
                                      mainAxisSize: MainAxisSize.min,
                                      prefix: Icon(
                                        Icons.arrow_back,
                                        color: AppTheme.graniteGray,
                                        size: 18,
                                      ),
                                      onTap: NavigationHelper.pop,
                                      text: board.name,
                                      style: AppTheme.text.copyWith(
                                        color: AppTheme.graniteGray,
                                        fontWeight: getFontWeight(300),
                                        height: 1.43,
                                        letterSpacing: 0.70,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              VisibleController(
                                mobile: false,
                                tablet: true,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: AppButton.secondary(
                                    mainAxisSize: MainAxisSize.min,
                                    color: AppTheme.strongBlue,
                                    text: 'Upload Syllabus',
                                    loading: vm.uploadingSyllabus,
                                    onTap:
                                        () => vm.uploadSyllabus(
                                          context: context,
                                          apiServiceProvider:
                                              apiServiceProvider,
                                        ),
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
}
