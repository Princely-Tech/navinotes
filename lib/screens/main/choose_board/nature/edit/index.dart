import 'package:navinotes/packages.dart';
import 'overview.dart';

class BoardNatureEditScreen extends StatelessWidget {
  const BoardNatureEditScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Board board = ModalRoute.of(context)?.settings.arguments as Board;
    return ChangeNotifierProvider(
      create: (context) {
       final vm = BoardEditVm( board: board);
        vm.initialize();
        return vm;
      },
      child: Consumer<BoardEditVm>(
        builder: (_, vm, _) {
          return ChooseBoardWrapper(
            //Essential; add loading until ready!!
            child: ScaffoldFrame(
              // scaffoldKey: _scaffoldKey,
              // drawer: CustomDrawer(child: NavigationSideBar()),
              backgroundColor: AppTheme.white,
              body: ApiServiceComponent(child: _buildContent(vm)),
            ),
          );
        },
      ),
    );
  }

  Column _buildContent(BoardEditVm vm) {
    return Column(
      children: [
        _header(),
        _selectRows(),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment(0.00, 0.50),
                end: Alignment(1.00, 0.50),
                colors: [
                  AppTheme.dustyOlive.withAlpha(0x4C),
                  AppTheme.softLinen,
                ],
              ),
            ),
            child: ScrollableController(
              mobilePadding: EdgeInsets.only(top: tabletPadding),
              tabletPadding: EdgeInsets.only(top: tabletPadding),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: WidthLimiter(
                      mobile: largeDesktopSize,
                      child: vm.returnSelectedTabItem(
                        BoardNatureEditOverview(),
                      ),
                    ),
                  ),
                ],
              ),
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
                          // items: [
                          //   'Overview',
                          //   'Uploads',
                          //   'Assignments',
                          //   'Resources',
                          // ],
                          //TODO add resources
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
                          selectedTextColor: AppTheme.sageMist,
                          borderColor: AppTheme.sageMist,
                          textColor: AppTheme.steelMist,
                          padding: EdgeInsets.symmetric(vertical: 10),
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

  Widget _header() {
    return Consumer<LayoutProviderVm>(
      builder: (_, layoutVm, _) {
        return Consumer<ApiServiceProvider>(
          builder: (_, apiServiceProvider, _) {
            return Consumer<BoardEditVm>(
              builder: (context, vm, _) {
                final board = vm.board!;
                return Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment(0.00, 0.50),
                      end: Alignment(1.00, 0.50),
                      colors: [AppTheme.sageMist, AppTheme.dustyOlive],
                    ),
                  ),
                  child: ResponsivePadding(
                    mobile: EdgeInsets.all(mobilePadding),
                    tablet: EdgeInsets.all(tabletPadding),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back),
                          color: AppTheme.white,
                          onPressed: NavigationHelper.pop,
                        ),
                        const SizedBox(width: 10),
                        Flexible(
                          child: WidthLimiter(
                            mobile: largeDesktopSize,
                            child: Row(
                              spacing: 10,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    spacing: 10,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        board.name,
                                        style: AppTheme.text.copyWith(
                                          color: AppTheme.white,
                                          fontSize: getDeviceResponsiveValue(
                                            deviceType: layoutVm.deviceType,
                                            mobile: 18.0,
                                            tablet: 22.0,
                                            laptop: 24.0,
                                            desktop: 30.0,
                                          ),
                                          fontWeight: getFontWeight(600),
                                          height: 1.20,
                                        ),
                                      ),
                                      Text(
                                        board.term ?? "",
                                        style: AppTheme.text.copyWith(
                                          color: AppTheme.white.withAlpha(204),
                                          fontSize: 16.0,
                                          height: 1.50,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                AppButton(
                                  mainAxisSize: MainAxisSize.min,
                                  color: AppTheme.white,
                                  text: 'Upload Syllabus',
                                  loading: vm.uploadingSyllabus,
                                  prefix: SVGImagePlaceHolder(
                                    imagePath: Images.upload,
                                    color: AppTheme.sageMist,
                                    size: 16,
                                  ),
                                  onTap:
                                      () => vm.uploadSyllabus(
                                        context: context,
                                        apiServiceProvider: apiServiceProvider,
                                      ),
                                  style: AppTheme.text.copyWith(
                                    color: AppTheme.sageMist,
                                    fontSize: 16.0,
                                  ),
                                ),
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
          },
        );
      },
    );
  }
}
