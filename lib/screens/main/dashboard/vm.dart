import 'package:navinotes/packages.dart';

class DashboardVm extends ChangeNotifier {
  GlobalKey<ScaffoldState> scaffoldKey;
  SessionManager sessionVm;
  DashboardVm({required this.scaffoldKey, required this.sessionVm}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initialize(scaffoldKey.currentContext!);
    });
  }

  void initialize(BuildContext context) async {
    try {
      await sessionVm.getAllBoard();
    } catch (err) {
      if (context.mounted) {
        ErrorDisplayService.showErrorMessage(
          context,
          'Error occurred while fetching boards',
        );
      }
      debugPrint(err.toString());
    }
  }

  void openDrawer() {
    scaffoldKey.currentState?.openDrawer();
  }

  goToCreateBoard() async {
    await NavigationHelper.push(Routes.chooseBoard);
    sessionVm.getAllBoard();
  }

  goToBoardNotes(Board board) async {
    await NavigationHelper.navigateToBoard(board);
    sessionVm.getAllBoard();
  }
}
