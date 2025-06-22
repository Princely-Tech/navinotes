import 'package:navinotes/packages.dart';

Map<String, WidgetBuilder> routes = {
  Routes.auth: (context) => const AuthScreen(),
  Routes.forgotPassword: (context) => ForgotPasswordScreen(),
  Routes.resetPasswordVerify: (context) => ResetPasswordVerifyScreen(),
  Routes.changePassword: (context) => ChangePasswordScreen(),
  Routes.aboutMe: (context) => const AboutMeScreen(),
  Routes.dashboard: (context) => DashboardScreen(),
  Routes.chooseBoard: (context) => ChooseBoardScreen(),
  Routes.boardNotes: (context) => BoardNotesScreen(),
  Routes.noteTemplate: (context) => NoteTemplateScreen(),
  Routes.uploadPdf: (context) => UploadPdfScreen(),
  Routes.pdf: (context) => PdfViewScreen(),
  Routes.recentNotes: (context) => RecentNotesScreen(),
  Routes.boardDarkAcademia: (context) => DarkAcademiaScreen(),
  Routes.boardDarkAcademiaEdit: (context) => DarkAcademiaEditScreen(),
  Routes.boardDarkAcademiaCreateNote:
      (context) => DarkAcademiaCreateNoteScreen(),
  Routes.boardDarkAcademiaMindMap: (context) => DarkAcademiaMindMapScreen(),
  Routes.boardNature: (context) => BoardNatureScreen(),
  Routes.boardNatureEdit: (context) => BoardNatureEditScreen(),
  Routes.boardNatureNotePage: (context) => NatureNotePageScreen(),
  Routes.verify: (context) => VerifyScreen(),
};

class Routes {
  Routes._();
  static const auth = 'auth';
  static const String forgotPassword = 'forgot_password';
  static const String resetPasswordVerify = 'reset_password_verify';
  static const String changePassword = 'change_password';
  static const verify = 'verify';
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
  static const boardDarkAcademiaEdit = 'board_dark_academia_edit';
  static const boardDarkAcademiaCreateNote = 'board_dark_academia_create_note';
  static const boardDarkAcademiaMindMap = 'board_dark_academia_mind_map';
  static const boardNature = 'board_nature';
  static const boardNatureEdit = 'board_nature_edit';
  static const boardNatureNotePage = 'board_nature_note_page';
}
//Documentation
//https://documenter.getpostman.com/view/45960961/2sB2x8GXet