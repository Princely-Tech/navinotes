import 'package:flutter/material.dart';
import 'package:navinotes/screens/main/note_template/util.dart';
import 'package:navinotes/settings/navigation_helper.dart';
import 'package:navinotes/settings/routes.dart';

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

  void goToUploadPdf() {
    NavigationHelper.push(Routes.uploadPdf);
  }

  void goToImportNotes() {
    NavigationHelper.push(Routes.importNotes);
  }

  void createNote() {
    // NavigationHelper.push(Routes.boardNotes); //todo
  }
}

List<String> noteTemplatesSections = [
  'All',
  'Basic',
  'Study',
  'Planning',
  'Specialized',
];
