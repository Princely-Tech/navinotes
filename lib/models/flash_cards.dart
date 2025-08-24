import 'package:navinotes/packages.dart';
import 'package:navinotes/settings/packages.dart';

class FlashCard {
  int? id;
  String guid;
  int deckId;
  List<Map<String, dynamic>> front;
  List<Map<String, dynamic>> back;
  String? tags;
  int createdAt;
  int updatedAt;

  FlashCard({
    this.id,
    required this.guid,
    required this.deckId,
    required this.front,
    required this.back,
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
  }) {
    return FlashCard(
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

  FlashCard getUpdatedFlashCard({
    List<Map<String, dynamic>>? front,
    List<Map<String, dynamic>>? back,
    String? tags,
    int? updatedAt,
    int? deckId,
  }) {
    return copyWith(
      front: front,
      back: back,
      tags: tags,
      updatedAt: updatedAt ?? DateTime.now().millisecondsSinceEpoch ~/ 1000,
      deckId: deckId,
    );
  }

  void setIDAfterCreate(int id) {
    this.id = id;
  }

  Future<int>? update({
    required List<Map<String, dynamic>> front,
    required List<Map<String, dynamic>> back,
    int? deckId,
  }) {
    try {
      FlashCard updated = getUpdatedFlashCard(
        front: front,
        back: back,
        deckId: deckId,
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
    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    return FlashCard(
      guid: 'flashcard_${DateTime.now().millisecondsSinceEpoch}',
      deckId: deckId,
      front: front,
      back: back,
      tags: tags,
      createdAt: now,
      updatedAt: now,
    );
  }
}
