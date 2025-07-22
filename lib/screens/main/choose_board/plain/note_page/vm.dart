import 'package:navinotes/packages.dart';

class BoardPlainNotePageVm extends ChangeNotifier {
  GlobalKey<ScaffoldState> scaffoldKey;
  final Board? board;
  List<Content> contents = [];
  final DatabaseHelper dbHelper = DatabaseHelper.instance;
  TextEditingController sortByController = TextEditingController(
    text: noteSortTypeToString(AppConstants.defaultNoteSortType),
  );

  bool fetchingContent = true;
  BuildContext context;
  BoardPlainNotePageVm({
    required this.scaffoldKey,
    required this.board,
    required this.context,
  });

  @override
  void dispose() {
    sortByController.dispose();
    sortByController.removeListener(_onSortByChanged);
    super.dispose();
  }

  void _onSortByChanged() {
    getContents();
  }

  void initialize() async {
    getContents();
    sortByController.addListener(_onSortByChanged);
  }

  void getContents() async {
    try {
      fetchingContent = true;
      notifyListeners();
      contents = await dbHelper.getAllContents(
        board!.id!,
        sortType: stringToNoteSortType(sortByController.text),
      );
      notifyListeners();
    } catch (e) {
      if (context.mounted) {
        ErrorDisplayService.showErrorMessage(
          context,
          'Could not fetch content!',
        );
      }
    } finally {
      fetchingContent = false;
      notifyListeners();
    }
  }

  Future<List<Content>> getRecentContents(int count) async {
    final all = await dbHelper.getAllContents(
      board!.id!,
      sortType: NoteSortType.updatedAt,
    );
    return all.take(count).toList();
  }

  void openDrawer() {
    scaffoldKey.currentState?.openEndDrawer();
  }

  void gotToCreateNotePage() async {
    await NavigationHelper.push(Routes.noteTemplate, arguments: board);
    getContents();
  }

  void goToNotePage(Content content) async {
    if (isNull(content.id)) {
      ErrorDisplayService.showErrorMessage(context, 'Content ID not found!');
      return;
    }
    BoardNoteTemplate template = getNoteTemplateFromString(
      content.metaData[ContentMetadataKey.template],
    );
    await NavigationHelper.navigateToNoteWithTemplate(
      template: template,
      contentId: content.id!,
    );
    getContents();
  }
}
