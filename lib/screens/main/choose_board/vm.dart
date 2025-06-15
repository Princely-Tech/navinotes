import 'package:flutter/material.dart';
import 'package:navinotes/models/board.dart';
import 'package:navinotes/settings/navigation_helper.dart';

class ChooseBoardVm extends ChangeNotifier {
  GlobalKey<ScaffoldState> scaffoldKey;
  ChooseBoardVm({required this.scaffoldKey});

  double backgroundPatternOpacity = 0;

  bool saveAsFavoriteStyle = false;
  BoardType selectedBoard = boardTypes.first;

  void updateBackgroundPatternOpacity(double value) {
    backgroundPatternOpacity = value;
    notifyListeners();
  }

  void updateSelectedBoard(BoardType value) {
    selectedBoard = value;
    notifyListeners();
  }

  void updateSaveAsFavoriteStyle(bool value) {
    saveAsFavoriteStyle = value;
    notifyListeners();
  }

  void openEndDrawer() {
    scaffoldKey.currentState?.openEndDrawer();
  }

  void openDrawer() {
    scaffoldKey.currentState?.openDrawer();
  }

  void skipAndUseDefault() {
    for (int i = 0; i < boardTypes.length; i++) {
      if (boardTypes[i].route.isNotEmpty) {
        NavigationHelper.push(boardTypes[i].route);
        break;
      }
    }
  }

  void createBoard() {
    goNext();
  }

  void goNext() {
    if (selectedBoard.route.isNotEmpty) {
      NavigationHelper.pushReplacement(selectedBoard.route);
    }
  }
}
