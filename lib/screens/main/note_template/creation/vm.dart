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
  final FocusNode titleFocusNode = FocusNode();
  TextEditingController titleController = TextEditingController();

  void initialize() {
    richEditorController.readOnly = false; //TODO make false
    getContent();
    notifyListeners();

    titleFocusNode.addListener(() {
      if (!titleFocusNode.hasFocus) {
        updateContentInDb();
      }
    });
  }

  void updateContentInDb() {
    try {
      if (isNotNull(content)) {
        final newContent = content!.getUpdatedContent(
          title: titleController.text,
        );
        dbHelper.updateContent(newContent);
      }
    } catch (err) {
      ErrorDisplayService.showErrorMessage(
        context,
        'Could not update content!',
      );
    }
  }

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

  void updateFetchingContent(bool loading) {
    fetchingContent = loading;
    notifyListeners();
  }

  void getContent() async {
    try {
      updateFetchingContent(true);
      Content? response = await dbHelper.getContentById(
        creationProp!.contentId,
      );
      if (isNotNull(response)) {
        content = response;
        titleController.text = content!.title;
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
      updateFetchingContent(false);
    }
  }

  void _setCreateNoteLoading(bool loading) {
    isCreatingNote = loading;
    notifyListeners();
  }

  void getAllBoards() {}

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

  Future<void> goToRoute(String route) async {
    await NavigationHelper.push(route);
    getContent();
  }
}
