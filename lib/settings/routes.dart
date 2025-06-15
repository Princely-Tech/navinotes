import 'package:navinotes/packages.dart';

Map<String, WidgetBuilder> routes = {
  Routes.auth: (context) => const AuthScreen(),
  Routes.aboutMe: (context) => const AboutMeScreen(),
  Routes.dashboard: (context) => DashboardScreen(),
  Routes.chooseBoard: (context) => ChooseBoardScreen(),
  Routes.boardNotes: (context) => BoardNotesScreen(),
  Routes.noteTemplate: (context) => NoteTemplateScreen(),
  Routes.uploadPdf: (context) => UploadPdfScreen(),
  Routes.pdf: (context) => PdfViewScreen(),
  Routes.recentNotes: (context) => RecentNotesScreen(),
  Routes.boardDarkAcademia: (context) => DarkAcademiaScreen(),
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
  static const recentNotes = 'recent_notes';
  static const boardDarkAcademia = 'board_dark_academia';
}
