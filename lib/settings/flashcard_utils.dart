import 'package:navinotes/packages.dart';

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
