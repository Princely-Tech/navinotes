import 'package:navinotes/packages.dart';

class FlashCardStudyVm extends ChangeNotifier {
  GlobalKey<ScaffoldState> scaffoldKey;
  FlashCardStudyVm({required this.scaffoldKey});

  QuillController frontController = QuillController.basic();
  QuillController backController = QuillController.basic();

  final flipCardController = FlipCardController();

  void flipCard() {
    flipCardController.flipcard();
  }

  void initialize() {
    frontController.readOnly = true;
    backController.readOnly = true;
    notifyListeners();
  }

  void openEndDrawer() {
    scaffoldKey.currentState?.openEndDrawer();
  }

  @override
  void dispose() {
    frontController.dispose();
    backController.dispose();
    super.dispose();
  }
}
