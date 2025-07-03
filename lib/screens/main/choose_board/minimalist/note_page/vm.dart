import 'package:navinotes/packages.dart';

class MinimalistNotePageVm extends ChangeNotifier {
  GlobalKey<ScaffoldState> scaffoldKey;
  MinimalistNotePageVm({required this.scaffoldKey});

  PageDisplayFormat pageDisplayFormat = PageDisplayFormat.list;

  void updatePageDisplayFormat(PageDisplayFormat format) {
    pageDisplayFormat = format;
    notifyListeners();
  }

  void openEndDrawer() {
    scaffoldKey.currentState?.openEndDrawer();
  }

  void gotToCreateNotePage() {
    NavigationHelper.push(Routes.noteTemplate);
  }
}
