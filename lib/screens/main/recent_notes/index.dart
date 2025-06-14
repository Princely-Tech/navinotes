import 'main.dart';
import 'vm.dart';
import 'package:navinotes/packages.dart';

class RecentNotesScreen extends StatelessWidget {
  RecentNotesScreen({super.key});

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) {
        RecentNotesVm vm = RecentNotesVm(scaffoldKey: _scaffoldKey);
        vm.initialize();
        return vm;
      },

      child: Consumer<RecentNotesVm>(
        builder: (_, vm, _) {
          Widget sideBar = NavigationSideBar(currentRoute: Routes.recentNotes);
          return ScaffoldFrame(
            backgroundColor: vm.hasData ? Apptheme.lightGray : Apptheme.white,
            scaffoldKey: _scaffoldKey,
            drawer: CustomDrawer(child: sideBar),
            floatingActionButton: FloatingActionButton(
              onPressed: () {},
              backgroundColor: Apptheme.jungleTeal,
              shape: CircleBorder(),
              child: Icon(Icons.add, color: Apptheme.white),
            ),
            body: ResponsiveSection(
              mobile: RecentNotesMain(),
              desktop: Row(
                children: [
                  WidthLimiter(mobile: 255, child: sideBar),
                  Expanded(child: RecentNotesMain()),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
