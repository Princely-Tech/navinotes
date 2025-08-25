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

  void updateGeneratedFlashCards(List<FlashCard> cards,{
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

  // Board selectedBoard =

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
