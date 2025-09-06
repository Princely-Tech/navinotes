import 'package:navinotes/packages.dart';

class MindMapVm extends ChangeNotifier {
  GlobalKey<ScaffoldState> scaffoldKey;
  MindMapVm({required this.scaffoldKey});

  void openDrawer() {
    scaffoldKey.currentState?.openDrawer();
  }

  void openEndDrawer() {
    scaffoldKey.currentState?.openEndDrawer();
  }
}
