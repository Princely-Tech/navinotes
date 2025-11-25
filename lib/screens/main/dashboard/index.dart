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
                backgroundColor: hasData ? AppTheme.whiteSmoke : AppTheme.white,
                scaffoldKey: _scaffoldKey,
                drawer: CustomDrawer(
                  child: NavigationSideBar(activeRoute: activeRoute),
                ),
                floatingActionButton: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FloatingActionButton.extended(
                      onPressed: () => vm.importBoard(context),
                      backgroundColor: AppTheme.vividBlue,
                      icon: const Icon(
                        Icons.file_upload,
                        color: AppTheme.white,
                      ),
                      label: const Text(
                        'Import',
                        style: TextStyle(color: AppTheme.white),
                      ),
                    ),
                    const SizedBox(height: 12),
                    FloatingActionButton(
                      onPressed: vm.goToCreateBoard,
                      backgroundColor:
                          hasData ? AppTheme.vividRose : AppTheme.tropicalTeal,
                      shape: const CircleBorder(),
                      child: Icon(Icons.add, color: AppTheme.white),
                    ),
                  ],
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
