import 'package:navinotes/packages.dart';

class FlashCardAiCreationVm extends ChangeNotifier {
   GlobalKey<ScaffoldState> scaffoldKey;
   FlashCardAiCreationVm({required this.scaffoldKey});

     void openDrawer() {
    scaffoldKey.currentState?.openDrawer();
  }

  void openEndDrawer() {
    scaffoldKey.currentState?.openEndDrawer();
  }
}