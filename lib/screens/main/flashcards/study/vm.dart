import 'package:navinotes/packages.dart';

class FlashCardStudyVm extends ChangeNotifier {
  GlobalKey<ScaffoldState> scaffoldKey;
  BuildContext context;
  FlashCardDeck deck;
  FlashCardStudyVm({
    required this.scaffoldKey,
    required this.context,
    required this.deck,
  });

  QuillController frontController = QuillController.basic();
  QuillController backController = QuillController.basic();

  final flipCardController = FlipCardController();
  List<FlashCard> reviewedCards = [];
  List<FlashCard> flashCards = [];

  bool loading = true;

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
    loadDeckFlashCards();
  }

  Future<void> loadDeckFlashCards() async {
    flashCards = await fetchDeckFlashCards(context: context, deck: deck);
    
    // if (userFlashCards.isEmpty) {
    //   await initFlashCard();
    // } else {
    //   if (currentFlashCard == null) {
    //     selectFlashCard(userFlashCards.first);
    //   }
    // }
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
    super.dispose();
  }
}
