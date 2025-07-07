import 'package:navinotes/packages.dart';

class MinimalistMindMapVm extends ChangeNotifier {
  GlobalKey<ScaffoldState> scaffoldKey;
  MinimalistMindMapVm({required this.scaffoldKey});

  void openDrawer() {
    scaffoldKey.currentState?.openDrawer();
  }

  void openEndDrawer() {
    scaffoldKey.currentState?.openEndDrawer();
  }
}
