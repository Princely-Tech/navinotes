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
List<FlashCard> parseFlashCards(Map<String, dynamic> response, int deckId) {
  final cards = response['cards'] as List<dynamic>;

  // return cards.map((c) {
  //   final question = c['question'] as String? ?? '';
  //   final answer = c['answer'] as String? ?? '';
  //   final difficultyString = c['difficulty'] as String? ?? 'Easy';

  //   // Convert HTML/plaintext -> Quill Delta
  //   final frontDelta = quill.Document()..insert(question.replaceAll(RegExp(r'<[^>]*>'), '') + '\n');
  //   final backDelta  = quill.Document()..insert(answer.replaceAll(RegExp(r'<[^>]*>'), '') + '\n');

  //   return FlashCard.createNew(
  //     deckId: deckId,
  //     front: frontDelta.toDelta().toJson(),
  //     back: backDelta.toDelta().toJson(),
  //     tags: null,
  //   ).copyWith(
  //     difficulty: stringToEnum(difficultyString, FlashcardDifficulty.values),
  //   );
  // }).toList();
}
List<Map<String, dynamic>> htmlToDelta(String html) {
  final delta = DeltaFromHtmlCodec().decode(html);
  return delta.toJson();
}