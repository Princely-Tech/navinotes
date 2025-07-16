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

  static void gotToNewNoteTemplate(Board board) {
    push(Routes.noteTemplate, arguments: board);
  }

  static void navigateToNoteCreation(BoardNoteTemplate template) {
    push(Routes.noteCreation, arguments: template);
  }

  static void navigateToBoardNotes(Board board) {
    final route = switch (board.boardType) {
      BoardTypeCodes.plain => Routes.boardPlainNotePage,
      BoardTypeCodes.minimalist => Routes.boardMinimalistNotePage,
      BoardTypeCodes.darkAcademia => Routes.boardDarkAcademiaCreateNote,
      BoardTypeCodes.lightAcademia => Routes.boardLightAcademiaNotePage,
      BoardTypeCodes.nature => Routes.boardNatureNotePage,
      _ => Routes.boardPlainNotePage,
    };

    push(route, arguments: board);
  }

  static void navigateToBoard(Board board, {Object? arguments}) {
    final boardType = board.boardType ?? BoardTypeCodes.plain;

    final route = switch (boardType) {
      BoardTypeCodes.plain => Routes.boardPlainEdit,
      BoardTypeCodes.minimalist => Routes.boardMinimalistEdit,
      BoardTypeCodes.darkAcademia => Routes.boardDarkAcademiaEdit,
      BoardTypeCodes.lightAcademia => Routes.boardLightAcademiaEdit,
      BoardTypeCodes.nature => Routes.boardNatureEdit,
    };

    // Create a new map with explicit types
    final Map<String, dynamic> mergedArguments = {
      'boardId': board.id,
      'board': board,
    };

    // NOTE:  spread operator with a Map literal creates a Map<dynamic, dynamic>

    // Safely add existing arguments if they're a map
    if (arguments is Map<String, dynamic>) {
      mergedArguments.addAll(arguments);
    } else if (arguments is Map) {
      // If it's a Map but not Map<String, dynamic>, cast the values
      mergedArguments.addAll(
        Map<String, dynamic>.fromEntries(
          arguments.entries.map((e) => MapEntry(e.key.toString(), e.value)),
        ),
      );
    }

    NavigationHelper.push(route, arguments: mergedArguments);
  }
}
