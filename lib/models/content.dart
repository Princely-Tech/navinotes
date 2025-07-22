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

  final bool coverImageNeedSync; // set this to true any time cover image is changed. The syncToBackend method will handle the rest.
  final bool fileNeedSync; // set this to true any time file is changed. The syncToBackend method will handle the rest.

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
    this.coverImageNeedSync = false,
    this.fileNeedSync = false,
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
    'cover_image_need_sync': coverImageNeedSync,
    'file_need_sync': fileNeedSync,
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
    coverImageNeedSync: map['cover_image_need_sync']??false,
    fileNeedSync: map['file_need_sync']??false,
  );

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

  syncToBackend(ApiServiceProvider apiServiceProvider) async {
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

    final body = FormDataRequest.post(
      ApiEndpoints.contentSync,
      body: {
        'guid': guid,
        'title': title,
        'cover_image': coverImage,
        'type': type,
        'meta_data': metaData,
        'board_id': boardId,
        'tags': tags,
        'content': content,
        'file': file,
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
