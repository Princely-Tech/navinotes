import 'package:navinotes/packages.dart';

class NoteCreationVm extends ChangeNotifier {
  GlobalKey<ScaffoldState> scaffoldKey;
  BoardNoteTemplate template;
  NoteCreationProp? creationProp;
  final dbHelper = DatabaseHelper.instance;
  final BuildContext context;
  NoteCreationVm({
    required this.scaffoldKey,
    required this.creationProp,
    required this.context,
  }) : template = creationProp?.template ?? noteTemplateBlank;

  Content? content;
  bool fetchingContent = true;

  bool isCreatingNote = false;

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
    richEditorController.readOnly = true; //TODO make false
    getContent();
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

  Future<List<Content>> getAllContent() async {
    final List<Content> contents = [];
    final boards = await dbHelper.getAllBoards();
    for (var board in boards) {
      contents.addAll(await dbHelper.getAllContents(board.id!));
    }
    return contents;
  }

  void updateLoading(bool loading) {
    fetchingContent = loading;
    notifyListeners();
  }

  void getContent() async {
    try {
      updateLoading(true);
      Content? response = await dbHelper.getContentById(
        creationProp!.contentId,
      );
      if (isNotNull(response)) {
        content = response;
        print(content?.boardId);
        notifyListeners();
      }
    } catch (e) {
      if (context.mounted) {
        ErrorDisplayService.showErrorMessage(
          context,
          'Could not fetch content!',
        );
      }
    } finally {
      updateLoading(false);
    }
  }

  void _setCreateNoteLoading(bool loading) {
    isCreatingNote = loading;
    notifyListeners();
  }

  Future<void> createNote() async {
    if (isNull(content)) {
      ErrorDisplayService.showErrorMessage(context, 'Content is null');
      return;
    }
    await createContentInDb(
      template: template,
      context: context,
      boardId: content!.boardId,
      setLoading: _setCreateNoteLoading,
    );
    getContent();
  }
}
