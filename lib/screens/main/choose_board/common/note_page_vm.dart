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

  void openEndDrawer() {
    scaffoldKey.currentState?.openEndDrawer();
  }

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
      
      // Get all contents and sort them based on the selected sort type
      List<Content> allContents = await dbHelper.getAllContents(board.id);
      NoteSortType sortType = stringToNoteSortType(sortByController.text);
      
      // Sort the contents based on the selected sort type
      switch (sortType) {
        case NoteSortType.updatedAt:
          allContents.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
          break;
        case NoteSortType.createdAt:
          allContents.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          break;
      }
      
      contents = allContents;
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
    final all = await dbHelper.getAllContents(board.id);
    return all.take(count).toList();
  }

  void gotToCreateNotePage() async {
    await NavigationHelper.gotToNewNoteTemplate(board);
    getContents();
  }

  void goToNotePage(Content content) async {
    await goToNotePageWithContent(content: content, context: context);
    getContents();
  }
}
