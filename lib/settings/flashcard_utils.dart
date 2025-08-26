import 'package:flutter_quill/quill_delta.dart';
import 'package:navinotes/packages.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;

Document safeDocFromJson(List<Map<String, dynamic>> json) {
  try {
    if (json.isEmpty) return Document()..insert(0, '');
    return Document.fromJson(json);
  } catch (_) {
    return Document()..insert(0, ''); // fallback
  }
}

String jsonToPlainText(List<Map<String, dynamic>> delta) {
  return delta.map((e) => e['insert']?.toString() ?? '').join('');
}

// Add this method to your FlashCardsManualCreationVm class
Future<void> deleteFlashCard({
  required BuildContext context,
  required FlashCard card,
}) async {
  try {
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Delete FlashCard'),
            content: const Text(
              'Are you sure you want to delete this flashcard? This action cannot be undone.',
            ),
            actions: [
              AppButton.secondary(
                onTap: () => Navigator.of(context).pop(false),
                text: 'Cancel',
                mainAxisSize: MainAxisSize.min,
              ),
              AppButton(
                onTap: () => Navigator.of(context).pop(true),
                text: 'Delete',
                color: AppTheme.coralRed,
                mainAxisSize: MainAxisSize.min,
              ),
            ],
          ),
    );

    if (confirmed == true) {
      await DatabaseHelper.instance.deleteFlashCard(card.id!);
      if (context.mounted) {
        MessageDisplayService.showMessage(context, 'Card deleted');
      }
    }
  } catch (e) {
    debugPrint('Error deleting card: $e');
    if (context.mounted) {
      MessageDisplayService.showErrorMessage(context, 'Failed to delete card');
    }
  }
}

Future<List<FlashCard>> fetchDeckFlashCards({
  required BuildContext context,
  required FlashCardDeck deck,
}) async {
  try {
    return DatabaseHelper.instance.getDeckFlashCards(deck.id!);
  } catch (e) {
    debugPrint('Error loading flashcards: $e');
    if (context.mounted) {
      MessageDisplayService.showErrorMessage(
        context,
        'Failed to load flashcards',
      );
    }
    return [];
  }
}

int countDifficultyFlashCards({
  required List<FlashCard> cards,
  required FlashcardDifficulty difficulty,
}) {
  return cards.where((card) => card.difficulty == difficulty).length;
}

String plainTextFromQuillJson(List<Map<String, dynamic>> json) {
  QuillController controller = QuillController(
    document: safeDocFromJson(json),
    selection: const TextSelection.collapsed(offset: 0),
  );
  return controller.document.toPlainText().trim();
}

String getPlainTextFromDelta(String jsonContent) {
  try {
    final List<dynamic> deltaJson = jsonDecode(jsonContent);
    final Delta delta = Delta.fromJson(deltaJson);
    final Document doc = Document.fromDelta(delta);
    return doc.toPlainText().trim();
  } catch (e) {
    debugPrint('Error getting plain text from delta: $e');
    return '';
  }
}

Future<List<FlashCard>> parseResponseFlashCards({
  required Map<String, dynamic> response,
  required BuildContext context,
  required int deckId,
}) async {
  final List<FlashCard> flashCards = [];
  final cards = response['cards'] as List<dynamic>;

  for (Map<String, dynamic> card in cards) {
    final frontJson = htmlToDelta(card['question']);
    final backJson = htmlToDelta(card['answer']);
    final result = await  createFlashcard(
      context: context,
      deckId: deckId,
      front: frontJson,
      back: backJson,
      difficulty: stringToEnum(card['difficulty'], FlashcardDifficulty.values),
    );
    flashCards.add(result);
  }
  return flashCards;
}

List<Map<String, dynamic>> htmlToDelta(String html) {
  var delta = HtmlToDelta().convert(html, transformTableAsEmbed: false);
  return delta.toJson();
}

Future<FlashCard> createFlashcard({
  required BuildContext context,
  required int deckId,
  required List<Map<String, dynamic>> front,
  required List<Map<String, dynamic>> back,
  required FlashcardDifficulty difficulty,
}) async {
  final currentUser = getCurrentUserFromSession(context);

  if (isNotNull(currentUser)) {
    final currentTimestamp = generateUnixTimestamp();
    FlashCard card = FlashCard(
      guid: generateGUID(currentUser!.id!),
      deckId: deckId,
      front: front,
      back: back,
      difficulty: difficulty,
      createdAt: currentTimestamp,
      updatedAt: currentTimestamp,
    );
    int id = await DatabaseHelper.instance.insertFlashCard(card);
    card.setIDAfterCreate(id);
    return card;
  } else {
    throw 'User not found';
  }
}
