import 'package:navinotes/settings/index.dart';
import 'package:navinotes/packages.dart';

class PdfViewOverlayViewModel extends ChangeNotifier {
  bool dontShowAgain = false;

  void startLearning(Function() closeOverlay) async {
    closeOverlay();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (dontShowAgain) {
      prefs.setBool(StorageStrings.pdfViewOverlaySeen, true);
    }
  }
}
