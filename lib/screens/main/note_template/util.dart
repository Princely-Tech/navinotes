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
  final NoteTemplateType type;
  final String body;
  final String description;
  final String image;
  final String? route;
  final bool isPopular;
  final List<String> bestFor;
  BoardNoteTemplate({
    required this.type,
    required this.body,
    this.description = '',
    required this.image,
    this.route,
    this.isPopular = false,
    this.bestFor = const [],
  });
}

NoteTemplateType getNoteTemplateTypeFromString(String input) {
  return NoteTemplateType.values.firstWhere(
    (e) => e.toString() == input,
    orElse: () => throw 'Invalid type: $input',
  );
}

BoardNoteTemplate getNoteTemplateFromString(String input) {
  NoteTemplateType type = getNoteTemplateTypeFromString(input);
  switch (type) {
    case NoteTemplateType.blank:
      return noteTemplateBlank;
    case NoteTemplateType.cornell:
      return noteTemplateCornell;
    case NoteTemplateType.lined:
      return noteTemplateLined;
    case NoteTemplateType.squared:
      return noteTemplateSquared;
    case NoteTemplateType.dotted:
      return noteTemplateDotted;
    case NoteTemplateType.kanban:
      return noteTemplateKanban;
    case NoteTemplateType.timeline:
      return noteTemplateTimeline;
    case NoteTemplateType.compareContrast:
      return noteTemplateCompareContrast;
    case NoteTemplateType.aiFlashCards:
      return noteTemplateAi;
    case NoteTemplateType.flashcards:
      return noteTemplateFlashCards;
    case NoteTemplateType.labReport:
      return noteTemplateLapReport;
    case NoteTemplateType.apaFormat:
      return noteTemplateApa;
    case NoteTemplateType.mlaResearch:
      return noteTemplateResearch;
    case NoteTemplateType.comparativeAnalysis:
      return noteTemplateComparative;
    case NoteTemplateType.criticalReview:
      return noteTemplateCritical;
    case NoteTemplateType.thesisDevelopment:
      return noteTemplateThesis;
  }
}

BoardNoteTemplate noteTemplateBlank = BoardNoteTemplate(
  type: NoteTemplateType.blank,
  body: 'Clean slate for writing',
  image: Images.noteTemplateBlank,
  description: 'Start fresh with no predefined structure.',
  bestFor: [
    'Freeform brainstorming',
    'Sketching diagrams',
    'Mind mapping',
    'Creative writing',
    'Unstructured notes',
    'Personal journaling',
  ],
);

BoardNoteTemplate noteTemplateCornell = BoardNoteTemplate(
  type: NoteTemplateType.cornell,
  body: 'Structured note-taking',
  image: Images.noteTemplateCornell,
  isPopular: true,
  description:
      'Structured note-taking method with dedicated sections for main notes, cues/questions, and summary.',
  bestFor: [
    'Lecture notes and classroom learning',
    'Active recall and study preparation',
    'Organizing complex information',
    'Creating effective study guides',
  ],
);

BoardNoteTemplate noteTemplateLined = BoardNoteTemplate(
  type: NoteTemplateType.lined,
  body: 'Classic lined surface',
  image: Images.noteTemplateLined,
  description: 'Perfect for essays, journaling, and general writing.',
  bestFor: [
    'Essay writing',
    'Daily journaling',
    'Taking meeting notes',
    'Writing letters',
    'Story drafts',
  ],
);

BoardNoteTemplate noteTemplateSquared = BoardNoteTemplate(
  type: NoteTemplateType.squared,
  body: 'Grid for diagrams',
  image: Images.noteTemplateSquared,
  description: 'Ideal for charts, graphs, and structured layouts.',
  bestFor: [
    'Math problems',
    'Engineering diagrams',
    'Data plotting',
    'Drawing graphs',
    'Design sketches',
  ],
);

BoardNoteTemplate noteTemplateDotted = BoardNoteTemplate(
  type: NoteTemplateType.dotted,
  body: 'Dot grid for flexible layout',
  image: Images.noteTemplateDotted,
  description: 'Balance between freedom and structure for creative notes.',
  bestFor: [
    'Bullet journaling',
    'Sketch notes',
    'Creative layouts',
    'Design wireframes',
    'Hybrid writing and drawing',
  ],
);

BoardNoteTemplate noteTemplateKanban = BoardNoteTemplate(
  type: NoteTemplateType.kanban,
  body: 'Visual workflow manager',
  isPopular: true,
  image: Images.noteTemplateKanban,
  route: Routes.noteKanban,
  description: 'Organize tasks visually with columns and cards.',
  bestFor: [
    'Project management',
    'Tracking personal goals',
    'Team collaboration',
    'Agile workflows',
    'Task prioritization',
  ],
);

BoardNoteTemplate noteTemplateTimeline = BoardNoteTemplate(
  type: NoteTemplateType.timeline,
  body: 'Chronological planner',
  image: Images.noteTemplateTimeline,
  route: Routes.noteTimeline,
  description: 'Track events and milestones over time.',
  bestFor: [
    'History notes',
    'Project timelines',
    'Event planning',
    'Research tracking',
    'Personal milestones',
  ],
);

BoardNoteTemplate noteTemplateCompareContrast = BoardNoteTemplate(
  type: NoteTemplateType.compareContrast,
  body: 'Side-by-side comparison',
  image: Images.noteTemplateCompareContrast,
  route: Routes.noteCompareContrast,
  description: 'Easily evaluate similarities and differences.',
  bestFor: [
    'Pros and cons lists',
    'Decision making',
    'Comparing theories',
    'Evaluating products',
    'Analyzing characters',
  ],
);

BoardNoteTemplate noteTemplateAi = BoardNoteTemplate(
  type: NoteTemplateType.aiFlashCards,
  body: 'AI-generated study cards',
  image: Images.noteTemplateAi,
  route: '',
  description: 'Quickly create smart flashcards with AI assistance.',
  bestFor: [
    'Exam preparation',
    'Language learning',
    'Quick knowledge testing',
    'Spaced repetition',
    'Generating study aids fast',
  ],
);

BoardNoteTemplate noteTemplateFlashCards = BoardNoteTemplate(
  type: NoteTemplateType.flashcards,
  body: 'Question and answer cards',
  image: Images.noteTemplateFlashCards,
  route: Routes.flashCards,
  isPopular: true,
  description: 'Study effectively with Q&A formatted cards.',
  bestFor: [
    'Vocabulary practice',
    'Studying key concepts',
    'Memorizing facts',
    'Quiz preparation',
    'Self-testing',
  ],
);

BoardNoteTemplate noteTemplateLapReport = BoardNoteTemplate(
  type: NoteTemplateType.labReport,
  body: 'Scientific experiment doc',
  image: Images.noteTemplateLapReport,
  route: Routes.noteLabReport,
  description: 'Document hypotheses, methods, and experiment results.',
  bestFor: [
    'Science classes',
    'Lab experiments',
    'Recording observations',
    'Presenting results',
    'Formal reports',
  ],
);

BoardNoteTemplate noteTemplateApa = BoardNoteTemplate(
  type: NoteTemplateType.apaFormat,
  body: 'Text analysis framework',
  image: Images.noteTemplateApa,
  description: 'Follow APA style guidelines for academic writing.',
  bestFor: [
    'Psychology papers',
    'Research articles',
    'Academic essays',
    'Professional publications',
    'Structured analysis',
  ],
);

BoardNoteTemplate noteTemplateResearch = BoardNoteTemplate(
  type: NoteTemplateType.mlaResearch,
  body: 'Humanities formatting',
  image: Images.noteTemplateResearch,
  route: '',
  description: 'Use MLA standards for research in humanities.',
  bestFor: [
    'Literature analysis',
    'History papers',
    'Humanities research',
    'Cultural studies',
    'Annotated bibliographies',
  ],
);

BoardNoteTemplate noteTemplateComparative = BoardNoteTemplate(
  type: NoteTemplateType.comparativeAnalysis,
  body: 'Multi-subject comparison',
  image: Images.noteTemplateComparative,
  route: '',
  description: 'Analyze and contrast multiple topics in detail.',
  bestFor: [
    'Comparing authors',
    'Cross-discipline analysis',
    'Evaluating perspectives',
    'Studying historical events',
    'Thematic research',
  ],
);

BoardNoteTemplate noteTemplateCritical = BoardNoteTemplate(
  type: NoteTemplateType.criticalReview,
  body: 'Evaluative framework',
  image: Images.noteTemplateCritical,
  route: '',
  description: 'Provide structured critique and analysis.',
  bestFor: [
    'Book reviews',
    'Film analysis',
    'Evaluating research papers',
    'Critiquing arguments',
    'Art critiques',
  ],
);

BoardNoteTemplate noteTemplateThesis = BoardNoteTemplate(
  type: NoteTemplateType.thesisDevelopment,
  body: 'Argument construction',
  image: Images.noteTemplateThesis,
  route: '',
  description: 'Plan, build, and refine thesis arguments.',
  bestFor: [
    'Developing arguments',
    'Structuring dissertations',
    'Research writing',
    'Building persuasive essays',
    'Graduate projects',
  ],
);
