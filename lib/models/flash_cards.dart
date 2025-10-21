import 'package:navinotes/packages.dart';

class FlashCard {
  String id;
  String deckId;
  List<Map<String, dynamic>> front;
  List<Map<String, dynamic>> back;
  String? tags;
  FlashcardDifficulty difficulty;
  int sortOrder;
  int createdAt;
  int updatedAt;
  
  // Spaced Repetition Fields
  int lastReviewed; // Unix timestamp of last review
  int nextReview; // Unix timestamp of next scheduled review
  int intervalDays; // Current review interval in days
  double easeFactor; // Ease factor for SM-2 algorithm (default 2.5)
  int reviewCount; // Number of times the card has been reviewed
  int streak; // Current streak of successful reviews

  FlashCard({
    String? id,
    required this.deckId,
    required this.front,
    required this.back,
    required this.difficulty,
    this.tags,
    this.sortOrder = 0,
    required this.createdAt,
    required this.updatedAt,
    // Spaced Repetition fields with defaults
    this.lastReviewed = 0, // Never reviewed
    int? nextReview,
    this.intervalDays = 1, // Start with 1 day
    this.easeFactor = 2.5, // Default SM-2 ease factor
    this.reviewCount = 0,
    this.streak = 0,
  }) : id = id ?? const Uuid().v4(),
       nextReview = nextReview ?? (createdAt + (24 * 60 * 60)); // Default to 1 day from creation

  Map<String, dynamic> toMap() => {
    'id': id,
    'deck_id': deckId,
    'front': jsonEncode(front),
    'back': jsonEncode(back),
    'tags': tags,
    'difficulty': difficulty.toString(),
    'sort_order': sortOrder,
    'created_at': createdAt,
    'updated_at': updatedAt,
    // Spaced Repetition fields
    'last_reviewed': lastReviewed,
    'next_review': nextReview,
    'interval_days': intervalDays,
    'ease_factor': easeFactor,
    'review_count': reviewCount,
    'streak': streak,
  };

  factory FlashCard.fromMap(Map<String, dynamic> map) {
    final front =
        map['front'] != null
            ? List<Map<String, dynamic>>.from(jsonDecode(map['front']) as List)
            : <Map<String, dynamic>>[];
    final back =
        map['back'] != null
            ? List<Map<String, dynamic>>.from(jsonDecode(map['back']) as List)
            : <Map<String, dynamic>>[];

    return FlashCard(
      difficulty: stringToEnum(map['difficulty'], FlashcardDifficulty.values),
      id: map['id'],
      deckId: map['deck_id'],
      front: front,
      back: back,
      tags: map['tags'],
      sortOrder: map['sort_order'] ?? 0,
      createdAt: map['created_at'] ?? 0,
      updatedAt: map['updated_at'] ?? 0,
      // Spaced Repetition fields with fallbacks for existing cards
      lastReviewed: map['last_reviewed'] ?? 0,
      nextReview: map['next_review'] ?? (map['created_at'] ?? 0) + (24 * 60 * 60),
      intervalDays: map['interval_days'] ?? 1,
      easeFactor: (map['ease_factor'] as num?)?.toDouble() ?? 2.5,
      reviewCount: map['review_count'] ?? 0,
      streak: map['streak'] ?? 0,
    );
  }

  FlashCard copyWith({
    String? id,
    String? deckId,
    List<Map<String, dynamic>>? front,
    List<Map<String, dynamic>>? back,
    String? tags,
    int? sortOrder,
    int? updatedAt,
    FlashcardDifficulty? difficulty,
    // Spaced Repetition fields
    int? lastReviewed,
    int? nextReview,
    int? intervalDays,
    double? easeFactor,
    int? reviewCount,
    int? streak,
  }) {
    return FlashCard(
      difficulty: difficulty ?? this.difficulty,
      id: id ?? this.id,
      deckId: deckId ?? this.deckId,
      front: front ?? this.front,
      back: back ?? this.back,
      tags: tags ?? this.tags,
      sortOrder: sortOrder ?? this.sortOrder,
      createdAt: this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      // Spaced Repetition fields
      lastReviewed: lastReviewed ?? this.lastReviewed,
      nextReview: nextReview ?? this.nextReview,
      intervalDays: intervalDays ?? this.intervalDays,
      easeFactor: easeFactor ?? this.easeFactor,
      reviewCount: reviewCount ?? this.reviewCount,
      streak: streak ?? this.streak,
    );
  }

  Future<bool>? update({
    List<Map<String, dynamic>>? front,
    List<Map<String, dynamic>>? back,
    String? deckId,
    FlashcardDifficulty? difficulty,
  }) {
    try {
      FlashCard updated = copyWith(
        front: front,
        back: back,
        deckId: deckId,
        difficulty: difficulty,
        updatedAt: generateUnixTimestamp(), // Update timestamp when card is modified
      );
      return DatabaseHelper.instance.updateFlashCard(updated);
    } catch (err) {
      debugPrint('Error updating flashcard: $err');
      return null;
    }
  }

  factory FlashCard.createNew({
    required String deckId,
    required List<Map<String, dynamic>> front,
    required List<Map<String, dynamic>> back,
    String? tags,
    int? sortOrder,
  }) {
    final currentTime = generateUnixTimestamp();
    return FlashCard(
      id: generateGUID(),
      difficulty: FlashcardDifficulty.easy,
      deckId: deckId,
      front: front,
      back: back,
      tags: tags,
      sortOrder: sortOrder ?? 0,
      createdAt: currentTime,
      updatedAt: currentTime,
      // Initialize spaced repetition fields for new cards
      lastReviewed: 0, // Never reviewed
      nextReview: currentTime + (24 * 60 * 60), // Due in 1 day
      intervalDays: 1,
      easeFactor: 2.5,
      reviewCount: 0,
      streak: 0,
    );
  }
}
