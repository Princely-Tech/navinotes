
class CourseInfo {
  final String? title;
  final String? code;
  final String? instructor;
  final String? semester;
  final String? semesterDuration;
  final String? schedule;
  final String? location;

  final String? officeHours; 
  final String? email; 
  final String? phone; 
  const CourseInfo({
    this.title,
    this.code,
    this.instructor,
    this.semester,
    this.semesterDuration,
    this.schedule,
    this.location,
    this.officeHours,
    this.email,
    this.phone,
  });

  // Convert a CourseInfo into a Map
  Map<String, dynamic> toMap() {
    return {
      'title': title ,
      'code': code,
      'instructor': instructor,
      'semester': semester,
      'semester_duration': semesterDuration,
      'schedule': schedule,
      'location': location,
      'office_hours': officeHours,
      'email': email,
      'phone': phone,
    };
  }


  // Create a CourseInfo from a Map
  factory CourseInfo.fromMap(Map<String, dynamic> map) {
    return CourseInfo(
      title: map['title'],
      code: map['code'],
      instructor: map['instructor'],
      semester: map['semester'],
      semesterDuration: map['semester_duration'],
      schedule: map['schedule'],
      location: map['location'],
      officeHours: map['office_hours'],
      email: map['email'],
      phone: map['phone'],
    );
  }


  @override
  String toString() {
    return 'CourseInfo(title: $title, code: $code, instructor: $instructor, semester: $semester, schedule: $schedule, location: $location, officeHours: $officeHours, email: $email, phone: $phone)';
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
