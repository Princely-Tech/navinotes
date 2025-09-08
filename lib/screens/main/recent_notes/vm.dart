import 'package:flutter/material.dart';
import 'package:navinotes/packages.dart';

class RecentNotesVm extends ChangeNotifier {
  GlobalKey<ScaffoldState> scaffoldKey;
  RecentNotesVm({required this.scaffoldKey});
  bool hasData = false;
  List<Content> recentContents = [];
  bool isLoading = false;

  void initialize() {
    loadRecentContents();
  }

  Future<void> loadRecentContents() async {
    isLoading = true;
    notifyListeners();
    
    try {
      recentContents = await DatabaseHelper.instance.getRecentContentsAcrossAllBoards(limit: 10);
      hasData = recentContents.isNotEmpty;
    } catch (e) {
      debugPrint('Error loading recent contents: $e');
      hasData = false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
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
