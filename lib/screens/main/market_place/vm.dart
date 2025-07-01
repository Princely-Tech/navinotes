import 'package:flutter/material.dart';

class MarketPlaceVm extends ChangeNotifier {
  GlobalKey<ScaffoldState> scaffoldKey;
  MarketPlaceVm({required this.scaffoldKey});
 
  void openDrawer() {
    scaffoldKey.currentState?.openDrawer();
  }
}
