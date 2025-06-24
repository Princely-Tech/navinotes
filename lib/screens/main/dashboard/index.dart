import 'main.dart';
import 'vm.dart';
import 'package:navinotes/packages.dart';

class DashboardScreen extends StatelessWidget {
  DashboardScreen({super.key});

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) {
        DashboardVm vm = DashboardVm(scaffoldKey: _scaffoldKey);
        vm.initialize();
        return vm;
      },
      child: Consumer<DashboardVm>(
        builder: (_, vm, _) {
          String activeRoute = Routes.dashboard;
          return ScaffoldFrame(
            backgroundColor: vm.hasData ? AppTheme.lightGray : AppTheme.white,
            scaffoldKey: _scaffoldKey,
            drawer: CustomDrawer(
              child: NavigationSideBar(activeRoute: activeRoute),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: vm.goToCreateBoard,
              backgroundColor:
                  vm.hasData ? AppTheme.vividRose : AppTheme.tropicalTeal,
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
  }
}
