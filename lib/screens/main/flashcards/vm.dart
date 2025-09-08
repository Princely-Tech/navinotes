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
                      Row(
                        spacing: 15,
                        children: [
                          Expanded(
                            child: Text(
                              '${board.name} Decks',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          AppButton(
                            mainAxisSize: MainAxisSize.min,
                            onTap: () => createNewDeck(board),
                            loading: creatingDeck,
                            text: 'Create New Deck',
                            prefix: const Icon(
                              Icons.add,
                              color: AppTheme.white,
                            ),
                          ),
                        ],
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
      NavigationHelper.createAndNavigateToNewFlashCard(board);
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
    await NavigationHelper.navigateToDeck(deck);
    sessionVm.getAllBoard();
  }

  goToCreateBoard() async {
    await NavigationHelper.push(Routes.chooseBoard);
    sessionVm.getAllBoard();
  }
}
