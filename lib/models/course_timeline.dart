class CourseTimeline {
  final String week;
  final String? date;
  final String title;
  final String? description;
  final String? assignment;
  final String? due;

  CourseTimeline({
    required this.week,
    this.date,
    required this.title,
    this.description,
    this.assignment,
    this.due,
  });

  // Convert a CourseTimeline into a Map
  Map<String, dynamic> toMap() {
    return {
      'week': week,
      'date': date,
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
      date: map['date']??'',
      title: map['title']??'',
      description: map['description']??'',
      assignment: map['assignment']??'',
      due: map['due']??'',
    );
  }

  /// Create a copy of this CourseTimeline with some fields replaced
  CourseTimeline copyWith({
    String? week,
    String? date,
    String? title,
    String? description,
    String? assignment,
    String? due,
  }) {
    return CourseTimeline(
      week: week ?? this.week,
      date: date ?? this.date,
      title: title ?? this.title,
      description: description ?? this.description,
      assignment: assignment ?? this.assignment,
      due: due ?? this.due,
    );
  }

  @override
  String toString() {
    return 'CourseTimeline(week: $week, date: $date, title: $title, description: $description, assignment: $assignment, due: $due)';
  }
}
