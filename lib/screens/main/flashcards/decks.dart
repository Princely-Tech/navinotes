import 'dart:math';
import 'package:flutter/material.dart';
import 'package:navinotes/packages.dart';
import 'package:navinotes/screens/main/flashcards/vm.dart';

class FlashCardDecks extends StatelessWidget {
  final Board board;
  final FlashCardVm vm;

  const FlashCardDecks({super.key, required this.board, required this.vm});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<FlashCardDeck>>(
      future: vm.fetchDecks(board),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error loading decks: ${snapshot.error}'));
        }

        final decks = snapshot.data ?? [];

        if (decks.isEmpty) {
          return Center(
            child: Column(
              spacing: 20,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'No decks found in ${board.name}',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                AppButton(
                  onTap: () => vm.createNewDeck(board),
                  loading: vm.creatingDeck,
                  text: 'Create New Deck',
                  mainAxisSize: MainAxisSize.min,
                  prefix: const Icon(Icons.add, color: AppTheme.white),
                ),
              ],
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.all(16.0),
          itemCount: decks.length + 1,
          separatorBuilder: (context, index) => const SizedBox(height: 16.0),
          itemBuilder: (context, index) {
            if (index == decks.length) {
              return AppButton(
                onTap: () => vm.createNewDeck(board),
                loading: vm.creatingDeck,
                text: 'Create New Deck',
                prefix: const Icon(Icons.add, color: AppTheme.white),
              );
            }
            final deck = decks[index];
            return _deckCard(deck);
          },
        );
      },
    );
  }

  Widget _deckCard(FlashCardDeck deck) {
    return InkWell(
      onTap: () => vm.goToManualFlashCard(deck),
      child: CustomCard(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    deck.name,
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            if (deck.description?.isNotEmpty ?? false) ...{
              const SizedBox(height: 8.0),
              Text(
                deck.description!,
                style: TextStyle(color: Colors.grey[600], fontSize: 14.0),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            },
            const SizedBox(height: 12.0),
            Row(
              children: [
                _buildStatItem(
                  Icons.credit_card_outlined,
                  '${deck.cardsPerDay} cards/day',
                ),
                const SizedBox(width: 16.0),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16.0, color: Colors.grey[600]),
        const SizedBox(width: 4.0),
        Text(text, style: TextStyle(color: Colors.grey[600], fontSize: 13.0)),
      ],
    );
  }
}
