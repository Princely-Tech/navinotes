import 'util.dart';
import 'package:navinotes/packages.dart';

class NoteTemplateVm extends ChangeNotifier {
  GlobalKey<ScaffoldState> scaffoldKey;
  BoardTemplate selectedTemplate = noteTemplateBlank;
  NoteTemplateVm({required this.scaffoldKey});
  double dotSize = 0;
  String selectedSection = noteTemplatesSections[0];
  void updateSelectedSection(String section) {
    selectedSection = section;
    notifyListeners();
  }

  void updateSelectedTemplate(BoardTemplate template) {
    selectedTemplate = template;
    notifyListeners();
  }

  void updateDotSize(double value) {
    dotSize = value;
    notifyListeners();
  }

  void openDrawer() {
    scaffoldKey.currentState?.openEndDrawer();
  }

  // void goToUploadPdf() {
  //   NavigationHelper.push(Routes.uploadPdf);
  // }

  // void goToImportNotes() {
  //   NavigationHelper.push(Routes.importNotes);
  // }

  void createNote() {
    if (isNotNull(selectedTemplate.route)) {
      NavigationHelper.push(selectedTemplate.route!);
    }
  }
}
