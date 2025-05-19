import 'package:flutter/material.dart';
import 'package:navinotes/settings/navigation_helper.dart';

class BoardNotesVm extends ChangeNotifier {
  GlobalKey<ScaffoldState> scaffoldKey;
  BoardNotesVm({required this.scaffoldKey});
  void openDrawer() {
    scaffoldKey.currentState?.openEndDrawer();
  }
  gotToCreateNotePage() {
    // NavigationHelper.goToCreateNote();
  }
}
