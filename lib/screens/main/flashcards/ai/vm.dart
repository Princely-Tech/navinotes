import 'package:navinotes/packages.dart';

class FlashCardAiCreationVm extends ChangeNotifier {
  BuildContext context;
  GlobalKey<ScaffoldState> scaffoldKey;
  FlashCardDeck deck;
  FlashCardAiCreationVm({
    required this.scaffoldKey,
    required this.deck,
    required this.context,
  });

  List<String> cardTypes = [
    'Question & Answer',
    'Definition & Term',
    'Multiple Choice',
    'True/False',
  ];

  List<FlashCard> generatedFlashCards = [];

  void updateGeneratedFlashCards(
    List<FlashCard> cards, {
    bool replace = false,
  }) {
    if (replace) {
      generatedFlashCards = cards;
    } else {
      generatedFlashCards.addAll(cards);
    }
    notifyListeners();
  }

  List<String> selectedCardTypes = [];

  void updateSelectedCardTypes(String type) {
    if (selectedCardTypes.contains(type)) {
      selectedCardTypes.remove(type);
    } else {
      selectedCardTypes.add(type);
    }
    notifyListeners();
  }

  AIContentSource selectedAISource = AIContentSource.fromNotes;
  TextEditingController difficultyController = TextEditingController();

  List<FlashcardDifficulty> selectedDifficulties = [];

  void updateSelectedDifficulties(FlashcardDifficulty difficulty) {
    if (selectedDifficulties.contains(difficulty)) {
      selectedDifficulties.remove(difficulty);
    } else {
      selectedDifficulties.add(difficulty);
    }
    notifyListeners();
  }

  List<Board> allBoards = [];
  Board? selectedBoard;
  List<Content> allContent = [];
  List<Content> selectedContent = [];
  bool gettingAllBoards = false;
  int numberOfCards = 12;

  void updateNumberOfCards(int value) {
    numberOfCards = value;
    notifyListeners();
  }

  void selectAllContents() {
    selectedContent = [];
    for (var content in allContent) {
      selectedContent.add(content);
    }
    notifyListeners();
  }

  void deselectAllContents() {
    selectedContent = [];
    notifyListeners();
  }

  void updateSelectedContents(Content content) {
    if (selectedContent.contains(content)) {
      selectedContent.remove(content);
    } else {
      selectedContent.add(content);
    }
    notifyListeners();
  }

  void updateGettingAllBoards(bool value) {
    gettingAllBoards = value;
    notifyListeners();
  }

  void initialize() {
    getBoards();
  }

  void getBoardContents() async {
    try {
      if (selectedBoard != null) {
        allContent = await DatabaseHelper.instance.getAllContents(
          selectedBoard!.id!,
        );
        notifyListeners();
      }
    } catch (err) {
      if (context.mounted) {
        MessageDisplayService.showErrorMessage(
          context,
          'Could not fetch notes',
        );
      }
    }
  }

  void getBoards() async {
    try {
      updateGettingAllBoards(true);
      allBoards = await DatabaseHelper.instance.getAllBoards();
      updateGettingAllBoards(false);
    } catch (err) {
      if (context.mounted) {
        MessageDisplayService.showErrorMessage(
          context,
          'Could not fetch boards',
        );
      }
    }
  }

  bool loading = false;
  void updateLoading(bool value) {
    loading = value;
    notifyListeners();
  }

  Map<String, dynamic> initializeBodyValues() {
    return {
      'length': numberOfCards,
      'difficulties': selectedDifficulties.map((e) => e.toString()).toList(),
      'types': selectedCardTypes,
    };
  }

  String getContentFromNotes() {
    if (selectedContent.isEmpty) {
      MessageDisplayService.showErrorMessage(
        context,
        'Select at least one note',
      );
      return '';
    }

    final texts = <String>[];

    for (var item in selectedContent) {
      if (item.content != null && item.content!.isNotEmpty) {
        final plainText = getPlainTextFromDelta(item.content!);
        if (plainText.isNotEmpty) {
          texts.add(plainText);
        }
      }
    }
    return texts.join('. ') + (texts.isNotEmpty ? '.' : '');
  }

  void generateCardsHandler(ApiServiceProvider apiServiceProvider) async {
    try {
      updateLoading(true);
      String content = '';
      // if (selectedAISource == AIContentSource.fromNotes) {
      //   content = getContentFromNotes();
      // }
      switch (selectedAISource) {
        case AIContentSource.fromNotes:
          content = getContentFromNotes();
          break;
        default:
      }

      if (content.isNotEmpty) {
        final body = initializeBodyValues();
        body['content'] = content;

        final requestBody = FormDataRequest.post(
          ApiEndpoints.flashcardAiContent,
          body: body,
        );
        final response = await apiServiceProvider.apiService
            .sendFormDataRequest(requestBody);
        print(response['response']);

        // if (response.statusCode == 200) {
        //   final data = response.data;
        //   final cards = data['cards'] as List;
        //   updateGeneratedFlashCards(
        //     cards.map((e) => FlashCard.fromJson(e)).toList(),
        //   );
        // }
      }
    } catch (err) {
      print('Error generating cards: $err');
    }
    updateLoading(false);
  }

  void regenerateCardsHandler() {
    //
  }

  void goToCreateNote() async {
    await NavigationHelper.gotToNewNoteTemplate(selectedBoard!);
    getBoardContents();
  }

  void updateNoteBookControllerText(Board board) {
    // noteBookController.text = board.name;
    selectedContent = [];
    selectedBoard = board;
    getBoardContents();
    notifyListeners();
  }

  void updateSelectedAiSource(AIContentSource source) {
    selectedAISource = source;
    notifyListeners();
  }

  void openDrawer() {
    scaffoldKey.currentState?.openDrawer();
  }

  void openEndDrawer() {
    scaffoldKey.currentState?.openEndDrawer();
  }
}
