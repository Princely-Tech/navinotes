import 'package:navinotes/packages.dart';
import 'package:navinotes/screens/main/flashcards/decks.dart';

class FlashCardVm extends ChangeNotifier {
  SessionManager sessionVm;
  BuildContext context;
  FlashCardVm({required this.sessionVm, required this.context});

  bool creatingDeck = false;

  void setCreatingDeck(bool value) {
    creatingDeck = value;
    notifyListeners();
  }

  Future<List<FlashCardDeck>> fetchDecks(Board board) async {
    final dbHelper = DatabaseHelper.instance;
    try {
      return dbHelper.getBoardDecks(board.id!);
    } catch (err) {
      debugPrint('Error fetching decks: $err');
      return [];
    }
  }

  void showBoardDecks(Board board) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      builder:
          (context) => DraggableScrollableSheet(
            expand: false,
            builder:
                (_, controller) => Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      // Draggable handle
                      Container(
                        width: 40,
                        height: 5,
                        margin: const EdgeInsets.only(bottom: 16.0),
                        decoration: BoxDecoration(
                          color: Colors.grey[400],
                          borderRadius: BorderRadius.circular(2.5),
                        ),
                      ),
                      // Title
                      Text(
                        '${board.name} Decks',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Decks list
                      Expanded(child: FlashCardDecks(board: board, vm: this)),
                    ],
                  ),
                ),
          ),
    );
  }

  Future<void> createNewDeck(Board board) async {
    try {
      setCreatingDeck(true);
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
      goToManualFlashCard(newDeck);
    } catch (e) {
      debugPrint('Error creating deck: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create deck: ${e.toString()}')),
        );
      }
    } finally {
      setCreatingDeck(false);
    }
  }

  Future<void> goToManualFlashCard(FlashCardDeck deck) async {
    await NavigationHelper.navigateToManualFlashCard(deck);
    sessionVm.getAllBoard();
  }

  goToCreateBoard() async {
    await NavigationHelper.push(Routes.chooseBoard);
    sessionVm.getAllBoard();
  }
}
