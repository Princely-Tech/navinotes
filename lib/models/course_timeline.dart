class CourseTimeline {
  final String week;
  final String title;
  final String? description;
  final String? assignment;
  final String? due;

  CourseTimeline({
    required this.week,
    required this.title,
    this.description,
    this.assignment,
    this.due,
  });

  // Convert a CourseTimeline into a Map
  Map<String, dynamic> toMap() {
    return {
      'week': week,
      'title': title,
      'description': description,
      'assignment': assignment,
      'due': due,
    };
  }

  // Create a CourseTimeline from a Map
  factory CourseTimeline.fromMap(Map<String, dynamic> map) {
    return CourseTimeline(
      week: map['week']??'',
      title: map['title']??'',
      description: map['description']??'',
      assignment: map['assignment']??'',
      due: map['due']??'',
    );
  }

  /// Create a copy of this CourseTimeline with some fields replaced
  CourseTimeline copyWith({
    String? week,
    String? title,
    String? description,
    String? assignment,
    String? due,
  }) {
    return CourseTimeline(
      week: week ?? this.week,
      title: title ?? this.title,
      description: description ?? this.description,
      assignment: assignment ?? this.assignment,
      due: due ?? this.due,
    );
  }

  @override
  String toString() {
    return 'CourseTimeline(week: $week, title: $title, description: $description, assignment: $assignment, due: $due)';
  }
}
