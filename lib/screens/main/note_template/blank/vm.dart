import 'package:navinotes/packages.dart';

class BlankNoteVm extends ChangeNotifier {
  GlobalKey<ScaffoldState> scaffoldKey;
  BlankNoteVm({required this.scaffoldKey});


  void openDrawer() {
    scaffoldKey.currentState?.openDrawer();
  }

  void openEndDrawer() {
    scaffoldKey.currentState?.openEndDrawer();
  }
}


