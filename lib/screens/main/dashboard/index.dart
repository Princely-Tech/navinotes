import 'package:flutter/material.dart';
import 'package:navinotes/screens/main/dashboard/main.dart';
import 'package:navinotes/screens/main/dashboard/side_drawer.dart';
import 'package:navinotes/screens/main/dashboard/vm.dart';
import 'package:navinotes/settings/apptheme.dart';
import 'package:navinotes/settings/ui_helpers.dart';
import 'package:navinotes/widgets/components.dart';
import 'package:navinotes/widgets/frames.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatelessWidget {
  DashboardScreen({super.key});

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return ScaffoldFrame(
      scaffoldKey: _scaffoldKey,
      drawer: Drawer(
        backgroundColor: Apptheme.white,
        shape: RoundedRectangleBorder(),
        child: DashboardSideBar(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Apptheme.strongBlue,
        shape: CircleBorder(),
        child: Icon(Icons.add, color: Apptheme.white),
      ),
      body: ChangeNotifierProvider(
        create: (context) => DashboardVm(scaffoldKey: _scaffoldKey),
        child: ResponsiveSection(
          mobile: DashboardMain(),
          desktops: Row(
            children: [
              WidthLimiter(maxWidth: 255, child: DashboardSideBar()),
              Expanded(child: DashboardMain()),
            ],
          ),
        ),
      ),
    );
  }
}
