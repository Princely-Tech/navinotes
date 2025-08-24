import 'dart:convert';

import 'package:navinotes/packages.dart';
import 'package:navinotes/settings/db_helpers.dart';

class FlashCardDeck {
  int? id;
  final String guid;
  final int? boardId;
  final String name;
  final String? description;
  final int cardsPerDay;
  final List<int> steps;
  final int againInterval;
  final int hardInterval;
  final int goodInterval;
  final int easyInterval;
  final int createdAt;
  final int updatedAt;
  final int? syncedAt;

  FlashCardDeck({
    this.id,
    required this.guid,
    this.boardId,
    required this.name,
    this.description,
    this.cardsPerDay = 20,
    List<int>? steps,
    this.againInterval = 1,
    this.hardInterval = 3,
    this.goodInterval = 5,
    this.easyInterval = 7,
    required this.createdAt,
    required this.updatedAt,
    this.syncedAt,
  }) : steps = steps ?? [1, 10];

  FlashCardDeck copyWith({
    int? id,
    String? guid,
    int? boardId,
    String? name,
    String? description,
    int? cardsPerDay,
    List<int>? steps,
    int? againInterval,
    int? hardInterval,
    int? goodInterval,
    int? easyInterval,
    int? createdAt,
    int? updatedAt,
    int? syncedAt,
  }) {
    return FlashCardDeck(
      id: id ?? this.id,
      guid: guid ?? this.guid,
      boardId: boardId ?? this.boardId,
      name: name ?? this.name,
      description: description ?? this.description,
      cardsPerDay: cardsPerDay ?? this.cardsPerDay,
      steps: steps ?? List<int>.from(this.steps),
      againInterval: againInterval ?? this.againInterval,
      hardInterval: hardInterval ?? this.hardInterval,
      goodInterval: goodInterval ?? this.goodInterval,
      easyInterval: easyInterval ?? this.easyInterval,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncedAt: syncedAt ?? this.syncedAt,
    );
  }

  void setIDAfterCreate(int id) {
    this.id = id;
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'guid': guid,
    'board_id': boardId,
    'name': name,
    'description': description,
    'cards_per_day': cardsPerDay,
    'steps': jsonEncode(steps),
    'again_interval': againInterval,
    'hard_interval': hardInterval,
    'good_interval': goodInterval,
    'easy_interval': easyInterval,
    'created_at': createdAt,
    'updated_at': updatedAt,
    'synced_at': syncedAt,
  };

  factory FlashCardDeck.fromMap(Map<String, dynamic> map) {
    List<int> steps = [1, 10];
    if (map['steps'] != null) {
      if (map['steps'] is String) {
        steps = List<int>.from(jsonDecode(map['steps']));
      } else if (map['steps'] is List) {
        steps = List<int>.from(map['steps']);
      }
    }

    return FlashCardDeck(
      id: map['id'],
      guid: map['guid'],
      boardId: map['board_id'],
      name: map['name'],
      description: map['description'],
      cardsPerDay: map['cards_per_day'] ?? 20,
      steps: steps,
      againInterval: map['again_interval'] ?? 1,
      hardInterval: map['hard_interval'] ?? 3,
      goodInterval: map['good_interval'] ?? 5,
      easyInterval: map['easy_interval'] ?? 7,
      createdAt: map['created_at'],
      updatedAt: map['updated_at'],
      syncedAt: map['synced_at'],
    );
  }

  Future<int>? update({String? name}) {
    try {
      FlashCardDeck updatedDeck = copyWith(name: name);
      return DatabaseHelper.instance.updateDeck(updatedDeck);
    } catch (err) {
      debugPrint('Error updating deck: $err');
      return null;
    }
  }

  factory FlashCardDeck.createNew({
    required int boardId,
    required String name,
    String? description,
  }) {
    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    return FlashCardDeck(
      guid: 'deck_${DateTime.now().millisecondsSinceEpoch}',
      boardId: boardId,
      name: name,
      description: description,
      createdAt: now,
      updatedAt: now,
    );
  }
}
