// class FlashCard {
//   final int? id;
//   final int boardId;
//   final String front;
//   final String back;
//   final int createdAt; // Unix timestamp
//   final int updatedAt; // Unix timestamp
//   final int? syncedAt; // Nullable

//   FlashCard({
//     this.id,
//     required this.boardId,
//     required this.front,
//     required this.back,
//     required this.createdAt,
//     required this.updatedAt,
//     this.syncedAt,
//   });

//   Map<String, dynamic> toMap() => {
//     'id': id,
//     'user_id': boardId,
//     'front': front,
//     'back': back,
//     'created_at': createdAt,
//     'updated_at': updatedAt,
//     'synced_at': syncedAt,
//   };

//   factory FlashCard.fromMap(Map<String, dynamic> map) => FlashCard(
//     id: map['id'],
//     boardId: map['user_id'],
//     front: map['front'],
//     back: map['back'],
//     createdAt: map['created_at'],
//     updatedAt: map['updated_at'],
//     syncedAt: map['synced_at'],
//   );
// }
