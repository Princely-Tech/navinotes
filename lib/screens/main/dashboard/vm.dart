import 'package:flutter/material.dart';
import 'package:navinotes/settings/navigation_helper.dart';
import 'package:navinotes/settings/routes.dart';
import 'package:navinotes/settings/screen_dimensions.dart';

class DashboardVm extends ChangeNotifier {
  GlobalKey<ScaffoldState> scaffoldKey;
  DashboardVm({required this.scaffoldKey});
  void openDrawer() {
    scaffoldKey.currentState?.openDrawer();
  }

  bool getMenuVisible(DeviceType deviceType) {
    return deviceType == DeviceType.mobile ||
        deviceType == DeviceType.tablets ||
        deviceType == DeviceType.laptops;
  }
  goToCreateBoard(){
      NavigationHelper.push(Routes.chooseBoard);
  }
}
