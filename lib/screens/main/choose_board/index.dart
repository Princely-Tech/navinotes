import 'header.dart';
import 'main.dart';
import 'vm.dart';
import 'package:navinotes/packages.dart';

class ChooseBoardScreen extends StatelessWidget {
  ChooseBoardScreen({super.key});

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    String activeRoute = Routes.dashboard;
    return ChangeNotifierProvider(
      create: (context) => ChooseBoardVm(scaffoldKey: _scaffoldKey),
      child: ScaffoldFrame(
        scaffoldKey: _scaffoldKey,
        drawer: CustomDrawer(
          child: NavigationSideBar(activeRoute: activeRoute),
        ),
        backgroundColor: AppTheme.whiteSmoke,
        body: Row(
          children: [
            VisibleController(
              mobile: false,
              largeDesktop: true,
              child: NavigationSideBar(
                activeRoute: activeRoute,
                shrinkWrap: true,
              ),
            ),

            Expanded(
              child: Column(
                children: [
                  ChooseBoardHeader(),
                  Expanded(child: ChooseBoardMain()),
                  _footer(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
    return ChangeNotifierProvider(
      create: (context) => ChooseBoardVm(scaffoldKey: _scaffoldKey),
      child: ScaffoldFrame(
        scaffoldKey: _scaffoldKey,
        drawer: CustomDrawer(
          child: NavigationSideBar(activeRoute: activeRoute),
        ),
        backgroundColor: AppTheme.whiteSmoke,
        body: Row(
          children: [
            VisibleController(
              mobile: false,
              largeDesktop: true,
              child: NavigationSideBar(
                activeRoute: activeRoute,
                shrinkWrap: true,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _footer() {
    return Consumer<ChooseBoardVm>(
      builder: (_, vm, _) {
        return Container(
          decoration: BoxDecoration(color: AppTheme.white),
          child: LayoutBuilder(
            builder: (_, constraints) {
              bool isNarrow = constraints.maxWidth < 400;

              return ScrollableRow(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Container(
                  constraints: BoxConstraints(minWidth: constraints.maxWidth),
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child:
                      isNarrow
                          ? Column(
                            spacing: 10,
                            children: [
                              Row(
                                spacing: 10,
                                children: [
                                  FlutterSwitch(
                                    width: 40,
                                    height: 22,
                                    toggleSize: 20,
                                    value: vm.saveAsFavoriteStyle,
                                    padding: 1,
                                    onToggle: vm.updateSaveAsFavoriteStyle,
                                    activeColor: AppTheme.vividRose,
                                    inactiveColor: AppTheme.lightGray,
                                  ),
                                  Text(
                                    'Save as Favorite Style',
                                    style: AppTheme.text.copyWith(
                                      color: AppTheme.vividRose,
                                      fontWeight: getFontWeight(500),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                spacing: 20,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  AppButton.secondary(
                                    wrapWithFlexible: true,
                                    mainAxisSize: MainAxisSize.min,
                                    onTap: vm.skipAndUseDefault,
                                    style: AppTheme.text.copyWith(
                                      color: AppTheme.vividRose,
                                      fontWeight: getFontWeight(500),
                                    ),
                                    minHeight: 35,
                                    color: AppTheme.vividRose,
                                    text: 'Skip & Use Default',
                                  ),
                                  AppButton(
                                    minHeight: 35,
                                    color: AppTheme.vividRose,
                                    wrapWithFlexible: true,
                                    mainAxisSize: MainAxisSize.min,
                                    onTap: vm.createBoard,
                                    text: 'Create Board',
                                  ),
                                ],
                              ),
                            ],
                          )
                          : Row(
                            spacing: 30,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                spacing: 10,
                                children: [
                                  FlutterSwitch(
                                    width: 40,
                                    height: 22,
                                    toggleSize: 20,
                                    value: vm.saveAsFavoriteStyle,
                                    padding: 1,
                                    onToggle: vm.updateSaveAsFavoriteStyle,
                                    activeColor: AppTheme.vividRose,
                                    inactiveColor: AppTheme.lightGray,
                                  ),
                                  Text(
                                    'Save as Favorite Style',
                                    style: AppTheme.text.copyWith(
                                      color: AppTheme.vividRose,
                                      fontWeight: getFontWeight(500),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                spacing: 20,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  AppButton.secondary(
                                    wrapWithFlexible: true,
                                    mainAxisSize: MainAxisSize.min,
                                    onTap: vm.skipAndUseDefault,
                                    style: AppTheme.text.copyWith(
                                      color: AppTheme.vividRose,
                                      fontWeight: getFontWeight(500),
                                    ),
                                    minHeight: 35,
                                    color: AppTheme.vividRose,
                                    text: 'Skip & Use Default',
                                  ),
                                  AppButton(
                                    minHeight: 35,
                                    color: AppTheme.vividRose,
                                    wrapWithFlexible: true,
                                    mainAxisSize: MainAxisSize.min,
                                    onTap: vm.createBoard,
                                    text: 'Create Board',
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
      },
    );
  }
}
