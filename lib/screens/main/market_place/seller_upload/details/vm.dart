import 'package:navinotes/packages.dart';

class SellerUploadVm extends ChangeNotifier {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final Board board;

  SellerUploadVm({
    required this.scaffoldKey,
    required this.board,
  });

  void openEndDrawer() {
    scaffoldKey.currentState?.openEndDrawer();
  }
}
