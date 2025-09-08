import 'package:navinotes/packages.dart';
import 'package:path/path.dart' as path;

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

  static void navigateToFlashCardStudy(FlashCardDeck deck) {
    push(Routes.flashcardStudy, arguments: deck);
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

  static navigateToAiFlashCard(FlashCardDeck deck, {bool replace = false}) {
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

  static Future navigateToPdfView(int contentId) {
    return push(Routes.viewPdf, arguments: contentId);
  }

  static void navigateToNotification() {}
  static void navigateToProfile() {
    // push(Routes.profile);
  }

  static navigateToContent(Content content) async {
    debugPrint('Navigating to content ${content.id} - ${content.title}');

    //Handle file
    if (content.type == AppContentType.file) {
      return _handleFileNavigation(content);
    }

    if (content.type == AppContentType.mindmap) {
     push(
                      Routes.mindMap,
                      arguments: {'contentId': content.id},
                    );
    }

    // TODO: Implement
  }

  static _handleFileNavigation(Content content) async {
    try {
      final filePath = content.file;
      if (filePath == null || filePath.isEmpty) {
        return;
      }

      final fileEntity = File(filePath);
      if (!fileEntity.existsSync()) {
        return;
      }

      final ext = path.extension(filePath).toLowerCase();

      // Handle PDF files with custom viewer
      if (ext == '.pdf') {
        navigateToPdfView(content.id!);
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

  static navigateToContentById(int contentId) async {
    final content = await DatabaseHelper.instance.getContentById(contentId);
    return navigateToContent(content!);
  }

  static navigateToDeck(FlashCardDeck deck) {
    debugPrint('Navigating to deck ${deck.id} - ${deck.name}');
    navigateToManualFlashCard(ManualFlashCardProps(deck: deck));
  }

  static navigateToDeckById(int deckId) async {
    final deck = await DatabaseHelper.instance.getDeck(deckId);
    return navigateToDeck(deck!);
  }


  static createAndNavigateToNewMindMap(Board board) {
    
  }

  static createAndNavigateToNewFlashCard(Board board) async {
    final dbHelper = DatabaseHelper.instance;

    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final random = Random();
    final adjectives = ['New', 'Fresh', 'Smart', 'Quick', 'Study', 'Master'];
    final nouns = ['Deck', 'Set', 'Collection', 'Pack', 'Bundle'];
    final adjective = adjectives[random.nextInt(adjectives.length)];
    final noun = nouns[random.nextInt(nouns.length)];

    final newDeck = FlashCardDeck(
      guid: 'deck_${DateTime.now().millisecondsSinceEpoch}',
      boardId: board.id!,
      name: '$adjective $noun ${now % 100}',
      description: 'Created on ${DateTime.now().toString().split(' ')[0]}',
      cardsPerDay: 20,
      steps: [1, 10],
      againInterval: 1,
      hardInterval: 3,
      goodInterval: 5,
      easyInterval: 7,
      createdAt: now,
      updatedAt: now,
    );

    final id = await dbHelper.insertDeck(newDeck);
    newDeck.id = id;
    navigateToDeck(newDeck);
  }
}
