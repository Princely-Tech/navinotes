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
        ErrorDisplayService.showMessage(
          context,
          'Error occurred while fetching boards',
          isError: true,
        );
      }
      debugPrint(err.toString());
    }
  }

  void openDrawer() {
    scaffoldKey.currentState?.openDrawer();
  }

  goToCreateBoard() {
    NavigationHelper.push(Routes.chooseBoard);
  }

  goToBoardNotes() {
    NavigationHelper.push(Routes.boardNotes);
  }
}
