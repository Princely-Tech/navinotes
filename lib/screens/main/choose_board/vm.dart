import 'package:flutter/material.dart';
import 'package:navinotes/models/board.dart';
import 'package:navinotes/settings/navigation_helper.dart';

class ChooseBoardVm extends ChangeNotifier {
  GlobalKey<ScaffoldState> scaffoldKey;
  ChooseBoardVm({required this.scaffoldKey});

  double backgroundPatternOpacity = 0;
  bool saveAsFavoriteStyle = false; //TODO this value isnt used
  BoardType selectedBoard = boardTypes.first;
  final TextEditingController searchController = TextEditingController();
  List<BoardType> filteredBoards = List.from(boardTypes);

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void updateSearchQuery(String query) {
    debugPrint(query);
    if (query.isEmpty) {
      filteredBoards = List.from(boardTypes);
    } else {
      filteredBoards = boardTypes
          .where((board) =>
              board.name.toLowerCase().contains(query.toLowerCase()) ||
              board.description.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }

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

  // void openEndDrawer() {
  //   scaffoldKey.currentState?.openEndDrawer();
  // }

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
      NavigationHelper.push(selectedBoard.route);
    }
  }
}
