import 'package:navinotes/packages.dart';

List<String> noteTemplatesSections = [
  'All',
  'Basic',
  'Study',
  'Planning',
  'Specialized',
  'Report',
];

class BoardTemplate {
  final String title;
  final String body;
  final String description;
  final String image;
  final String? route;
  final bool isPopular;
  BoardTemplate({
    required this.title,
    required this.body,
    this.description = 'Concrete description will be here',
    required this.image,
     this.route,
    this.isPopular = false,
  });
}

BoardTemplate noteTemplateBlank = BoardTemplate(
  body: 'Clean slate for writing',
  image: Images.noteTemplateBlank,
  title: 'Blank Page',
  route: Routes.blankNote
);

BoardTemplate noteTemplateCornell = BoardTemplate(
  body: 'Structured note-taking',
  image: Images.noteTemplateCornell,
  title: 'Cornell Notes',
  isPopular: true,
  description:
      'Structured note-taking method with dedicated sections for main notes, cues/questions, and summary.',
);

BoardTemplate noteTemplateLined = BoardTemplate(
  body: 'Classic lined surface',
  image: Images.noteTemplateLined,
  title: 'Lined Paper',
);

BoardTemplate noteTemplateSquared = BoardTemplate(
  body: 'Grid for diagrams',
  image: Images.noteTemplateSquared,
  title: 'Squared Paper',
);

BoardTemplate noteTemplateDotted = BoardTemplate(
  body: 'Dot grid for flexible layout',
  image: Images.noteTemplateDotted,
  title: 'Dotted Paper',
);

BoardTemplate noteTemplateKanban = BoardTemplate(
  body: 'Visual workflow manager',
  isPopular: true,
  image: Images.noteTemplateKanban,
  title: 'Kanban Board',
);

BoardTemplate noteTemplateTimeline = BoardTemplate(
  body: 'Chronological planner',
  image: Images.noteTemplateTimeline,
  title: 'Timeline',
);

BoardTemplate noteTemplateCompareContrast = BoardTemplate(
  body: 'Side-by-side comparison',
  image: Images.noteTemplateCompareContrast,
  title: 'Compare & Contrast',
);

BoardTemplate noteTemplateAi = BoardTemplate(
  body: 'AI-generated study cards',
  image: Images.noteTemplateAi,
  title: 'AI-Generated Flashcards',
);

BoardTemplate noteTemplateFlashcards = BoardTemplate(
  body: 'Question and answer cards',
  image: Images.noteTemplateFlashcards,
  title: 'Flashcards',
  isPopular: true,
);

BoardTemplate noteTemplateLapReport = BoardTemplate(
  body: 'Scientific experiment doc',
  image: Images.noteTemplateLapReport,
  title: 'Lab Report Format',
);

BoardTemplate noteTemplateApa = BoardTemplate(
  body: 'Text analysis framework',
  image: Images.noteTemplateApa,
  title: 'APA Format Guide',
);

BoardTemplate noteTemplateResearch = BoardTemplate(
  body: 'Humanities formatting',
  image: Images.noteTemplateResearch,
  title: 'MLA Research Format',
);

BoardTemplate noteTemplateComparative = BoardTemplate(
  body: 'Multi-subject comparison',
  image: Images.noteTemplateComparative,
  title: 'Comparative Analysis',
);

BoardTemplate noteTemplateCritical = BoardTemplate(
  body: 'Evaluative framework',
  image: Images.noteTemplateCritical,
  title: 'Critical Review',
);

BoardTemplate noteTemplateThesis = BoardTemplate(
  body: 'Argument construction',
  image: Images.noteTemplateThesis,
  title: 'Thesis Development',
);

// List<BoardTemplate> noteTemplates = [
//   noteTemplateBlank,
//   noteTemplateCornell,
//   noteTemplateLined,
//   noteTemplateSquared,
//   noteTemplateDotted,
//   noteTemplateKanban,
//   noteTemplateTimeline,
//   noteTemplateCompareContrast,
//   noteTemplateAi,
//   noteTemplateFlashcards,
//   noteTemplateLapReport,
//   noteTemplateApa,
//   noteTemplateResearch,
//   noteTemplateComparative,
//   noteTemplateCritical,
//   noteTemplateThesis,
// ];
