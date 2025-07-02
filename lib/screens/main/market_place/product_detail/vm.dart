import 'package:navinotes/packages.dart';

class ProductDetailVm extends ChangeNotifier {
  GlobalKey<ScaffoldState> scaffoldKey;
  ProductDetailVm({required this.scaffoldKey});

  ExpandableCarouselController carouselController = ExpandableCarouselController();

  void goToNext() {
    carouselController.nextPage(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void goToPrevious() {
    carouselController.previousPage(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void openEndDrawer() {
    scaffoldKey.currentState?.openEndDrawer();
  }
}
