import 'package:navinotes/packages.dart';

class BoardLightAcadNotePageVm extends ChangeNotifier {
  GlobalKey<ScaffoldState> scaffoldKey;
  BoardLightAcadNotePageVm({required this.scaffoldKey});


  void openEndDrawer() {
    scaffoldKey.currentState?.openEndDrawer();
  }

  void gotToCreateNotePage() {
    // NavigationHelper.push(Routes.noteTemplate);
  }
}
