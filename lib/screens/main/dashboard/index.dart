import 'main.dart';
import 'vm.dart';
import 'package:navinotes/packages.dart';

class DashboardScreen extends StatelessWidget {
  DashboardScreen({super.key});

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Consumer<SessionManager>(
      builder: (_, sessionVm, _) {
        return ChangeNotifierProvider(
          create:
              (_) =>
                  DashboardVm(scaffoldKey: _scaffoldKey, sessionVm: sessionVm),
          child: Consumer<DashboardVm>(
            builder: (_, vm, _) {
              bool hasData = sessionVm.userBoards.isNotEmpty;
              String activeRoute = Routes.dashboard;
              return ScaffoldFrame(
                backgroundColor: hasData ? AppTheme.lightGray : AppTheme.white,
                scaffoldKey: _scaffoldKey,
                drawer: CustomDrawer(
                  child: NavigationSideBar(activeRoute: activeRoute),
                ),
                floatingActionButton: FloatingActionButton(
                  onPressed: vm.goToCreateBoard,
                  backgroundColor:
                      hasData ? AppTheme.vividRose : AppTheme.tropicalTeal,
                  shape: CircleBorder(),
                  child: Icon(Icons.add, color: AppTheme.white),
                ),
                body: ResponsiveSection(
                  mobile: DashboardMain(),
                  desktop: Row(
                    children: [
                      WidthLimiter(
                        mobile: 255,
                        child: NavigationSideBar(activeRoute: activeRoute),
                      ),
                      Expanded(child: DashboardMain()),
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
