import 'package:navinotes/packages.dart';

final contentFileAllowedExtensions = [
  'pdf',
  'doc',
  'docx',
  'ppt',
  'pptx',
  'xls',
  'xlsx',
  'txt',
  'jpg',
  'jpeg',
  'png',
  'gif',
];

class Content {
  final String id;
  final AppContentType type; // note, mindmap, syllabus, etc.
  final Map<String, dynamic> metaData; // JSON as Map
  final String boardId;
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

  // Mind Map Node specific fields
  final double? mindMapX; // X position on mind map canvas
  final double? mindMapY; // Y position on mind map canvas
  final String? connectedContentIds; // JSON array of connected content IDs
  final String? nodeColor; // Hex color string for node
  final String? nodeShape; // Shape enum as string
  final double? nodeWidth; // Node width
  final double? nodeHeight; // Node height

  Content({
    String? id,
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
    // Mind Map Node fields
    this.mindMapX,
    this.mindMapY,
    this.connectedContentIds,
    this.nodeColor,
    this.nodeShape,
    this.nodeWidth,
    this.nodeHeight,
  }) : id = id ?? const Uuid().v4();

  Map<String, dynamic> toMap() => {
    'id': id,
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
    // Mind Map Node fields
    'mind_map_x': mindMapX,
    'mind_map_y': mindMapY,
    'connected_content_ids': connectedContentIds,
    'node_color': nodeColor,
    'node_shape': nodeShape,
    'node_width': nodeWidth,
    'node_height': nodeHeight,
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
      // Mind Map Node fields
      mindMapX: map['mind_map_x']?.toDouble(),
      mindMapY: map['mind_map_y']?.toDouble(),
      connectedContentIds: map['connected_content_ids'],
      nodeColor: map['node_color'],
      nodeShape: map['node_shape'],
      nodeWidth: map['node_width']?.toDouble(),
      nodeHeight: map['node_height']?.toDouble(),
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
    // Mind Map Node fields
    double? mindMapX,
    double? mindMapY,
    String? connectedContentIds,
    String? nodeColor,
    String? nodeShape,
    double? nodeWidth,
    double? nodeHeight,
  }) {
    return Content(
      id: id,
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
      // Mind Map Node fields
      mindMapX: mindMapX ?? this.mindMapX,
      mindMapY: mindMapY ?? this.mindMapY,
      connectedContentIds: connectedContentIds ?? this.connectedContentIds,
      nodeColor: nodeColor ?? this.nodeColor,
      nodeShape: nodeShape ?? this.nodeShape,
      nodeWidth: nodeWidth ?? this.nodeWidth,
      nodeHeight: nodeHeight ?? this.nodeHeight,
    );
  }

  Content getUpdatedContentWithMeta({
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
    Map<String, dynamic>? metaData,
    // Mind Map Node fields
    double? mindMapX,
    double? mindMapY,
    String? connectedContentIds,
    String? nodeColor,
    String? nodeShape,
    double? nodeWidth,
    double? nodeHeight,
  }) {
    return Content(
      id: id,
      title: title ?? this.title,
      coverImage: coverImage ?? this.coverImage,
      type: type,
      metaData: metaData ?? this.metaData,
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
      // Mind Map Node fields
      mindMapX: mindMapX ?? this.mindMapX,
      mindMapY: mindMapY ?? this.mindMapY,
      connectedContentIds: connectedContentIds ?? this.connectedContentIds,
      nodeColor: nodeColor ?? this.nodeColor,
      nodeShape: nodeShape ?? this.nodeShape,
      nodeWidth: nodeWidth ?? this.nodeWidth,
      nodeHeight: nodeHeight ?? this.nodeHeight,
    );
  }

  Future<bool>? updateTitle({String? newTitle}) {
    try {
      Content updatedContent = getUpdatedContent(title: newTitle);
      return DatabaseHelper.instance.updateContent(updatedContent);
    } catch (err) {
      debugPrint('Error updating content title: $err');
      return null;
    }
  }

  Future<int>? getCardsCount() {
    if (type != AppContentType.flashcardDeck) {
      debugPrint('Getting deck cards count for deck $id');
      try {
        return DatabaseHelper.instance.getDeckCardsCount(id);
      } catch (err) {
        debugPrint('Error getting deck cards count: $err');
        return null;
      }
    }
    return null;
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
      boardGuid = board.id;
    }

    final body = FormDataRequest.post(
      ApiEndpoints.contentSync,
      body: {
        'id': id,
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

  getMeta(key) {
    return metaData[key];
  }

  // Mind Map Node helper methods

  /// Check if this content is a mind map node
  bool get isMindMapNode => type == AppContentType.mindmapNode;

  /// Get position as Offset for mind map nodes
  Offset? get mindMapPosition {
    if (mindMapX != null && mindMapY != null) {
      return Offset(mindMapX!, mindMapY!);
    }
    return null;
  }

  /// Get connected content IDs as a list
  List<String> get connectedContentIdsList {
    if (connectedContentIds == null || connectedContentIds!.isEmpty) {
      return [];
    }
    try {
      final List<dynamic> decoded = jsonDecode(connectedContentIds!);
      return decoded.cast<String>();
    } catch (e) {
      debugPrint('Error parsing connected content IDs: $e');
      return [];
    }
  }

  /// Update mind map position
  Content updateMindMapPosition(Offset position) {
    return getUpdatedContent(
      mindMapX: position.dx,
      mindMapY: position.dy,
      updatedAt: DateTime.now().millisecondsSinceEpoch,
    );
  }

  /// Update connected content IDs
  Content updateConnectedContentIds(List<String> contentIds) {
    return getUpdatedContent(
      connectedContentIds: jsonEncode(contentIds),
      updatedAt: DateTime.now().millisecondsSinceEpoch,
    );
  }

  /// Add a connection to another content
  Content addConnection(String contentId) {
    final currentConnections = connectedContentIdsList;
    if (!currentConnections.contains(contentId)) {
      currentConnections.add(contentId);
      return updateConnectedContentIds(currentConnections);
    }
    return this;
  }

  /// Remove a connection to another content
  Content removeConnection(String contentId) {
    final currentConnections = connectedContentIdsList;
    currentConnections.remove(contentId);
    return updateConnectedContentIds(currentConnections);
  }
}
