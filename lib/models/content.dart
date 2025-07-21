import 'package:navinotes/packages.dart';



class Content {
  final int? id;
  final String guid;
  final String type; // note, mindmap, syllabus, etc.
  final Map<String, dynamic> metaData; // JSON as Map
  final int boardId;
  final String? tags; // Comma-separated tags
  final String? content; // Large text
  final String? file; // File name or path
  final int createdAt; // Unix timestamp
  final int updatedAt; // Unix timestamp
  final int? syncedAt; // Unix timestamp, nullable
  final String title;
  final String? coverImage;

  Content({
    this.id,
    required this.guid,
    required this.title,
     this.coverImage,
    required this.type,
    required this.metaData,
    required this.boardId,
    this.tags,
    this.content,
    this.file,
    required this.createdAt,
    required this.updatedAt,
    this.syncedAt,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'guid': guid,
    'title': title,
    'cover_image': coverImage,
    'type': type,
    'meta_data': jsonEncode(metaData),
    'board_id': boardId,
    'tags': tags,
    'content': content,
    'file': file,
    'created_at': createdAt,
    'updated_at': updatedAt,
    'synced_at': syncedAt,
  };

  factory Content.fromMap(Map<String, dynamic> map) => Content(
    id: map['id'],
    guid: map['guid'],
    title: map['title'],
    coverImage: map['cover_image'],
    type: map['type'],
    metaData: jsonDecode(map['meta_data']),
    boardId: map['board_id'],
    tags: map['tags'],
    content: map['content'],
    file: map['file'],
    createdAt: map['created_at'],
    updatedAt: map['updated_at'],
    syncedAt: map['synced_at'],
  );
}
