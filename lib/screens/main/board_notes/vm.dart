import 'package:flutter/material.dart';

class BoardNotesVm extends ChangeNotifier {
  GlobalKey<ScaffoldState> scaffoldKey;
  BoardNotesVm({required this.scaffoldKey});
  void openDrawer() {
    scaffoldKey.currentState?.openEndDrawer();
  }
}
