import 'package:navinotes/packages.dart';

class BlankNoteVm extends ChangeNotifier {
  GlobalKey<ScaffoldState> scaffoldKey;
  BlankNoteVm({required this.scaffoldKey});

  QuillController richEditorController = QuillController.basic();

  void initialize() {
    richEditorController.readOnly = false;
    notifyListeners();
  }

  @override
  void dispose() {
    richEditorController.dispose();
    super.dispose();
  }

  void openDrawer() {
    scaffoldKey.currentState?.openDrawer();
  }

  void openEndDrawer() {
    scaffoldKey.currentState?.openEndDrawer();
  }
}
