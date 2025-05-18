import 'package:flutter/material.dart';
import 'package:navinotes/settings/navigation_helper.dart';
import 'package:navinotes/settings/routes.dart';
import 'package:navinotes/settings/screen_dimensions.dart';

class BoardNotesVm extends ChangeNotifier {
  GlobalKey<ScaffoldState> scaffoldKey;
  BoardNotesVm({required this.scaffoldKey});
  void openDrawer() {
    scaffoldKey.currentState?.openEndDrawer();
  }
}
