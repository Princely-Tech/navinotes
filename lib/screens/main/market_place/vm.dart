import 'package:navinotes/packages.dart';

class MarketPlaceVm extends ChangeNotifier {
  GlobalKey<ScaffoldState> scaffoldKey;
  MarketPlaceVm({required this.scaffoldKey});

  void openDrawer() {
    scaffoldKey.currentState?.openDrawer();
  }

  void goToProductDetail() {
    NavigationHelper.push(Routes.productDetail);
  }
}
