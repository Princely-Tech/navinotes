import 'package:navinotes/packages.dart';

/// Spaced Repetition System using the SM-2 Algorithm
/// Based on SuperMemo's SM-2 algorithm for optimal review intervals
class SpacedRepetitionSystem {
  
  /// Calculate the next review schedule for a flashcard based on user response
  /// Returns updated FlashCard with new spaced repetition values
  static FlashCard calculateNextReview(
    FlashCard card, 
    FlashcardDifficulty userResponse,
  ) {
    final currentTime = generateUnixTimestamp();
    
    // Convert difficulty to quality (0-5 scale for SM-2)
    final quality = _difficultyToQuality(userResponse);
    
    // Update review count
    final newReviewCount = card.reviewCount + 1;
    
    // Calculate new ease factor using SM-2 formula
    double newEaseFactor = card.easeFactor + (0.1 - (5 - quality) * (0.08 + (5 - quality) * 0.02));
    
    // Ensure ease factor doesn't go below 1.3 (SM-2 minimum)
    if (newEaseFactor < 1.3) {
      newEaseFactor = 1.3;
    }
    
    // Calculate new interval and streak
    int newIntervalDays;
    int newStreak;
    
    if (quality < 3) {
      // Failed review - reset interval and streak
      newIntervalDays = 1;
      newStreak = 0;
    } else {
      // Successful review
      newStreak = card.streak + 1;
      
      if (newReviewCount == 1) {
        // First review
        newIntervalDays = 1;
      } else if (newReviewCount == 2) {
        // Second review
        newIntervalDays = 6;
      } else {
        // Subsequent reviews: multiply previous interval by ease factor
        newIntervalDays = (card.intervalDays * newEaseFactor).round();
      }
    }
    
    // Calculate next review timestamp
    final nextReview = currentTime + (newIntervalDays * 24 * 60 * 60);
    
    return card.copyWith(
      lastReviewed: currentTime,
      nextReview: nextReview,
      intervalDays: newIntervalDays,
      easeFactor: newEaseFactor,
      reviewCount: newReviewCount,
      streak: newStreak,
      updatedAt: currentTime,
    );
  }
  
  /// Get cards that are due for review (next_review <= current time)
  static List<FlashCard> getDueCards(List<FlashCard> cards) {
    final currentTime = generateUnixTimestamp();
    return cards
        .where((card) => card.nextReview <= currentTime)
        .toList();
  }
  
  /// Get cards sorted by priority for review
  /// Priority order: overdue cards first, then by next review time
  static List<FlashCard> getCardsByPriority(List<FlashCard> cards) {
    final dueCards = getDueCards(cards);
    
    // Sort due cards by how overdue they are (most overdue first)
    dueCards.sort((a, b) => a.nextReview.compareTo(b.nextReview));
    
    return dueCards;
  }
  
  /// Get new cards that haven't been reviewed yet
  static List<FlashCard> getNewCards(List<FlashCard> cards, {int limit = 10}) {
    return cards
        .where((card) => card.reviewCount == 0)
        .take(limit)
        .toList();
  }
  
  /// Get learning cards (cards that were failed recently)
  static List<FlashCard> getLearningCards(List<FlashCard> cards) {
    return cards
        .where((card) => 
            card.reviewCount > 0 && 
            card.intervalDays < 21 && // Less than 3 weeks interval
            card.streak < 2) // Haven't had 2 consecutive successes
        .toList();
  }
  
  /// Get review cards (mature cards due for review)
  static List<FlashCard> getReviewCards(List<FlashCard> cards) {
    final currentTime = generateUnixTimestamp();
    return cards
        .where((card) => 
            card.reviewCount > 0 && 
            card.intervalDays >= 21 && // 3+ weeks interval (mature)
            card.nextReview <= currentTime)
        .toList();
  }
  
  /// Convert FlashcardDifficulty to SM-2 quality scale (0-5)
  static int _difficultyToQuality(FlashcardDifficulty difficulty) {
    switch (difficulty) {
      case FlashcardDifficulty.again:
        return 0; // Complete failure
      case FlashcardDifficulty.hard:
        return 2; // Difficult, but remembered
      case FlashcardDifficulty.medium:
        return 3; // Medium difficulty
      case FlashcardDifficulty.easy:
        return 4; // Easy to remember
    }
  }
  
  /// Get study session cards in optimal order
  /// Mixes new cards, learning cards, and review cards
  static List<FlashCard> getStudySessionCards(
    List<FlashCard> allCards, {
    int maxNewCards = 10,
    int maxLearningCards = 20,
    int maxReviewCards = 100,
  }) {
    final studyCards = <FlashCard>[];
    
    // Get different types of cards
    final newCards = getNewCards(allCards, limit: maxNewCards);
    final learningCards = getLearningCards(allCards);
    final reviewCards = getReviewCards(allCards);
    
    // Limit learning and review cards
    final limitedLearningCards = learningCards.take(maxLearningCards).toList();
    final limitedReviewCards = reviewCards.take(maxReviewCards).toList();
    
    // Add cards in priority order: overdue learning cards, new cards, review cards
    studyCards.addAll(limitedLearningCards);
    studyCards.addAll(newCards);
    studyCards.addAll(limitedReviewCards);
    
    // Sort by priority (most urgent first)
    studyCards.sort((a, b) => a.nextReview.compareTo(b.nextReview));
    
    return studyCards;
  }
  
  /// Get statistics for a deck
  static Map<String, dynamic> getDeckStats(List<FlashCard> cards) {
    final newCards = getNewCards(cards);
    final learningCards = getLearningCards(cards);
    final reviewCards = getReviewCards(cards);
    final dueCards = getDueCards(cards);
    
    // Calculate average ease factor
    final cardsWithReviews = cards.where((c) => c.reviewCount > 0).toList();
    final avgEaseFactor = cardsWithReviews.isNotEmpty
        ? cardsWithReviews.map((c) => c.easeFactor).reduce((a, b) => a + b) / cardsWithReviews.length
        : 2.5;
    
    return {
      'totalCards': cards.length,
      'newCards': newCards.length,
      'learningCards': learningCards.length,
      'reviewCards': reviewCards.length,
      'dueCards': dueCards.length,
      'averageEaseFactor': avgEaseFactor,
      'studyStreakLongest': cards.map((c) => c.streak).fold(0, (a, b) => a > b ? a : b),
    };
  }
}
