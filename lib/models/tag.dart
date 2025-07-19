
class Tag {
  final int? id;
  final int userId;
  final String name;
  final int createdAt; // Unix timestamp
  final int updatedAt; // Unix timestamp
  final int? syncedAt; // Nullable

  Tag({
    this.id,
    required this.userId,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
    this.syncedAt,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'user_id': userId,
    'name': name,
    'created_at': createdAt,
    'updated_at': updatedAt,
    'synced_at': syncedAt,
  };

  factory Tag.fromMap(Map<String, dynamic> map) => Tag(
    id: map['id'],
    userId: map['user_id'],
    name: map['name'],
    createdAt: map['created_at'],
    updatedAt: map['updated_at'],
    syncedAt: map['synced_at'],
  );
}
