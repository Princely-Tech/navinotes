import 'header.dart';
import 'main.dart';
import 'side_drawer.dart';
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
        endDrawer: CustomDrawer(child: ChooseBoardAside()),
        drawer: CustomDrawer(
          child: NavigationSideBar(activeRoute: activeRoute),
        ),
        backgroundColor: Apptheme.lightGray,
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
                  Expanded(
                    child: ResponsiveSection(
                      mobile: ChooseBoardMain(),
                      desktop: Row(
                        children: [
                          Expanded(child: ChooseBoardMain()),
                          WidthLimiter(
                            mobile: 280,
                            largeDesktop: 360,
                            child: ChooseBoardAside(),
                          ),
                        ],
                      ),
                    ),
                  ),
                  _footer(),
                ],
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
          decoration: BoxDecoration(color: Apptheme.white),
          child: LayoutBuilder(
            builder: (_, constraints) {
              return ScrollableRow(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Container(
                  constraints: BoxConstraints(minWidth: constraints.maxWidth),
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
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
                            activeColor: Apptheme.vividRose,
                            inactiveColor: Apptheme.lightGray,
                          ),
                          Text(
                            'Save as Favorite Style',
                            style: Apptheme.text.copyWith(
                              color: Apptheme.vividRose,
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
                            style: Apptheme.text.copyWith(
                              color: Apptheme.vividRose,
                              fontWeight: getFontWeight(500),
                            ),
                            minHeight: 35,
                            color: Apptheme.vividRose,
                            text: 'Skip & Use Default',
                          ),
                          AppButton(
                            minHeight: 35,
                            color: Apptheme.vividRose,
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
