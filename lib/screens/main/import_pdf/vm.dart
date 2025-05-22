import 'package:flutter/material.dart';

class ImportPdfVm extends ChangeNotifier {
  GlobalKey<ScaffoldState> scaffoldKey;
  ImportPdfVm({required this.scaffoldKey});
  String selectedFilter = 'All PDFs';

  void updateSelectedFilter(String filter) {
    selectedFilter = filter;
    notifyListeners();
  }

  void openDrawer() {
    scaffoldKey.currentState?.openDrawer();
  }
}
