import 'package:navinotes/packages.dart';
import 'package:navinotes/settings/navi_backup.dart';

class DashboardVm extends ChangeNotifier {
  GlobalKey<ScaffoldState> scaffoldKey;
  SessionManager sessionVm;
  bool importingBoard = false;
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
        MessageDisplayService.showErrorMessage(
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

  goToBoard(Board board) async {
    await NavigationHelper.navigateToBoard(board);
    sessionVm.getAllBoard();
  }

  Future<void> importBoard(BuildContext context) async {
    try {
      importingBoard = true;
      notifyListeners();

      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['navi'],
      );

      if (result == null || result.files.isEmpty) {
        return;
      }

      final picked = result.files.first;
      if (picked.path == null) {
        return;
      }

      final file = File(picked.path!);

      await NaviBackupService.importBoard(
        file: file,
        context: context,
        sessionVm: sessionVm,
      );
    } catch (e) {
      debugPrint('Error picking .navi file: $e');
      if (context.mounted) {
        MessageDisplayService.showErrorMessage(
          context,
          'Error importing board',
        );
      }
    } finally {
      importingBoard = false;
      notifyListeners();
    }
  }
}
