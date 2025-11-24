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

Map<String, String> authFooterLongTexts = {
  'Privacy Policy':
      'This is a long placeholder privacy policy for NaviNotes. It is intentionally verbose so that you can see how the scrollable dialog behaves with a large amount of content. In a real implementation, this section would explain in clear, student-friendly language how your data is collected, stored, and processed.\n\n'
      'As you scroll through this text, imagine sections that describe what information is captured when you create an account, how study notes and uploaded syllabi are stored, and how integrations like calendar or marketplace features interact with your data. Each section would use headings, paragraphs, and short sentences so that even on small screens, everything remains readable.\n\n'
      'The purpose of this dummy text is not to be legally correct, but to simulate the experience of reading a full policy inside the app. This means it needs to run long enough to require multiple scroll actions. You might also include explanations about third-party providers, analytics, and how to contact support if a student wants to request deletion of their information.\n\n'
      'Finally, a real privacy policy would mention data retention, security measures, and links to external documentation. For now, this text simply repeats that it is long on purpose so that you can visually confirm that the dialog remains smooth and usable even with dense content. Keep scrolling to verify that the scroll view behaves correctly across platforms and screen sizes.\n\n'
      'By the time you reach the end of this placeholder, you should have seen the scrollbar move through several screens of content, demonstrating that the design works well for long-form legal or help documents.',
  'Terms':
      'These are long placeholder terms of use for NaviNotes. The goal is to emulate the length and structure of a real set of terms so that you can check how the dialog handles extensive copy.\n\n'
      'In a production version, this section would describe acceptable usage of the platform, limitations of liability, intellectual property ownership of notes and templates, payment or subscription rules, and any restrictions on account sharing. Each paragraph would be carefully written to be both student-friendly and precise enough to guide expectations.\n\n'
      'For testing purposes, we keep adding sentences that talk about how these terms might cover behavior in lecture halls, online classes, or study groups. You might specify that users are responsible for the content they upload, that harmful or illegal material is prohibited, and that the service may change or discontinue certain features over time.\n\n'
      'The dialog you are reading this in should allow you to scroll without jank, with the text respecting the app typography system. As you continue downward, imagine section headings like "Account Responsibilities", "Service Availability", and "Changes to These Terms". Even without explicit formatting, the length alone should help you evaluate readability and spacing.\n\n'
      'Because this is only a dummy block of text, it can also serve as a reminder to plug in the final legal copy later. Until then, you can use it to validate that long documents remain usable inside the constrained, scrollable dialog area.',
  'Help':
      'This is a placeholder Help & Support article for NaviNotes, designed to be long enough to test the scrolling behavior of the footer dialog. In the future, this could become a concise FAQ or onboarding guide that students can access directly from the authentication screen.\n\n'
      'A real help document might walk new users through creating their first board, importing a syllabus, organizing topics into timelines, and syncing due dates to an external calendar. It could also explain how to recover a password, manage subscription options, or contact support when something does not work as expected.\n\n'
      'For now, the focus is on length and readability. As you scroll through, pay attention to line spacing, font size, and how well the text adapts to different display sizes. The content continues with more descriptive sentences about imagining real screenshots, step-by-step walkthroughs, and tips for making the most of study sessions using flashcards, timelines, and mind maps.\n\n'
      'Additional sections could cover troubleshooting steps, such as what to do if an upload fails, how to refresh data when switching devices, or how to disconnect and reconnect third-party services like calendar integrations. Each of these topics contributes a few more paragraphs, extending the overall height of the document.\n\n'
      'By the time you reach this final paragraph, you should have scrolled through multiple screens of help text. That confirms that the dialog supports long-form guidance without overwhelming the layout, and that it remains a comfortable place to present onboarding or troubleshooting information to new users.',
};
