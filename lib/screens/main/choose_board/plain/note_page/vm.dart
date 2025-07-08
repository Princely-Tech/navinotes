import 'package:navinotes/packages.dart';

class BoardPlainNotePageVm extends ChangeNotifier {
  GlobalKey<ScaffoldState> scaffoldKey;
  BoardPlainNotePageVm({required this.scaffoldKey});
  void openDrawer() {
    scaffoldKey.currentState?.openEndDrawer();
  }

  gotToCreateNotePage() {
    // NavigationHelper.push(Routes.noteTemplate);
  }
}
