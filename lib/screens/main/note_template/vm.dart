import 'package:flutter/material.dart';

class NoteTemplateVm extends ChangeNotifier {
  GlobalKey<ScaffoldState> scaffoldKey;
  NoteTemplateVm({required this.scaffoldKey});
  void openDrawer() {
    scaffoldKey.currentState?.openEndDrawer();
  }

 
}
