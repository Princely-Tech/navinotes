import 'package:navinotes/packages.dart';

class NoteCreationVm extends ChangeNotifier {
  GlobalKey<ScaffoldState> scaffoldKey;
  BoardNoteTemplate template;
  NoteCreationVm({required this.scaffoldKey, BoardNoteTemplate? template})
    : template = template ?? noteTemplateLined; //TODO  Use blank as default

  bool showAiSection = false;

  void openAiSection() {
    showAiSection = true;
    notifyListeners();
  }

  void closeAiSection() {
    showAiSection = false;
    notifyListeners();
  }

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
