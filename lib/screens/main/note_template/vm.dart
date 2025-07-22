import 'package:navinotes/packages.dart';

class NoteTemplateVm extends ChangeNotifier {
  GlobalKey<ScaffoldState> scaffoldKey;
  BoardNoteTemplate selectedTemplate = noteTemplateBlank;
  final dbHelper = DatabaseHelper.instance;
  BuildContext context;
  Board? board;
  NoteTemplateVm({
    required this.scaffoldKey,
    required this.context,
    required this.board,
  });

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  double dotSize = 0;
  String selectedSection = noteTemplatesSections[0];
  void updateSelectedSection(String section) {
    selectedSection = section;
    notifyListeners();
  }

  void updateSelectedTemplate(BoardNoteTemplate template) {
    selectedTemplate = template;
    notifyListeners();
  }

  void updateDotSize(double value) {
    dotSize = value;
    notifyListeners();
  }

  void openDrawer() {
    scaffoldKey.currentState?.openEndDrawer();
  }

  // void goToUploadPdf() {
  //   NavigationHelper.push(Routes.uploadPdf);
  // }

  // void goToImportNotes() {
  //   NavigationHelper.push(Routes.importNotes);
  // }

  Future<void> createNote() async {
    createContentInDb(
      template: selectedTemplate,
      context: context,
      boardId: board!.id!,
      setLoading: _setLoading,
    );
  }
}
