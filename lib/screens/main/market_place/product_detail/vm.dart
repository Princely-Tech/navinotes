import 'package:navinotes/models/markeplace_item.dart';
import 'package:navinotes/packages.dart';

class ProductDetailVm extends ChangeNotifier {
  GlobalKey<ScaffoldState> scaffoldKey;
  final MarketItem product;
  ApiServiceProvider apiServiceProvider;
  FToast fToast = FToast();
  BuildContext context;
  
  ProductDetailVm({
    required this.scaffoldKey,
    required this.product,
    required this.apiServiceProvider,
    required this.context,
  });

    void initialize() {
    fToast.init(context);
  }

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

  void addToCart() {
    // TODO: implement addToCart
    
    fToast.showToast(
      child: MessageDisplayContainer('Item added to cart', isError: false),
      gravity: AppConstants.toastGravity,
      toastDuration: AppConstants.toastDuration,
    );
  }
}
