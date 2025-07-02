import 'package:navinotes/packages.dart';

class MyStoreVm extends ChangeNotifier {
  GlobalKey<ScaffoldState> scaffoldKey;
  MyStoreVm({required this.scaffoldKey});

  void openEndDrawer() {
    scaffoldKey.currentState?.openEndDrawer();
  }
}
