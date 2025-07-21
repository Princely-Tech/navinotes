import 'package:navinotes/packages.dart';

class BoardPlainNotePageVm extends ChangeNotifier {
  GlobalKey<ScaffoldState> scaffoldKey;
  final Board? board;
  List<Content> contents = [];
  final DatabaseHelper dbHelper = DatabaseHelper.instance;
  bool fetchingContent = true;
  BuildContext context;
  BoardPlainNotePageVm({
    required this.scaffoldKey,
    required this.board,
    required this.context,
  });

  void initialize() async {
    getContents();
  }

  void getContents() async {
    try {
      fetchingContent = true;
      notifyListeners();
      contents = await dbHelper.getAllContents(board!.id!);
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

  void openDrawer() {
    scaffoldKey.currentState?.openEndDrawer();
  }

  gotToCreateNotePage(Board board) {
    NavigationHelper.push(Routes.noteTemplate, arguments: board);
  }
}
