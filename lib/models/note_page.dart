import 'package:navinotes/packages.dart';
import 'package:navinotes/models/page_format.dart';

/// Represents a single page within a note
class NotePage {
  final String id;
  final String noteId; // Reference to the parent Content
  final int pageNumber;
  final PageFormat format; // Page size and orientation
  final String? textContent; // Rich text content (Quill Delta JSON)
  final String? drawingData; // Drawing/sketch data (JSON)
  final List<VoiceNote> voiceNotes; // Voice recordings for this page
  final int createdAt;
  final int updatedAt;
  final bool hasContent;

  NotePage({
    String? id,
    required this.noteId,
    required this.pageNumber,
    this.format = PageFormat.defaultFormat,
    this.textContent,
    this.drawingData,
    this.voiceNotes = const [],
    required this.createdAt,
    required this.updatedAt,
    this.hasContent = false,
  }) : id = id ?? const Uuid().v4();

  NotePage copyWith({
    String? id,
    String? noteId,
    int? pageNumber,
    PageFormat? format,
    String? textContent,
    String? drawingData,
    List<VoiceNote>? voiceNotes,
    int? createdAt,
    int? updatedAt,
    bool? hasContent,
  }) {
    return NotePage(
      id: id ?? this.id,
      noteId: noteId ?? this.noteId,
      pageNumber: pageNumber ?? this.pageNumber,
      format: format ?? this.format,
      textContent: textContent ?? this.textContent,
      drawingData: drawingData ?? this.drawingData,
      voiceNotes: voiceNotes ?? this.voiceNotes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      hasContent: hasContent ?? this.hasContent,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'note_id': noteId,
      'page_number': pageNumber,
      'format': jsonEncode(format.toMap()),
      'text_content': textContent,
      'drawing_data': drawingData,
      'voice_notes': jsonEncode(voiceNotes.map((x) => x.toMap()).toList()),
      'created_at': createdAt,
      'updated_at': updatedAt,
      'has_content': hasContent ? 1 : 0,
    };
  }

  factory NotePage.fromMap(Map<String, dynamic> map) {
    List<VoiceNote> parseVoiceNotes(dynamic voiceNotesData) {
      if (voiceNotesData == null) return [];

      String jsonString;
      if (voiceNotesData is Uint8List) {
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

    PageFormat parseFormat(dynamic formatData) {
      if (formatData == null) return PageFormat.defaultFormat;
      
      try {
        if (formatData is String) {
          final formatMap = jsonDecode(formatData) as Map<String, dynamic>;
          return PageFormat.fromMap(formatMap);
        } else if (formatData is Map<String, dynamic>) {
          return PageFormat.fromMap(formatData);
        }
      } catch (e) {
        debugPrint('Error parsing page format: $e');
      }
      
      return PageFormat.defaultFormat;
    }

    return NotePage(
      id: map['id'] ?? '',
      noteId: map['note_id'] ?? '',
      pageNumber: map['page_number'] ?? 0,
      format: parseFormat(map['format']),
      textContent: map['text_content'],
      drawingData: map['drawing_data'],
      voiceNotes: parseVoiceNotes(map['voice_notes']),
      createdAt: map['created_at'] ?? 0,
      updatedAt: map['updated_at'] ?? 0,
      hasContent: (map['has_content'] ?? 0) == 1,
    );
  }

  /// Check if this page has any content
  bool get isEmpty {
    return (textContent == null || textContent!.isEmpty) &&
        (drawingData == null || drawingData!.isEmpty) &&
        voiceNotes.isEmpty;
  }

  /// Get updated page with new content
  NotePage getUpdatedPage({
    PageFormat? format,
    String? textContent,
    String? drawingData,
    List<VoiceNote>? voiceNotes,
    int? updatedAt,
    bool? hasContent,
  }) {
    return copyWith(
      format: format,
      textContent: textContent,
      drawingData: drawingData,
      voiceNotes: voiceNotes,
      updatedAt: updatedAt ?? generateUnixTimestamp(),
      hasContent: hasContent ?? !isEmpty,
    );
  }
}
