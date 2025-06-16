import 'package:navinotes/packages.dart';

class DarkAcademiaCreateNoteVm extends ChangeNotifier {
  GlobalKey<ScaffoldState> scaffoldKey;
  DarkAcademiaCreateNoteVm({required this.scaffoldKey});

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
