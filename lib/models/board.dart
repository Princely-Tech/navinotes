import 'package:navinotes/models/content.dart';
import 'package:navinotes/packages.dart';

class Board {
  int? id;
  final String guid;
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
  final List<CourseTimeline>? courseTimeLines;
  final CourseInfo? courseInfo;

  final bool
  coverImageNeedSync; // set this to true any time cover image is changed. The syncToBackend method will handle the rest.

  Board({
    this.id,
    required this.guid,
    required this.userId,
    required this.type,
    required this.name,
    required this.customization,
    this.isPublic = false,
    this.description,
    this.courseTimeLines,
    this.courseInfo,
    this.subject,
    this.level,
    this.term,
    this.coverImage,
    required this.createdAt,
    required this.updatedAt,
    this.syncedAt,
    this.coverImageNeedSync = false,
  });

  Board copyWith({
    int? id,
    String? guid,
    int? userId,
    String? type,
    String? name,
    Map<String, dynamic>? customization,
    bool? isPublic,
    String? description,
    String? subject,
    String? level,
    String? term,
    String? coverImage,
    int? createdAt,
    int? updatedAt,
    int? syncedAt,
    List<CourseTimeline>? courseTimeLines,
    CourseInfo? courseInfo,

    bool? coverImageNeedSync,
  }) {
    return Board(
      id: id ?? this.id,
      guid: guid ?? this.guid,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      name: name ?? this.name,
      customization:
          customization ?? Map<String, dynamic>.from(this.customization),
      isPublic: isPublic ?? this.isPublic,
      description: description ?? this.description,
      subject: subject ?? this.subject,
      level: level ?? this.level,
      term: term ?? this.term,
      coverImage: coverImage ?? this.coverImage,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncedAt: syncedAt ?? this.syncedAt,
      courseTimeLines: courseTimeLines ?? this.courseTimeLines,
      courseInfo: courseInfo ?? this.courseInfo,
      coverImageNeedSync: coverImageNeedSync ?? this.coverImageNeedSync,
    );
  }

  BoardTypeCodes? get boardType {
    try {
      return BoardTypeCodes.values.firstWhere((e) => e.name == type);
    } catch (e) {
      return null;
    }
  }

  setIDAfterCreate(int id) {
    this.id = id;
  }

  String getImage() {
    return getBoardTypeImage();
  }

  String getBoardTypeImage() {
    if (boardType == null) {
      return boardTypePlainImage;
    }
    switch (boardType!) {
      case BoardTypeCodes.plain:
        return boardTypePlainImage;
      case BoardTypeCodes.minimalist:
        return boardTypeMinimalistImage;
      case BoardTypeCodes.darkAcademia:
        return boardTypeDarkAcademiaImage;
      case BoardTypeCodes.lightAcademia:
        return boardTypeLightAcademiaImage;
      case BoardTypeCodes.nature:
        return boardTypeNatureImage;
    }
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'guid': guid,
    'user_id': userId,
    'type': type,
    'name': name,
    'course_info': courseInfo == null ? null : jsonEncode(courseInfo?.toMap()),
    'course_timelines': courseTimeLines == null ? null : jsonEncode(courseTimeLines?.map((e) => e.toMap()).toList()),
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
    'cover_image_need_sync': coverImageNeedSync ? 1 : 0,
  
  };

  factory Board.fromMap(Map<String, dynamic> map) {
    // Parse course_info if it exists
    CourseInfo? courseInfo;
    if (map['course_info'] != null) {
      if (map['course_info'] is String) {
        // If stored as JSON string
        courseInfo = CourseInfo.fromMap(
          Map<String, dynamic>.from(jsonDecode(map['course_info'])),
        );
      } else if (map['course_info'] is Map) {
        // If already a map
        courseInfo = CourseInfo.fromMap(
          Map<String, dynamic>.from(jsonDecode(map['course_info'])),
        );
      }
    }

    // Parse course_timelines if they exist.
    List<CourseTimeline>? courseTimeLines;
    if (map['course_timelines'] != null) {
      if (map['course_timelines'] is String) {
        // If stored as JSON string
        final List<dynamic> timelineList = jsonDecode(map['course_timelines']);
        courseTimeLines =
            timelineList
                .map(
                  (e) => CourseTimeline.fromMap(Map<String, dynamic>.from(e)),
                )
                .toList();
      } else if (map['course_timelines'] is List) {
        // If already a list
        courseTimeLines =
            (map['course_timelines'] as List)
                .map(
                  (e) => CourseTimeline.fromMap(Map<String, dynamic>.from(e)),
                )
                .toList();
      }
    }

    return Board(
      id: map['id'],
      guid: map['guid'],
      userId: map['user_id'],
      type: map['type'],
      name: map['name'],
      customization:
          map['customization'] is String
              ? jsonDecode(map['customization'])
              : Map<String, dynamic>.from(map['customization'] ?? {}),
      isPublic: map['is_public'] == 1,
      description: map['description'],
      subject: map['subject'],
      level: map['level'],
      term: map['term'],
      coverImage: map['cover_image'],
      createdAt: map['created_at'],
      updatedAt: map['updated_at'],
      syncedAt: map['synced_at'],
      coverImageNeedSync: map['cover_image_need_sync'] == 1,
      courseInfo: courseInfo,
      courseTimeLines: courseTimeLines,
    );
  }

  // Cache for board contents
  List<Content>? _cachedContents;
  bool _hasFetchedContents = false;

  /// Gets all contents associated with this board with caching.
  /// Fetches from the database only if not already cached.
  Future<List<Content>> getContents({bool forceRefresh = false}) async {
    if (_hasFetchedContents && _cachedContents != null && !forceRefresh) {
      return _cachedContents!;
    }

    final db = await DatabaseHelper.instance.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'contents',
      where: 'board_id = ?',
      whereArgs: [id],
    );

    _cachedContents = List.generate(
      maps.length,
      (i) => Content.fromMap(maps[i]),
    );
    _hasFetchedContents = true;
    return _cachedContents!;
  }

  /// Clears the cached contents, forcing a fresh fetch on next getContents() call
  void clearContentsCache() {
    _cachedContents = null;
    _hasFetchedContents = false;
  }

  // TODO: Thompson correct this. When you save the image/file to storage, extract it back here
  File? getCoverImageFile() {
    if (coverImage == null || coverImage == "") {
      return null;
    }
    return File(coverImage!);
  }

  syncToBackend(ApiServiceProvider apiServiceProvider) async {
    Map<String, File> files = {};

    // if (coverImageNeedSync == true) {
    //   File? coverImageFile = getCoverImageFile();

    //   if (coverImageFile != null) {
    //     files = {'cover_image_file': coverImageFile};
    //   }
    // }

    final body = FormDataRequest.post(
      ApiEndpoints.boardSync,
      body: {
        'guid': guid,
        'user_id': userId,
        'type': type,
        'name': name,
        'customization': customization,
        'is_public': isPublic ? 1 : 0,
        'description': description,
        'subject': subject,
        'level': level,
        'term': term,
        'cover_image': coverImage,
        'synced_at': syncedAt,
      },
      files: files,
    );

    final response = await apiServiceProvider.apiService.sendFormDataRequest(
      body,
    );

    return response;
  }
}

// create enum to hold the board types names
enum BoardTypeCodes { plain, minimalist, darkAcademia, lightAcademia, nature }

var boardTypePlainImage = Images.boardPlain;
var boardTypeMinimalistImage = Images.boardMinimalist;
var boardTypeDarkAcademiaImage = Images.boardAcademiaDark;
var boardTypeLightAcademiaImage = Images.boardAcademiaLight;
var boardTypeNatureImage = Images.boardNature;

// A function that convert the enum to string
String boardTypeToString(BoardTypeCodes type) {
  switch (type) {
    case BoardTypeCodes.plain:
      return 'Plain';
    case BoardTypeCodes.minimalist:
      return 'Minimalist';
    case BoardTypeCodes.darkAcademia:
      return 'Dark Academia';
    case BoardTypeCodes.lightAcademia:
      return 'Light Academia';
    case BoardTypeCodes.nature:
      return 'Nature';
  }
}

class BoardType {
  final String name;
  final String code;
  final String image;
  final String description;
  final String route;
  final String body;

  BoardType({
    required this.name,
    required this.code,
    required this.route,
    required this.image,
    required this.description,
    required this.body,
  });
}

List<BoardType> boardTypes = [
  BoardType(
    name: 'Plain',
    code: BoardTypeCodes.plain.name,
    image: boardTypePlainImage,
    description: 'Clean, distraction-free interface',
    route: Routes.boardPlain,
    body:
        'A clean, distraction-free interface that keeps the focus on your ideas and connections. Perfect for academic study and professional planning.',
  ),
  BoardType(
    name: 'Minimalist',
    code: BoardTypeCodes.minimalist.name,
    image: boardTypeMinimalistImage,
    description: 'Simplified, essential elements only',
    route: Routes.boardMinimalist,
    body: 'Some description',
  ),
  BoardType(
    name: 'Dark Academia',
    code: BoardTypeCodes.darkAcademia.name,
    image: boardTypeDarkAcademiaImage,
    description: 'Vintage scholarly, darker tones',
    route: Routes.boardDarkAcademia,
    body: 'Some description',
  ),
  BoardType(
    name: 'Light Academia',
    code: BoardTypeCodes.lightAcademia.name,
    image: boardTypeLightAcademiaImage,
    description: 'Bright scholarly, cream tones',
    route: Routes.boardLightAcademia,
    body: 'Some description',
  ),
  BoardType(
    name: 'Nature',
    code: BoardTypeCodes.nature.name,
    image: boardTypeNatureImage,
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
