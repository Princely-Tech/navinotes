import 'package:navinotes/packages.dart';
import 'package:navinotes/settings/packages.dart';

class Flashcard {
  int? id;
  String guid;
  int userId;
  List<Map<String, dynamic>> front;
  List<Map<String, dynamic>> back;
  String? tags;
  int createdAt;
  int updatedAt;

  Flashcard({
    this.id,
    required this.guid,
    required this.userId,
    required this.front,
    required this.back,
    this.tags,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'guid': guid,
    'user_id': userId,
    'front': jsonEncode(front),
    'back': jsonEncode(back),
    'tags': tags,
    'created_at': createdAt,
    'updated_at': updatedAt,
  };

  factory Flashcard.fromMap(Map<String, dynamic> map) {
    final frontJson = jsonDecode(map['front']);
    final backJson = jsonDecode(map['back']);
    List<Map<String, dynamic>> front =
        (frontJson as List).map((e) => Map<String, dynamic>.from(e)).toList();
    List<Map<String, dynamic>> back =
        (backJson as List).map((e) => Map<String, dynamic>.from(e)).toList();
    return Flashcard(
      id: map['id'],
      guid: map['guid'],
      userId: map['user_id'],
      front: front,
      back: back,
      tags: map['tags'],
      createdAt: map['created_at'],
      updatedAt: map['updated_at'],
    );
  }

  Flashcard getUpdatedFlashcard({
    List<Map<String, dynamic>>? front,
    List<Map<String, dynamic>>? back,
    int? updatedAt,
  }) {
    return Flashcard(
      id: id,
      guid: guid,
      userId: userId,
      front: front ?? this.front,
      back: back ?? this.back,
      tags: tags,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  setIDAfterCreate(int id) {
    this.id = id;
  }

  Future<int>? update({
    required List<Map<String, dynamic>> front,
    required List<Map<String, dynamic>> back,
  }) {
    try {
      Flashcard updated = getUpdatedFlashcard(front: front, back: back);
      return DatabaseHelper.instance.updateFlashcard(updated);
    } catch (err) {
      debugPrint('Error updating flashcard: $err');
      return null;
    }
  }
}
