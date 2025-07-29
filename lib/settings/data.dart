import 'package:navinotes/packages.dart';

CourseInfo exampleCourseInfo = CourseInfo(
  title: "Mobile App Development",
  code: "CSC402",
  instructor: "Dr. Ada Okafor",
  semester: "2nd Semester 2024/2025",
  schedule: "Mon & Wed, 10:00 AM - 12:00 PM",
  location: "ICT Lab 2, Block B",
);

List<CourseTimeline> exampleTimeline = [
  CourseTimeline(
    week: "Week 1",
    title: "Introduction to Mobile Apps",
    description:
        "Overview of mobile platforms, trends, and development environments.",
    assignment: "Write a summary of mobile OS differences.",
    due: "2025-08-03",
  ),
  CourseTimeline(
    week: "Week 2",
    title: "Flutter & Dart Basics",
    description: "Setting up Flutter and exploring Dart syntax.",
    assignment: "Create a simple Flutter counter app.",
    due: "2025-08-10",
  ),
  CourseTimeline(
    week: "Week 3",
    title: "State Management",
    description: "Understanding stateful widgets and setState.",
    assignment: "Implement a to-do list with add/remove features.",
    due: "2025-08-17",
  ),
  CourseTimeline(
    week: "Week 4",
    title: "Navigation and Routing",
    description: "Using Navigator and creating multi-page apps.",
    assignment: "Build an app with 3 navigable pages.",
    due: "2025-08-24",
  ),
  CourseTimeline(
    week: "Week 5",
    title: "APIs and Backend Integration",
    description: "Fetching data using HTTP and handling JSON.",
    assignment: "Consume a public API and display data.",
    due: "2025-08-31",
  ),
];
