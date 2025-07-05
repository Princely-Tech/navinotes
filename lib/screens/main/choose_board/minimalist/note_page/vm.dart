import 'package:navinotes/packages.dart';

class MinimalistNotePageVm extends ChangeNotifier {
  GlobalKey<ScaffoldState> scaffoldKey;
  MinimalistNotePageVm({required this.scaffoldKey});


  void openEndDrawer() {
    scaffoldKey.currentState?.openEndDrawer();
  }

  void gotToCreateNotePage() {
    NavigationHelper.push(Routes.noteTemplate);
  }
}
