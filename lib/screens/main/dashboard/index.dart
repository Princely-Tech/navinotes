import 'package:flutter/material.dart';
import 'package:navinotes/screens/main/dashboard/main.dart';
import 'package:navinotes/widgets/side_drawer.dart';
import 'package:navinotes/screens/main/dashboard/vm.dart';
import 'package:provider/provider.dart';
import 'package:navinotes/settings/index.dart';
import 'package:navinotes/widgets/index.dart';

class DashboardScreen extends StatelessWidget {
  DashboardScreen({super.key});

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) {
        DashboardVm vm = DashboardVm(scaffoldKey: _scaffoldKey);
        // vm.initialize();
        return vm;
      },
      child: Consumer<DashboardVm>(
        builder: (_, vm, _) {
          return ScaffoldFrame(
            backgroundColor: vm.hasData ? Apptheme.lightGray : Apptheme.white,
            scaffoldKey: _scaffoldKey,
            drawer: CustomDrawer(
              child: NavigationSideBar(currentRoute: Routes.dashboard),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: vm.goToCreateBoard,
              backgroundColor: Apptheme.vividRose,
              shape: CircleBorder(),
              child: Icon(Icons.add, color: Apptheme.white),
            ),
            body: ResponsiveSection(
              mobile: DashboardMain(),
              desktop: Row(
                children: [
                  WidthLimiter(
                    mobile: 255,
                    child: NavigationSideBar(currentRoute: Routes.dashboard),
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
