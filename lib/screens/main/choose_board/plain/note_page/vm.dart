import 'package:navinotes/packages.dart';

class BoardPlainNotePageVm extends ChangeNotifier {
  GlobalKey<ScaffoldState> scaffoldKey;
  final Board? board;

  BoardPlainNotePageVm({required this.scaffoldKey, required this.board});
  void openDrawer() {
    scaffoldKey.currentState?.openEndDrawer();
  }

  gotToCreateNotePage(Board board) {
    NavigationHelper.push(Routes.noteTemplate, arguments: board);
  }
}
