import 'package:navinotes/packages.dart';

class FlashCardStudyVm extends ChangeNotifier {
  GlobalKey<ScaffoldState> scaffoldKey;
  BuildContext context;
  Content deck;
  FlashCardStudyVm({
    required this.scaffoldKey,
    required this.context,
    required this.deck,
  }) : lastStudied = deck.getMeta('last_studied') ?? generateUnixTimestamp();

  int lastStudied;
  Timer? lastStudiedTimer;

  // int elapsedSeconds = 0;
  ValueNotifier<int> elapsedSeconds = ValueNotifier<int>(0);
  int cardResponseSeconds = 0;
  Timer? sessionTimer;
  Timer? cardResponseTimer;

  List<int> cardResponseSecondsList = [];

  void resetCardResponseTimer() {
    if (cardResponseSeconds != 0) {
      cardResponseSecondsList.add(cardResponseSeconds);
      notifyListeners();
    }
    cardResponseSeconds = 0;
    cardResponseTimer?.cancel();
    cardResponseTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      cardResponseSeconds++;
      notifyListeners();
    });
    notifyListeners();
  }

  void startSessionTimer() {
    sessionTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      int updatedTime = elapsedSeconds.value += 1;
      elapsedSeconds.value = updatedTime;
    });
  }

  QuillController frontController = QuillController.basic();
  QuillController backController = QuillController.basic();

  final flipCardController = FlipCardController();
  int currentCardIndex = 0;
  List<FlashCard> reviewedCards = [];
  List<FlashCard> flashCards = [];
  FlashCard? currentCard;

  nextCardIndex() {
    if (flashCards.isEmpty) return 0;
    currentCardIndex = (currentCardIndex + 1) % flashCards.length;
    FlashCard current = flashCards[currentCardIndex];
    
    // Reset card to front side when moving to next card
    _resetCardToFront();
    
    selectFlashCard(current);
  }

  previousCardIndex() {
    if (flashCards.isEmpty) return 0;
    currentCardIndex = (currentCardIndex - 1 + flashCards.length) % flashCards.length;
    FlashCard current = flashCards[currentCardIndex];
    
    // Reset card to front side when moving to previous card
    _resetCardToFront();
    
    selectFlashCard(current);
  }

  // Helper method to ensure card shows front side
  void _resetCardToFront() {
    // Use a small delay to ensure the flip card state is properly initialized
    Future.delayed(const Duration(milliseconds: 100), () {
      // Check if the card is currently showing the back side and flip it to front
      if (flipCardController.state?.isFront == false) {
        flipCardController.flipcard();
      }
    });
  }

  bool loading = true;

  void updateCurrentCardDifficulty(FlashcardDifficulty difficulty) async {
    if (currentCard != null) {
      currentCard!.update(difficulty: difficulty);
      loadDeckFlashCards();
      nextCardIndex();
    }
  }

  void selectFlashCard(FlashCard card) {
    try {
      currentCard = card;
      frontController = QuillController(
        document: safeDocFromJson(card.front),
        selection: const TextSelection.collapsed(offset: 0),
      );

      backController = QuillController(
        document: safeDocFromJson(card.back),
        selection: const TextSelection.collapsed(offset: 0),
      );
      updateReviewedCard(card);
      resetCardResponseTimer();
      
      // Ensure card starts with front side when selecting a new card
      _resetCardToFront();
    } catch (err) {
      debugPrint('Error loading flashcard: $err');
      if (context.mounted) {
        MessageDisplayService.showErrorMessage(
          context,
          'Failed to load flashcard',
        );
      }
    }
    notifyListeners();
  }

  void updateReviewedCard(FlashCard card) {
    final exists = reviewedCards.any((c) => c.id == card.id);
    if (!exists) {
      reviewedCards.add(card);
    }
  }

  void updateLoading(bool value) {
    loading = value;
    notifyListeners();
  }

  void flipCard() {
    flipCardController.flipcard();
  }

  void initialize() {
    frontController.readOnly = true;
    backController.readOnly = true;
    notifyListeners();
    loadDeckFlashCards(initialize: true);
  }

  void updateDeckLastStudied() {}

  Future<void> loadDeckFlashCards({bool initialize = false}) async {
    flashCards = await fetchDeckFlashCards(context: context, deck: deck);
    if (initialize) {
      if (flashCards.isNotEmpty) {
        selectFlashCard(flashCards[0]);
      }
      startSessionTimer();
    }
    notifyListeners();
    updateLoading(false);
  }

  void openEndDrawer() {
    scaffoldKey.currentState?.openEndDrawer();
  }

  @override
  void dispose() {
    frontController.dispose();
    backController.dispose();
    lastStudiedTimer?.cancel();
    sessionTimer?.cancel();
    cardResponseTimer?.cancel();
    super.dispose();
  }
}
