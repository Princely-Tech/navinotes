import 'package:navinotes/packages.dart';
import 'package:navinotes/settings/spaced_repetition.dart';

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
  List<FlashCard> studyQueue = []; // Cards selected for this study session
  FlashCard? currentCard;
  
  // Spaced Repetition Statistics
  Map<String, dynamic> deckStats = {};
  int newCardsStudied = 0;
  int reviewCardsStudied = 0;

  nextCardIndex() {
    if (studyQueue.isEmpty) return;
    currentCardIndex = (currentCardIndex + 1) % studyQueue.length;
    FlashCard current = studyQueue[currentCardIndex];
    
    // Reset card to front side when moving to next card
    _resetCardToFront();
    
    selectFlashCard(current);
  }

  previousCardIndex() {
    if (studyQueue.isEmpty) return;
    currentCardIndex = (currentCardIndex - 1 + studyQueue.length) % studyQueue.length;
    FlashCard current = studyQueue[currentCardIndex];
    
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
      // Calculate next review using spaced repetition
      final updatedCard = SpacedRepetitionSystem.calculateNextReview(
        currentCard!, 
        difficulty,
      );
      
      // Update card in database
      await DatabaseHelper.instance.updateFlashCard(updatedCard);
      
      // Update statistics
      if (currentCard!.reviewCount == 0) {
        newCardsStudied++;
      } else {
        reviewCardsStudied++;
      }
      
      // Refresh the deck data
      await loadDeckFlashCards();
      
      // Move to next card
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
    // Load all flashcards from database
    flashCards = await fetchDeckFlashCards(context: context, deck: deck);
    
    if (initialize) {
      // Generate study queue using spaced repetition
      studyQueue = SpacedRepetitionSystem.getStudySessionCards(
        flashCards,
        maxNewCards: 10,
        maxLearningCards: 20,
        maxReviewCards: 50,
      );
      
      // Calculate deck statistics
      deckStats = SpacedRepetitionSystem.getDeckStats(flashCards);
      
      // Start with first card if available
      if (studyQueue.isNotEmpty) {
        currentCardIndex = 0;
        selectFlashCard(studyQueue[0]);
      } else {
        // No cards due for review
        debugPrint('No cards due for review in this deck');
      }
      
      startSessionTimer();
    }
    notifyListeners();
    updateLoading(false);
  }

  void openEndDrawer() {
    scaffoldKey.currentState?.openEndDrawer();
  }

  // Spaced Repetition Getters
  int get totalCardsInDeck => flashCards.length;
  int get cardsInStudySession => studyQueue.length;
  int get newCardsCount => deckStats['newCards'] ?? 0;
  int get learningCardsCount => deckStats['learningCards'] ?? 0;
  int get reviewCardsCount => deckStats['reviewCards'] ?? 0;
  int get dueCardsCount => deckStats['dueCards'] ?? 0;
  
  bool get hasCardsToStudy => studyQueue.isNotEmpty;
  
  String get sessionSummary {
    if (studyQueue.isEmpty) {
      return 'No cards due for review. Great job staying on top of your studies!';
    }
    
    final parts = <String>[];
    if (newCardsCount > 0) parts.add('$newCardsCount new');
    if (learningCardsCount > 0) parts.add('$learningCardsCount learning');
    if (reviewCardsCount > 0) parts.add('$reviewCardsCount review');
    
    return 'Study session: ${parts.join(', ')} cards';
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
