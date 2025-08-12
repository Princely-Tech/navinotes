import 'package:navinotes/packages.dart';

class Content {
  int? id;
  final String guid;
  final AppContentType type; // note, mindmap, syllabus, etc.
  final Map<String, dynamic> metaData; // JSON as Map
  final int boardId;
  final String? tags; // Comma-separated tags
  final String? content; // Large text
  final String? drawing; // Large text
  final String? file; // File name or path
  final int createdAt; // Unix timestamp
  final int updatedAt; // Unix timestamp
  final int? syncedAt; // Unix timestamp, nullable
  final String title;
  final String? coverImage;
  final List<VoiceNote> voiceNotes;

  final bool
  coverImageNeedSync; // set this to true any time cover image is changed. The syncToBackend method will handle the rest.
  final bool
  fileNeedSync; // set this to true any time file is changed. The syncToBackend method will handle the rest.

  Content({
    this.id,
    required this.guid,
    required this.title,
    this.voiceNotes = const [],
    this.coverImage,
    required this.type,
    required this.metaData,
    required this.boardId,
    this.tags,
    this.content,
    this.drawing,
    this.file,
    required this.createdAt,
    required this.updatedAt,
    this.syncedAt,
    this.coverImageNeedSync = false,
    this.fileNeedSync = false,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'guid': guid,
    'title': title,
    'voice_notes': jsonEncode(voiceNotes.map((x) => x.toMap()).toList()),
    'cover_image': coverImage,
    'type': type.toString(),
    'meta_data': jsonEncode(metaData),
    'board_id': boardId,
    'tags': tags,
    'content': content,
    'drawing': drawing,
    'file': file,
    'created_at': createdAt,
    'updated_at': updatedAt,
    'synced_at': syncedAt,
    'cover_image_need_sync': getIntFromBool(coverImageNeedSync),
    'file_need_sync': getIntFromBool(fileNeedSync),
  };

  factory Content.fromMap(Map<String, dynamic> map) {
    List<VoiceNote> parseVoiceNotes(dynamic voiceNotesData) {
      if (voiceNotesData == null) return [];

      String jsonString;
      if (voiceNotesData is Uint8List) {
        // Convert Uint8List to String
        jsonString = utf8.decode(voiceNotesData);
      } else if (voiceNotesData is String) {
        jsonString = voiceNotesData;
      } else {
        return [];
      }

      try {
        final List<dynamic> decoded = jsonDecode(jsonString);
        return decoded
            .map((x) => VoiceNote.fromMap(Map<String, dynamic>.from(x)))
            .toList();
      } catch (e) {
        debugPrint('Error parsing voice notes: $e');
        return [];
      }
    }

    return Content(
      id: map['id'],
      guid: map['guid'],
      voiceNotes: parseVoiceNotes(map['voice_notes']),
      title: map['title'],
      coverImage: map['cover_image'],
      type: stringToAppContentType(map['type']),
      metaData: jsonDecode(map['meta_data']),
      boardId: map['board_id'],
      tags: map['tags'],
      content: map['content'],
      drawing: map['drawing'],
      file: map['file'],
      createdAt: map['created_at'],
      updatedAt: map['updated_at'],
      syncedAt: map['synced_at'],
      coverImageNeedSync: getBoolFromInt(map['cover_image_need_sync']),
      fileNeedSync: getBoolFromInt(map['file_need_sync']),
    );
  }

  Content getUpdatedContent({
    String? title,
    String? coverImage,
    String? content,
    String? drawing,
    String? file,
    List<VoiceNote>? voiceNotes,
    int? updatedAt,
    int? syncedAt,
    bool? coverImageNeedSync,
    bool? fileNeedSync,
  }) {
    return Content(
      id: id,
      guid: guid,
      title: title ?? this.title,
      coverImage: coverImage ?? this.coverImage,
      type: type,
      metaData: metaData,
      boardId: boardId,
      tags: tags,
      content: content ?? this.content,
      drawing: drawing ?? this.drawing,
      file: file ?? this.file,
      voiceNotes: voiceNotes ?? this.voiceNotes,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncedAt: syncedAt ?? this.syncedAt,
      coverImageNeedSync: coverImageNeedSync ?? this.coverImageNeedSync,
      fileNeedSync: fileNeedSync ?? this.fileNeedSync,
    );
  }

  Future<Board> getBoard() async {
    final dbHelper = DatabaseHelper.instance;
    final board = await dbHelper.getBoard(boardId);
    return board;
  }

  // TODO: Thompson correct this. When you save the image/file to storage, extract it back here
  File? getCoverImageFile() {
    if (coverImage == null || coverImage == "") {
      return null;
    }
    return File(coverImage!);
  }

  File? getFile() {
    if (file == null || file == "") {
      return null;
    }
    return File(file!);
  }

  syncToBackend(
    ApiServiceProvider apiServiceProvider, {
    String? boardGuid,
  }) async {
    Map<String, File> files = {};

    if (coverImageNeedSync) {
      File? coverImageFile = getCoverImageFile();

      if (coverImageFile != null) {
        files = {'cover_image_file': coverImageFile};
      }
    }

    if (fileNeedSync) {
      File? file = getFile();

      if (file != null) {
        files.addAll({'file_file': file});
      }
    }

    if (boardGuid == null) {
      final board = await getBoard();
      boardGuid = board.guid;
    }
    //TODO add synching voice notes
    final body = FormDataRequest.post(
      ApiEndpoints.contentSync,
      body: {
        'guid': guid,
        'board_guid': boardGuid,
        'title': title,
        'cover_image': coverImage,
        'type': type,
        'meta_data': metaData,
        'tags': tags,
        'content': content,
        'drawing': drawing,
        'file': file,
        'synced_at': syncedAt,
      },
      files: files,
    );

    final response = await apiServiceProvider.apiService.sendFormDataRequest(
      body,
    );

    //Makes coverImageNeedSync and fileNeedSync false after sync
    final newContent = getUpdatedContent(
      coverImageNeedSync: false,
      fileNeedSync: false,
    );
    DatabaseHelper.instance.updateContent(newContent);

    return response;
  }
}
