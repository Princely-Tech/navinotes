import 'package:navinotes/packages.dart';

class BoardNotePageVm extends ChangeNotifier {
  GlobalKey<ScaffoldState> scaffoldKey;
  Board board;
  List<Content> contents = [];
  final DatabaseHelper dbHelper = DatabaseHelper.instance;
  TextEditingController sortByController = TextEditingController(
    text: noteSortTypeToString(AppConstants.defaultNoteSortType),
  );

  bool fetchingContent = true;
  BuildContext context;
  BoardNotePageVm({
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

  PageDisplayFormat pageDisplayFormat = PageDisplayFormat.list;

  void updatePageDisplayFormat(PageDisplayFormat format) {
    pageDisplayFormat = format;
    notifyListeners();
  }

  void getContents() async {
    try {
      fetchingContent = true;
      notifyListeners();
      contents = await dbHelper.getAllContents(
        board.id!,
        sortType: stringToNoteSortType(sortByController.text),
      );
      notifyListeners();
    } catch (e) {
      debugPrint('Error ${e.toString()}');
      if (context.mounted) {
        MessageDisplayService.showErrorMessage(
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
      board.id!,
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
    await goToNotePageWithContent(content: content, context: context);
    getContents();
  }
}
