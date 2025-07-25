import 'package:navinotes/packages.dart';

class CourseInfo {
  final String? title;
  final String? code;
  final String? instructor;
  final String? semester;
  final String? schedule;
  final String? location;

  const CourseInfo({
    this.title,
    this.code,
    this.instructor,
    this.semester,
    this.schedule,
    this.location,
  });

  // Convert a CourseInfo into a Map
  Map<String, dynamic> toMap() {
    return {
      'title': title ,
      'code': code,
      'instructor': instructor,
      'semester': semester,
      'schedule': schedule,
      'location': location,
    };
  }

  // Create a CourseInfo from a Map
  factory CourseInfo.fromMap(Map<String, dynamic> map) {
    return CourseInfo(
      title: map['title'],
      code: map['code'],
      instructor: map['instructor'],
      semester: map['semester'],
      schedule: map['schedule'],
      location: map['location'],
    );
  }


  @override
  String toString() {
    return 'CourseInfo(title: $title, code: $code, instructor: $instructor, semester: $semester, schedule: $schedule, location: $location)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CourseInfo &&
        other.title == title &&
        other.code == code &&
        other.instructor == instructor &&
        other.semester == semester &&
        other.schedule == schedule &&
        other.location == location;
  }

  @override
  int get hashCode {
    return title.hashCode ^
        code.hashCode ^
        instructor.hashCode ^
        semester.hashCode ^
        schedule.hashCode ^
        location.hashCode;
  }
}
