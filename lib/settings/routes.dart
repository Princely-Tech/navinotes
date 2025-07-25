import 'package:navinotes/packages.dart';
import 'package:navinotes/screens/main/choose_board/light_academia/edit/index.dart';
import 'package:navinotes/screens/main/choose_board/light_academia/index.dart';
import 'package:navinotes/screens/main/choose_board/light_academia/note_page/index.dart';
import 'package:navinotes/screens/main/choose_board/minimalist/edit/index.dart';
import 'package:navinotes/screens/main/choose_board/minimalist/index.dart';
import 'package:navinotes/screens/main/choose_board/minimalist/mind_map/index.dart';
import 'package:navinotes/screens/main/choose_board/minimalist/note_page/index.dart';
import 'package:navinotes/screens/main/choose_board/plain/edit/index.dart';
import 'package:navinotes/screens/main/choose_board/plain/index.dart';
import 'package:navinotes/screens/main/choose_board/plain/mind_map/index.dart';
import 'package:navinotes/screens/main/flashcards/index.dart';
import 'package:navinotes/screens/main/market_place/index.dart';
import 'package:navinotes/screens/main/market_place/my_purchases/index.dart';
import 'package:navinotes/screens/main/market_place/my_store/index.dart';
import 'package:navinotes/screens/main/market_place/product_detail/index.dart';
import 'package:navinotes/screens/main/market_place/seller_upload/board/index.dart';
import 'package:navinotes/screens/main/market_place/seller_upload/details/index.dart';
import 'package:navinotes/screens/main/note_template/compare_contrast/index.dart';
import 'package:navinotes/screens/main/note_template/creation/index.dart';
import 'package:navinotes/screens/main/note_template/kanban/index.dart';
import 'package:navinotes/screens/main/note_template/lab_report/index.dart';
import 'package:navinotes/screens/main/note_template/timeline/index.dart';
import 'package:navinotes/screens/splash/splash_screen.dart'; //TODO

Map<String, WidgetBuilder> routes = {
  Routes.splash: (context) => const SplashScreen(),
  Routes.auth: (context) => const AuthScreen(),
  Routes.forgotPassword: (context) => ForgotPasswordScreen(),
  Routes.resetPasswordVerify: (context) => ResetPasswordVerifyScreen(),
  Routes.changePassword: (context) => ChangePasswordScreen(),
  Routes.aboutMe: (context) => const AboutMeScreen(),
  Routes.dashboard: (context) => DashboardScreen(),
  Routes.chooseBoard: (context) => ChooseBoardScreen(),
  Routes.boardPlainNotePage: (context) => BoardPlainNotePageScreen(),
  Routes.noteTemplate: (context) => NoteTemplateScreen(),
  Routes.uploadPdf: (context) => UploadPdfScreen(),
  Routes.viewPdf: (context) => PdfViewScreen(),
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
  Routes.boardNatureMindMap: (context) => BoardNatureMindMapScreen(),
  Routes.marketplace: (context) => MarketPlaceScreen(),
  Routes.productDetail: (context) => ProductDetailScreen(),
  Routes.myStore: (context) => MyStoreScreen(),
  Routes.boardMinimalist: (context) => MinimalistScreen(),
  Routes.boardMinimalistEdit: (context) => BoardMinimalistEditScreen(),
  Routes.boardMinimalistNotePage: (context) => BoardMinimalistNotePageScreen(),
  Routes.boardMinimalistMindMap: (context) => BoardMinimalistMindMapScreen(),
  Routes.boardPlain: (context) => BoardPlainScreen(),
  Routes.boardPlainEdit: (context) => BoardPlainEditScreen(),
  Routes.boardPlainMindMap: (context) => BoardPlainMindMapScreen(),
  Routes.boardLightAcademia: (context) => BoardLightAcademiaScreen(),
  Routes.boardLightAcademiaEdit: (context) => BoardLightAcadEditScreen(),
  Routes.boardLightAcademiaNotePage:
      (context) => BoardLightAcadNotePageScreen(),
  Routes.sellerSelectContent: (context) => SellerSelectContentScreen(),
  Routes.sellerUpload: (context) => SellerUploadScreen(),
  Routes.myPurchases: (context) => MyPurchasesScreen(),
  Routes.flashCards: (context) => FlashCardsScreen(),
  Routes.noteCreation: (context) => NoteCreationScreen(),
  Routes.noteCompareContrast: (context) => NoteCompareContrastScreen(),
  Routes.noteTimeline: (context) => NoteTimelineScreen(),
  Routes.noteKanban: (context) => NoteKanbanScreen(),
  Routes.noteLabReport: (context) => NoteLabReportScreen(),
};

class Routes {
  Routes._();
  static const splash = 'splash';
  static const auth = 'auth';
  static const String forgotPassword = 'forgot_password';
  static const String resetPasswordVerify = 'reset_password_verify';
  static const String changePassword = 'change_password';
  static const verify = 'verify';
  static const aboutMe = 'aboutMe';
  static const dashboard = 'dashboard';
  static const chooseBoard = 'choose_board';
  static const noteTemplate = 'note_template';
  static const uploadPdf = 'upload_pdf';
  static const importNotes = 'import_notes'; //TODO build this screen
  static const viewPdf = 'viewPdf';
  static const recentNotes = 'recent_notes';
  static const boardDarkAcademia = 'board_dark_academia';
  static const boardDarkAcademiaEdit = 'board_dark_academia_edit';
  static const boardDarkAcademiaCreateNote = 'board_dark_academia_create_note';
  static const boardDarkAcademiaMindMap = 'board_dark_academia_mind_map';
  static const boardNature = 'board_nature';
  static const boardNatureEdit = 'board_nature_edit';
  static const boardNatureNotePage = 'board_nature_note_page';
  static const boardNatureMindMap = 'board_nature_mind_map';
  static const marketplace = 'marketplace';
  static const productDetail = 'productDetail';
  static const myPurchases = 'myPurchases';
  static const myStore = 'myStore';
  static const boardMinimalist = 'boardMinimalist';
  static const boardMinimalistEdit = 'boardMinimalistEdit';
  static const boardMinimalistNotePage = 'boardMinimalistNotePage';
  static const boardMinimalistMindMap = 'boardMinimalistMindMap';
  static const boardPlain = 'boardPlain';
  static const boardPlainEdit = 'boardPlainEdit';
  static const boardPlainNotePage = 'boardPlainNotePage';
  static const boardPlainMindMap = 'boardPlainMindMap';
  static const boardLightAcademia = 'boardLightAcademia';
  static const boardLightAcademiaEdit = 'boardLightAcademiaEdit';
  static const boardLightAcademiaNotePage = 'boardLightAcademiaNotePage';
  static const boardLightAcademiaMindMap =
      'boardLightAcademiaMindMap'; //TODO create screen

  static const sellerUpload = 'sellerUpload';
  static const sellerSelectContent = 'sellerSelectContent';
  static const flashCards = 'flashCards';
  static const noteCreation = 'noteCreation';
  static const noteCompareContrast = 'noteCompareContrast';
  static const noteTimeline = 'noteTimeline';
  static const noteKanban = 'noteKanban';
  static const noteLabReport = 'noteLabReport';
  static const pomodoroTimer = 'pomodoroTimer'; //TODO create screen
  static const boardPlainPopup = 'boardPlainPopup';
  static const boardMinimalistPopup = 'boardMinimalistPopup';
  static const boardDarkAcademiaPopup = 'boardDarkAcademiaPopup';
  static const boardLightAcademiaPopup = 'boardLightAcademiaPopup';
  static const boardNaturePopup = 'boardNaturePopup';
  // static const boardNaturePopup = 'boardNaturePopup';
  // static const boardNaturePopup = 'boardNaturePopup';
  // static const boardNaturePopup = 'boardNaturePopup';
}
//Documentation
//https://documenter.getpostman.com/view/45960961/2sB2x8GXet