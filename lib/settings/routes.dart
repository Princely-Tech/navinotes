import 'package:flutter/material.dart';
import 'package:navinotes/screens/auth/index.dart';
import 'package:navinotes/screens/aboutMe/index.dart';
import 'package:navinotes/screens/main/board_notes/index.dart';
import 'package:navinotes/screens/main/dashboard/index.dart';
import 'package:navinotes/screens/main/choose_board/index.dart';
import 'package:navinotes/screens/main/import_pdf/index.dart';
import 'package:navinotes/screens/main/note_template/index.dart';
import 'package:navinotes/screens/main/pdf/index.dart';

Map<String, WidgetBuilder> routes = {
  Routes.auth: (context) => const AuthScreen(),
  Routes.aboutMe: (context) => const AboutMeScreen(),
  Routes.dashboard: (context) => DashboardScreen(),
  Routes.chooseBoard: (context) => ChooseBoardScreen(),
  Routes.boardNotes: (context) => BoardNotesScreen(),
  Routes.noteTemplate: (context) => NoteTemplateScreen(),
  Routes.uploadPdf: (context) => UploadPdfScreen(),
  Routes.pdf: (context) => PDFAnnotationScreen(),
};

class Routes {
  Routes._();
  static const auth = 'auth';
  static const aboutMe = 'aboutMe';
  static const dashboard = 'dashboard';
  static const chooseBoard = 'choose_board';
  static const boardNotes = 'board_notes';
  static const noteTemplate = 'note_template';
  static const uploadPdf = 'upload_pdf';
  static const importNotes = 'import_notes'; //TODO build this screen
  static const pdf = 'pdf';
}
