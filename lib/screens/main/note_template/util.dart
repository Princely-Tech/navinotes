import 'package:navinotes/packages.dart';

List<String> noteTemplatesSections = [
  'All',
  'Basic',
  'Study',
  'Planning',
  'Specialized',
  'Report',
];

class BoardNoteTemplate {
  final String title;
  final String body;
  final String description;
  final String image;
  final String? route;
  final bool isPopular;
  BoardNoteTemplate({
    required this.title,
    required this.body,
    this.description = 'Concrete description will be here',
    required this.image,
    this.route,
    this.isPopular = false,
  });
}

BoardNoteTemplate noteTemplateBlank = BoardNoteTemplate(
  body: 'Clean slate for writing',
  image: Images.noteTemplateBlank,
  title: 'Blank Page',
);

BoardNoteTemplate noteTemplateCornell = BoardNoteTemplate(
  body: 'Structured note-taking',
  image: Images.noteTemplateCornell,
  title: 'Cornell Notes',
  isPopular: true,
  description:
      'Structured note-taking method with dedicated sections for main notes, cues/questions, and summary.',
);

BoardNoteTemplate noteTemplateLined = BoardNoteTemplate(
  body: 'Classic lined surface',
  image: Images.noteTemplateLined,
  title: 'Lined Paper',
);

BoardNoteTemplate noteTemplateSquared = BoardNoteTemplate(
  body: 'Grid for diagrams',
  image: Images.noteTemplateSquared,
  title: 'Squared Paper',
);

BoardNoteTemplate noteTemplateDotted = BoardNoteTemplate(
  body: 'Dot grid for flexible layout',
  image: Images.noteTemplateDotted,
  title: 'Dotted Paper',
);

BoardNoteTemplate noteTemplateKanban = BoardNoteTemplate(
  body: 'Visual workflow manager',
  isPopular: true,
  image: Images.noteTemplateKanban,
  title: 'Kanban Board',
  route: Routes.noteKanban,
);

BoardNoteTemplate noteTemplateTimeline = BoardNoteTemplate(
  body: 'Chronological planner',
  image: Images.noteTemplateTimeline,
  title: 'Timeline',
  route: Routes.noteTimeline,
);

BoardNoteTemplate noteTemplateCompareContrast = BoardNoteTemplate(
  body: 'Side-by-side comparison',
  image: Images.noteTemplateCompareContrast,
  title: 'Compare & Contrast',
  route: Routes.noteCompareContrast,
);

BoardNoteTemplate noteTemplateAi = BoardNoteTemplate(
  body: 'AI-generated study cards',
  image: Images.noteTemplateAi,
  title: 'AI-Generated Flashcards',
  route: '',
);

BoardNoteTemplate noteTemplateFlashcards = BoardNoteTemplate(
  body: 'Question and answer cards',
  image: Images.noteTemplateFlashcards,
  title: 'Flashcards',
  route: Routes.flashCards,
  isPopular: true,
);

BoardNoteTemplate noteTemplateLapReport = BoardNoteTemplate(
  body: 'Scientific experiment doc',
  image: Images.noteTemplateLapReport,
  title: 'Lab Report Format',
  route: Routes.noteLabReport,
);

BoardNoteTemplate noteTemplateApa = BoardNoteTemplate(
  body: 'Text analysis framework',
  image: Images.noteTemplateApa,
  title: 'APA Format Guide',
);

BoardNoteTemplate noteTemplateResearch = BoardNoteTemplate(
  body: 'Humanities formatting',
  image: Images.noteTemplateResearch,
  title: 'MLA Research Format',
  route: '',
);

BoardNoteTemplate noteTemplateComparative = BoardNoteTemplate(
  body: 'Multi-subject comparison',
  image: Images.noteTemplateComparative,
  title: 'Comparative Analysis',
  route: '',
);

BoardNoteTemplate noteTemplateCritical = BoardNoteTemplate(
  body: 'Evaluative framework',
  image: Images.noteTemplateCritical,
  title: 'Critical Review',
  route: '',
);

BoardNoteTemplate noteTemplateThesis = BoardNoteTemplate(
  body: 'Argument construction',
  image: Images.noteTemplateThesis,
  title: 'Thesis Development',
  route: '',
);
