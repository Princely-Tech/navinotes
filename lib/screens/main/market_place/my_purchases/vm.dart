import 'package:navinotes/packages.dart';

class MyPurchasesVm extends ChangeNotifier {
  GlobalKey<ScaffoldState> scaffoldKey;
  MyPurchasesVm({required this.scaffoldKey});

  void openDrawer() {
    scaffoldKey.currentState?.openDrawer();
  }


}
