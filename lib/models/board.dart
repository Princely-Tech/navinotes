import 'package:navinotes/packages.dart';

class Board {
  final int? id;
  final int userId;
  final String type;
  final String name;
  final Map<String, dynamic> customization;
  final bool isPublic;
  final String? description;
  final String? subject;
  final String? level;
  final String? term;
  final String? coverImage;
  final int createdAt;
  final int updatedAt;
  final int? syncedAt;

  Board({
    this.id,
    required this.userId,
    required this.type,
    required this.name,
    required this.customization,
    this.isPublic = false,
    this.description,
    this.subject,
    this.level,
    this.term,
    this.coverImage,
    required this.createdAt,
    required this.updatedAt,
    this.syncedAt,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'user_id': userId,
    'type': type,
    'name': name,
    'customization': jsonEncode(customization),
    'is_public': isPublic ? 1 : 0,
    'description': description,
    'subject': subject,
    'level': level,
    'term': term,
    'cover_image': coverImage,
    'created_at': createdAt,
    'updated_at': updatedAt,
    'synced_at': syncedAt,
  };

  factory Board.fromMap(Map<String, dynamic> map) => Board(
    id: map['id'],
    userId: map['user_id'],
    type: map['type'],
    name: map['name'],
    customization: jsonDecode(map['customization']),
    isPublic: map['is_public'] == 1,
    description: map['description'],
    subject: map['subject'],
    level: map['level'],
    term: map['term'],
    coverImage: map['cover_image'],
    createdAt: map['created_at'],
    updatedAt: map['updated_at'],
    syncedAt: map['synced_at'],
  );
}

class BoardType {
  final String name;
  final String image;
  final String description;
  final String route;
  final String body;

  BoardType({
    required this.name,
    required this.route,
    required this.image,
    required this.description,
    required this.body,
  });
}

List<BoardType> boardTypes = [
  BoardType(
    name: 'Plain',
    image: Images.boardPlain,
    description: 'Clean, distraction-free interface',
    route: Routes.boardPlain,
    body:
        'A clean, distraction-free interface that keeps the focus on your ideas and connections. Perfect for academic study and professional planning.',
  ),
  BoardType(
    name: 'Minimalist',
    image: Images.boardMinimalist,
    description: 'Simplified, essential elements only',
    route: Routes.boardMinimalist,
    body: 'Some description',
  ),
  BoardType(
    name: 'Dark Academia',
    image: Images.boardAcademiaDark,
    description: 'Vintage scholarly, darker tones',
    route: Routes.boardDarkAcademia,
    body: 'Some description',
  ),
  BoardType(
    name: 'Light Academia',
    image: Images.boardAcademiaLight,
    description: 'Bright scholarly, cream tones',
    route: Routes.boardLightAcademia,
    body: 'Some description',
  ),
  BoardType(
    name: 'Nature',
    image: Images.boardNature,
    description: 'Organic patterns, natural colors',
    route: Routes.boardNature,
    body: 'Some description',
  ),
  // BoardType(
  //   name: 'Pastel',
  //   image: Images.boardPastel,
  //   description: 'Soft, muted color palette',
  //   route: '',
  // ),
  // BoardType(
  //   name: 'Tech/Neon',
  //   image: Images.boardNeon,
  //   description: 'Digital, vibrant highlights',
  //   route: '',
  // ), //TODO uncoment this
];

class Content {
  final int? id;
  final String type; // note, mindmap, syllabus, etc.
  final Map<String, dynamic> metaData; // JSON as Map
  final int boardId;
  final String? tags; // Comma-separated tags
  final String? content; // Large text
  final String? file; // File name or path
  final int createdAt; // Unix timestamp
  final int updatedAt; // Unix timestamp
  final int? syncedAt; // Unix timestamp, nullable

  Content({
    this.id,
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
