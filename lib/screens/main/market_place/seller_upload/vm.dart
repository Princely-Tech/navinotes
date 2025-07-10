import 'package:navinotes/packages.dart';

class SellerUploadVm extends ChangeNotifier {
  GlobalKey<ScaffoldState> scaffoldKey;
  SellerUploadVm({required this.scaffoldKey});

  void openEndDrawer() {
    scaffoldKey.currentState?.openEndDrawer();
  }

 
}
