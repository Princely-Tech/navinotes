import 'package:navinotes/packages.dart';

class BoardPlainMindMapVm extends ChangeNotifier {
  GlobalKey<ScaffoldState> scaffoldKey;
  BoardPlainMindMapVm({required this.scaffoldKey});

  void openDrawer() {
    scaffoldKey.currentState?.openDrawer();
  }

  void openEndDrawer() {
    scaffoldKey.currentState?.openEndDrawer();
  }
}
