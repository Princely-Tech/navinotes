import 'package:flutter/material.dart';
import 'package:navinotes/settings/navigation_helper.dart';
import 'package:navinotes/settings/routes.dart';

class DashboardVm extends ChangeNotifier {
  GlobalKey<ScaffoldState> scaffoldKey;
  DashboardVm({required this.scaffoldKey});
  void openDrawer() {
    scaffoldKey.currentState?.openDrawer();
  }

  goToCreateBoard() {
    NavigationHelper.push(Routes.chooseBoard);
  }

  goToBoardNotes() {
    NavigationHelper.push(Routes.boardNotes);
  }
}
