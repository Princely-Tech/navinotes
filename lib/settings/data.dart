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

final Map<String, dynamic> aiFlashcardContent = {
  "response": {
    "distribution": "2 Easy, 2 Medium, 1 Hard",
    "coverage": ">=85% of key concepts",
    "confidence_level": "90%",
    "cards": [
      {
        "question": "<p>What is the primary function of a computer?</p>",
        "answer":
            "<p>To automatically carry out sequences of arithmetic or logical operations.</p>",
        "difficulty": "Easy",
      },
      {
        "question":
            "<p>What is the term for a group of computers linked and functioning together?</p>",
        "answer": "<p>A computer network or computer cluster.</p>",
        "difficulty": "Medium",
      },
      {
        "question":
            "<p>Who were often hired as human computers in the latter part of the 20th century?</p>",
        "answer":
            "<p>Women, as they could be paid less than their male counterparts.</p>",
        "difficulty": "Medium",
      },
      {
        "question":
            "<p>What is the name of the law that notes the rapid pace of transistor counts in computers?</p>",
        "answer": "<p>Moore's law.</p>",
        "difficulty": "Easy",
      },
      {
        "question":
            "<p>What are the primary components of a modern computer?</p>",
        "answer":
            "<p>A processing element, computer memory, and peripheral devices.</p>",
        "difficulty": "Hard",
      },
    ],
  },
};
