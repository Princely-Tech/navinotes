import 'package:flutter/material.dart';

class RecentNotesVm extends ChangeNotifier {
  GlobalKey<ScaffoldState> scaffoldKey;
  RecentNotesVm({required this.scaffoldKey});
  bool hasData = false; 

  void initialize() {
    // Future.delayed(Duration(seconds: 5), () {
    //   hasData = true;
    //   notifyListeners();
    // });
  }

  void openDrawer() {
    scaffoldKey.currentState?.openDrawer();
  }

  // goToCreateBoard() {
  //   NavigationHelper.push(Routes.chooseBoard);
  // }

  // goToBoardNotes() {
  //   NavigationHelper.push(Routes.boardNotes);
  // }
}
