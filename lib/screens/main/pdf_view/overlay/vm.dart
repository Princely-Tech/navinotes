import 'package:navinotes/settings/index.dart';
import 'package:navinotes/packages.dart';

class PdfViewOverlayViewModel extends ChangeNotifier {
  bool dontShowAgain = false;
  bool showOverlay = false;

  void toggleDontShowAgain() {
    dontShowAgain = !dontShowAgain;
    notifyListeners();
  }

  void initialize() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool storedBool =
        prefs.getBool(StorageStrings.dontShowPdfViewOverlay) ?? false;
    showOverlay = !storedBool;
    notifyListeners();
  }

  void addHandler() {
    closeOverlay();
  }

  void closeOverlay() async {
    showOverlay = false;
    notifyListeners();
    if (dontShowAgain) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool(StorageStrings.dontShowPdfViewOverlay, true);
    }
  }
}
