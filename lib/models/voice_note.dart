import 'package:navinotes/packages.dart';

class VoiceNote {
  final String name;
  final int createdAt; // Unix timestamp
  final String file;
  final Duration? duration; // Audio duration in milliseconds
  final int fileSize; // File size in bytes

  VoiceNote({
    required this.name,
    required this.createdAt,
    required this.file,
    this.duration,
    required this.fileSize,
  });

  Map<String, dynamic> toMap() => {
    'name': name,
    'created_at': createdAt,
    'file': file,
    'duration': duration?.inMilliseconds,
    'file_size': fileSize,
  };

  factory VoiceNote.fromMap(Map<String, dynamic> map) => VoiceNote(
    name: map['name'],
    createdAt: map['created_at'],
    file: map['file'],
    duration:
        map['duration'] != null
            ? Duration(milliseconds: map['duration'] as int)
            : null,
    fileSize: map['file_size'] as int? ?? 0,
  );

  // Helper method to format duration as MM:SS
  String get formattedDuration {
    if (duration == null) return '--:--';
    final minutes = duration!.inMinutes
        .remainder(60)
        .toString()
        .padLeft(2, '0');
    final seconds = (duration!.inSeconds.remainder(
      60,
    )).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  // Helper method to format file size
  String get formattedFileSize {
    if (fileSize <= 0) return '0 B';
    const units = ['B', 'KB', 'MB', 'GB'];
    int digitGroups = (log(fileSize) / log(1024)).floor();
    return '${(fileSize / pow(1024, digitGroups)).toStringAsFixed(1)} ${units[digitGroups]}';
  }
}
