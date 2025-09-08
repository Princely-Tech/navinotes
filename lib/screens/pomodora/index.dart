import 'package:navinotes/packages.dart';
import 'vm.dart';
import 'main.dart';
import 'header.dart';
import 'aside.dart';

class PomodoroTimerScreen extends StatelessWidget {
  const PomodoroTimerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scaffoldKey = GlobalKey<ScaffoldState>();

    return ChangeNotifierProvider(
      create:
          (_) => PomodoroTimerVm(scaffoldKey: scaffoldKey, context: context),
      child: Consumer<PomodoroTimerVm>(
        builder: (_, vm, _) {
          return Scaffold(
            key: scaffoldKey,
            drawer: CustomDrawer(
              child: NavigationSideBar(activeRoute: Routes.pomodoroTimer),
            ),
            endDrawer: CustomDrawer(
              child: Container(width: 300, child: PomodoroTimerAside()),
            ),
            body: Column(
              children: [
                // Header
                PomodoroTimerHeader(),

                // Main content
                VisibleController(
                  mobile: true,
                  desktop: false,
                  child: Expanded(
                    child: Column(
                      children: [Expanded(child: PomodoroTimerMain())],
                    ),
                  ),
                ),
                VisibleController(
                  mobile: false,
                  desktop: true,
                  child: Expanded(
                    child: Row(
                      children: [
                        // Main body
                        Expanded(child: PomodoroTimerMain()),
                        // Aside
                        Container(width: 350, child: PomodoroTimerAside()),
                      ],
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
}
