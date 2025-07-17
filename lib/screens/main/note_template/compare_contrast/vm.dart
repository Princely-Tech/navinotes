import 'package:navinotes/packages.dart';

class NoteCompareContrastVm extends ChangeNotifier {
  GlobalKey<ScaffoldState> scaffoldKey;
  NoteCompareContrastVm({required this.scaffoldKey});

  QuillController richEditorController1 = QuillController.basic();
  QuillController richEditorController2 = QuillController.basic();

  void initialize() {
    richEditorController1.readOnly = false;
    richEditorController2.readOnly = false;
    notifyListeners();
  }

  @override
  void dispose() {
    richEditorController1.dispose();
    richEditorController2.dispose();
    super.dispose();
  }

  void openDrawer() {
    scaffoldKey.currentState?.openDrawer();
  }
}
