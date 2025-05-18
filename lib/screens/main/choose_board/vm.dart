import 'package:flutter/material.dart';
import 'package:navinotes/settings/navigation_helper.dart';
import 'package:navinotes/settings/routes.dart';
import 'package:navinotes/settings/screen_dimensions.dart';

class ChooseBoardVm extends ChangeNotifier {
  GlobalKey<ScaffoldState> scaffoldKey;
  ChooseBoardVm({required this.scaffoldKey});

  double backgroundPatternOpacity = 0;

  bool saveAsFavoriteStyle = false;
  String selectedBoard = 'Plain';

  void updateBackgroundPatternOpacity(double value) {
    backgroundPatternOpacity = value;
    notifyListeners();
  }

  void updateSelectedBoard(String value) {
    selectedBoard = value;
    notifyListeners();
  }

  void updateSaveAsFavoriteStyle(bool value) {
    saveAsFavoriteStyle = value;
    notifyListeners();
  }

  void openDrawer() {
    scaffoldKey.currentState?.openEndDrawer();
  }

  bool getMenuVisible(DeviceType deviceType) {
    return deviceType == DeviceType.mobile ||
        deviceType == DeviceType.tablets ||
        deviceType == DeviceType.laptops;
  }

  void skipAndUseDefault() {
    goNext();
  }

  void createBoard() {
    goNext();
  }

  void goNext() {
    NavigationHelper.pushReplacement(Routes.dashboard);
  }
}
