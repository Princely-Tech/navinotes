import 'package:navinotes/packages.dart';

class NavigationHelper {
  NavigationHelper._();
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  /// Push a new screen onto the stack
  static Future<T?> push<T>(String routeName, {Object? arguments}) {
    return navigatorKey.currentState!.pushNamed(
      routeName,
      arguments: arguments,
    );
  }

  /// Replace the current screen with a new one
  static Future<T?> pushReplacement<T, TO>(
    String routeName, {
    Object? arguments,
  }) {
    return navigatorKey.currentState!.pushReplacementNamed(
      routeName,
      arguments: arguments,
    );
  }

  /// Push a new screen and remove all previous screens until the condition is met
  static Future<T?> pushAndRemoveUntil<T>(
    String routeName, {
    Object? arguments,
  }) {
    return navigatorKey.currentState!.pushNamedAndRemoveUntil(
      routeName,
      (route) => false,
      arguments: arguments,
    );
  }

  /// Pop the current screen
  static void pop<T extends Object>([T? result]) {
    if (navigatorKey.currentState!.canPop()) {
      navigatorKey.currentState!.pop(result);
    }
  }

  static void gotToNoteTemplate() {
    //push(Routes.noteTemplate, arguments: board);
  }

  static void navigateToSettings() {
    // push(Routes.noteTemplate, arguments: board);
  }

  static void navigateToTutorial() {
    // push(Routes.noteTemplate, arguments: board);
  }
  static Future<void> gotToNewNoteTemplate(Board board) {
    return push(Routes.noteTemplate, arguments: board);
  }

  //Note creation
  static navigateToNoteWithTemplate({
    required BoardNoteTemplate template,
    required int contentId,
  }) async {
    if (isNotNull(template.route)) {
      return navigateToNoteTemplateRoute(template.route!, contentId);
    } else {
      return navigateToNoteCreation(template, contentId);
    }
  }

  static void navigateToNoteCreation(
    BoardNoteTemplate template,
    int contentId,
  ) {
    push(
      Routes.noteCreation,
      arguments: NoteCreationProp(template: template, contentId: contentId),
    );
  }

  static void navigateToNoteTemplateRoute(String route, int contentId) {
    push(route, arguments: contentId);
  }

  static Future navigateToBoardNotes(Board board) {
    final route = switch (board.boardType) {
      BoardTypeCodes.plain => Routes.boardPlainNotePage,
      BoardTypeCodes.minimalist => Routes.boardMinimalistNotePage,
      BoardTypeCodes.darkAcademia => Routes.boardDarkAcademiaCreateNote,
      BoardTypeCodes.lightAcademia => Routes.boardLightAcademiaNotePage,
      BoardTypeCodes.nature => Routes.boardNatureNotePage,
      _ => Routes.boardPlainNotePage,
    };

    return push(route, arguments: board);
  }

  static void logOut() {
    pushAndRemoveUntil(Routes.auth);
  }

  static Future navigateToBoard(
    Board board, {
    // Object? arguments,
    bool replace = false,
    bool isNew = false,
  }) {
    if (!isNew) {
      return navigateToBoardPopup(board, replace: replace);
    }
    final boardType = board.boardType ?? BoardTypeCodes.plain;

    final route = switch (boardType) {
      BoardTypeCodes.plain => Routes.boardPlainEdit,
      BoardTypeCodes.minimalist => Routes.boardMinimalistEdit,
      BoardTypeCodes.darkAcademia => Routes.boardDarkAcademiaEdit,
      BoardTypeCodes.lightAcademia => Routes.boardLightAcademiaEdit,
      BoardTypeCodes.nature => Routes.boardNatureEdit,
    };
    if (replace) {
      return NavigationHelper.pushReplacement(route, arguments: board);
    }
    return NavigationHelper.push(route, arguments: board);
  }

  static Future navigateToBoardPopup(Board board, {bool replace = false}) {
    final boardType = board.boardType ?? BoardTypeCodes.plain;

    final route = switch (boardType) {
      BoardTypeCodes.plain => Routes.boardPlainPopup,
      BoardTypeCodes.minimalist => Routes.boardMinimalistPopup,
      BoardTypeCodes.darkAcademia => Routes.boardDarkAcademiaPopup,
      BoardTypeCodes.lightAcademia => Routes.boardLightAcademiaPopup,
      BoardTypeCodes.nature => Routes.boardNaturePopup,
    };

    if (replace) {
      return NavigationHelper.pushReplacement(route, arguments: board);
    }

    return NavigationHelper.push(route, arguments: board);
  }

  static Future navigateToPdfView(int contentId) {
    return push(Routes.viewPdf, arguments: contentId);
  }

  static void navigateToNotification() {}
  static void navigateToProfile() {
    // push(Routes.profile);
  }
}
