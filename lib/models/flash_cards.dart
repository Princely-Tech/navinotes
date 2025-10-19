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
  }) : id = id ?? const Uuid().v4();

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
    return FlashCard(
      id: generateGUID(),
      difficulty: FlashcardDifficulty.easy,
      deckId: deckId,
      front: front,
      back: back,
      tags: tags,
      sortOrder: sortOrder ?? 0,
      createdAt: generateUnixTimestamp(),
      updatedAt: generateUnixTimestamp(),
    );
  }
}
