import 'package:navinotes/packages.dart';
import 'package:navinotes/settings/packages.dart';

class FlashCard {
  int? id;
  String guid;
  int deckId;
  List<Map<String, dynamic>> front;
  List<Map<String, dynamic>> back;
  String? tags;
  FlashcardDifficulty difficulty;
  int createdAt;
  int updatedAt;

  FlashCard({
    this.id,
    required this.guid,
    required this.deckId,
    required this.front,
    required this.back,
    required this.difficulty,
    this.tags,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'guid': guid,
    'deck_id': deckId,
    'front': jsonEncode(front),
    'back': jsonEncode(back),
    'tags': tags,
    'difficulty': difficulty.toString(),
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
      guid: map['guid'],
      deckId: map['deck_id'],
      front: front,
      back: back,
      tags: map['tags'],
      createdAt: map['created_at'] ?? 0,
      updatedAt: map['updated_at'] ?? 0,
    );
  }

  FlashCard copyWith({
    int? id,
    String? guid,
    int? deckId,
    List<Map<String, dynamic>>? front,
    List<Map<String, dynamic>>? back,
    String? tags,
    int? updatedAt,
    FlashcardDifficulty? difficulty,
  }) {
    return FlashCard(
      difficulty: difficulty ?? this.difficulty,
      id: id ?? this.id,
      guid: guid ?? this.guid,
      deckId: deckId ?? this.deckId,
      front: front ?? this.front,
      back: back ?? this.back,
      tags: tags ?? this.tags,
      createdAt: this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  void setIDAfterCreate(int id) {
    this.id = id;
  }

  Future<int>? update({
    List<Map<String, dynamic>>? front,
    List<Map<String, dynamic>>? back,
    int? deckId,
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
    required int deckId,
    required List<Map<String, dynamic>> front,
    required List<Map<String, dynamic>> back,
    String? tags,
  }) {
    return FlashCard(
      difficulty: FlashcardDifficulty.easy,
      guid: 'flashcard_${DateTime.now().millisecondsSinceEpoch}',
      deckId: deckId,
      front: front,
      back: back,
      tags: tags,
      createdAt: generateUnixTimestamp(),
      updatedAt: generateUnixTimestamp(),
    );
  }
}
