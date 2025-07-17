import 'package:navinotes/packages.dart';

class SellerSelectContentVm extends ChangeNotifier {
  GlobalKey<ScaffoldState> scaffoldKey;
  SessionManager sessionVm;
  SellerSelectContentVm({required this.scaffoldKey, required this.sessionVm}) {
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

  goToBoardNotes() {
    // NavigationHelper.push(Routes.boardNotes); //TODO
  }
}
