import 'package:navinotes/packages.dart';
import 'package:navinotes/settings/note_utils.dart';
import 'package:path/path.dart' as path;
import 'dart:math';

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

  static void navigateToNoteCreation(
    BoardNoteTemplate template,
    String contentId, {
    bool replace = false,
  }) {
    if (replace) {
      pushReplacement(
        Routes.noteCreation,
        arguments: NoteCreationProp(template: template, contentId: contentId),
      );
      return;
    }
    push(
      Routes.noteCreation,
      arguments: NoteCreationProp(template: template, contentId: contentId),
    );
  }

  static void navigateToFlashCardStudy(Content deck) {
    push(Routes.flashcardStudy, arguments: deck);
  }

  static void navigateToNoteTemplateRoute(String route, String contentId) {
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
    bool replace = false,
    bool isNew = false,
  }) {
    return navigateToBoardPopup(board, replace: replace);
  }

  static navigateToManualFlashCard(
    ManualFlashCardProps props, {
    bool replace = false,
  }) {
    if (replace) {
      return NavigationHelper.pushReplacement(
        Routes.flashCardsManualCreation,
        arguments: props,
      );
    }
    return NavigationHelper.push(
      Routes.flashCardsManualCreation,
      arguments: props,
    );
  }

  static navigateToAiFlashCard(Content deck, {bool replace = false}) {
    if (replace) {
      return NavigationHelper.pushReplacement(
        Routes.flashCardAiCreation,
        arguments: deck,
      );
    }
    return push(Routes.flashCardAiCreation, arguments: deck);
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

  static Future navigateToPdfView(String contentId) {
    return push(Routes.viewPdf, arguments: contentId);
  }

  static void navigateToNotification() {
    push(Routes.notifications);
  }

  static void navigateToProfile() {
    push(Routes.profile);
  }

  static navigateToContent(Content content, {bool replace = false}) async {
    debugPrint('Navigating to content ${content.id} - ${content.title}');

    if (content.type == AppContentType.note) {
      final boardId = content.boardId;
      final board = await DatabaseHelper.instance.getBoard(boardId);
      final route = NoteUtils.getNoteCreationRoute(board.type);
      push(route, arguments: {'content': content});
    } else if (content.type == AppContentType.notebook) {
      final notebook = await DatabaseHelper.instance.getNotebook(content.id);
      if (notebook != null) {
        final pages = await DatabaseHelper.instance.getPagesForNotebook(notebook.id);
        final notebookWithPages = notebook.copyWith(pages: pages);
        push(Routes.notebook, arguments: {'notebook': notebookWithPages});
      } else {
        debugPrint('Error: Notebook with id ${content.id} not found.');
      }
    } else if (content.type == AppContentType.mindmap) {
      push(Routes.mindMap, arguments: {'contentId': content.id});
    } else if (content.type == AppContentType.file) {
      handleFileNavigation(content);
    } else if (content.type == AppContentType.flashcardDeck) {
      navigateToDeck(content);
    }
  }

  static handleFileNavigation(Content content) async {
    try {
      final filePath = content.file;
      if (filePath == null || filePath.isEmpty) {
        return;
      }

      final fileEntity = File(filePath);
      if (!fileEntity.existsSync()) {
        debugPrint('File does not exist $filePath');
        return;
      }

      final ext = path.extension(filePath).toLowerCase();

      if (ext == '.pdf') {
        navigateToPdfView(content.id);
        return;
      }

      final result = await openFile(fileEntity);
      if (!result) {
        throw Exception('Failed to open file');
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  static navigateToContentById(String contentId, {bool replace = false}) async {
    final content = await DatabaseHelper.instance.getContentById(contentId);
    return navigateToContent(content!, replace: replace);
  }

  static navigateToDeck(Content deck) {
    debugPrint('Navigating to deck ${deck.id} - ${deck.title}');
    navigateToManualFlashCard(ManualFlashCardProps(deck: deck));
  }

  static navigateToDeckById(String deckId) async {
    final deck = await DatabaseHelper.instance.getDeck(int.parse(deckId));
    return navigateToDeck(deck!);
  }

  static createAndNavigateToNewMindMap(Board board) async {
    final id = await _createNewContent(
      AppContentType.mindmap,
      board,
      'New Mind Map',
    );
    return navigateToContentById(id);
  }

  static createAndNavigateToNewFlashCard(Board board) async {
    final random = Random();
    final adjectives = ['New', 'Fresh', 'Smart', 'Quick', 'Study', 'Master'];
    final nouns = ['Deck', 'Set', 'Collection', 'Pack', 'Bundle'];
    final adjective = adjectives[random.nextInt(adjectives.length)];
    final noun = nouns[random.nextInt(nouns.length)];

    final title = '$adjective $noun ${DateTime.now().millisecondsSinceEpoch % 100}';
    final id = await _createNewContent(
      AppContentType.flashcardDeck,
      board,
      title,
    );
    return navigateToDeckById(id);
  }

  static createAndNavigateToNewNotebook(Board board) async {
    final id = await _createNewContent(
      AppContentType.notebook,
      board,
      'New Notebook',
    );
    return navigateToContentById(id);
  }

  static Future<String> _createNewContent(
    AppContentType type,
    Board board,
    String title,
  ) async {
    final content = Content(
      title: title,
      type: type,
      boardId: board.id,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      updatedAt: DateTime.now().millisecondsSinceEpoch,
      metaData: {},
      tags: null,
      content: null,
      drawing: null,
      file: null,
    );
    await DatabaseHelper.instance.insertContent(content);
    return content.id;
  }
}