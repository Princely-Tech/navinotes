import 'package:navinotes/packages.dart';

class CourseTimeline {
  int? id;
  final int boardId;
  final String week;
  final String title;
  final String description;
  final String assignment;
  final String dueDate;
  final int createdAt;
  final int updatedAt;
  final int? syncedAt;

  CourseTimeline({
    this.id,
    required this.boardId,
    required this.week,
    required this.title,
    required this.description,
    required this.assignment,
    required this.dueDate,
    required this.createdAt,
    required this.updatedAt,
    this.syncedAt,
  });

  // Convert a CourseTimeline into a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'board_id': boardId,
      'week': week,
      'title': title,
      'description': description,
      'assignment': assignment,
      'due_date': dueDate,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'synced_at': syncedAt,
    };
  }

  // Create a CourseTimeline from a Map
  factory CourseTimeline.fromMap(Map<String, dynamic> map) {
    return CourseTimeline(
      id: map['id'],
      boardId: map['board_id'],
      week: map['week'],
      title: map['title'],
      description: map['description'],
      assignment: map['assignment'],
      dueDate: map['due_date'],
      createdAt: map['created_at'],
      updatedAt: map['updated_at'],
      syncedAt: map['synced_at'],
    );
  }

  // Create a copy of the CourseTimeline with some fields updated
  CourseTimeline copyWith({
    int? id,
    int? boardId,
    String? week,
    String? title,
    String? description,
    String? assignment,
    String? dueDate,
    int? createdAt,
    int? updatedAt,
    int? syncedAt,
  }) {
    return CourseTimeline(
      id: id ?? this.id,
      boardId: boardId ?? this.boardId,
      week: week ?? this.week,
      title: title ?? this.title,
      description: description ?? this.description,
      assignment: assignment ?? this.assignment,
      dueDate: dueDate ?? this.dueDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncedAt: syncedAt ?? this.syncedAt,
    );
  }

  @override
  String toString() {
    return 'CourseTimeline(id: $id, boardId: $boardId, week: $week, title: $title, description: $description, assignment: $assignment, dueDate: $dueDate)';
  }
}
