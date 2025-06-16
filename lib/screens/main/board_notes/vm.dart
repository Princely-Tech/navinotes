import 'package:navinotes/packages.dart';

class BoardNotesVm extends ChangeNotifier {
  GlobalKey<ScaffoldState> scaffoldKey;
  BoardNotesVm({required this.scaffoldKey});
  void openDrawer() {
    scaffoldKey.currentState?.openEndDrawer();
  }

  gotToCreateNotePage() {
    NavigationHelper.push(Routes.noteTemplate);
  }
}
