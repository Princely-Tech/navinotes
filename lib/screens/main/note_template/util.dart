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
  BoardNoteTemplate({
    required this.type,
    required this.body,
    this.description = 'Concrete description will be here',
    required this.image,
    this.route,
    this.isPopular = false,
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
    case NoteTemplateType.aiFlashcards:
      return noteTemplateAi;
    case NoteTemplateType.flashcards:
      return noteTemplateFlashcards;
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
);

BoardNoteTemplate noteTemplateCornell = BoardNoteTemplate(
  type: NoteTemplateType.cornell,
  body: 'Structured note-taking',
  image: Images.noteTemplateCornell,
  isPopular: true,
  description:
      'Structured note-taking method with dedicated sections for main notes, cues/questions, and summary.',
);

BoardNoteTemplate noteTemplateLined = BoardNoteTemplate(
  type: NoteTemplateType.lined,
  body: 'Classic lined surface',
  image: Images.noteTemplateLined,
);

BoardNoteTemplate noteTemplateSquared = BoardNoteTemplate(
  type: NoteTemplateType.squared,
  body: 'Grid for diagrams',
  image: Images.noteTemplateSquared,
);

BoardNoteTemplate noteTemplateDotted = BoardNoteTemplate(
  type: NoteTemplateType.dotted,
  body: 'Dot grid for flexible layout',
  image: Images.noteTemplateDotted,
);

BoardNoteTemplate noteTemplateKanban = BoardNoteTemplate(
  type: NoteTemplateType.kanban,
  body: 'Visual workflow manager',
  isPopular: true,
  image: Images.noteTemplateKanban,
  route: Routes.noteKanban,
);

BoardNoteTemplate noteTemplateTimeline = BoardNoteTemplate(
  type: NoteTemplateType.timeline,
  body: 'Chronological planner',
  image: Images.noteTemplateTimeline,
  route: Routes.noteTimeline,
);

BoardNoteTemplate noteTemplateCompareContrast = BoardNoteTemplate(
  type: NoteTemplateType.compareContrast,
  body: 'Side-by-side comparison',
  image: Images.noteTemplateCompareContrast,
  route: Routes.noteCompareContrast,
);

BoardNoteTemplate noteTemplateAi = BoardNoteTemplate(
  type: NoteTemplateType.aiFlashcards,
  body: 'AI-generated study cards',
  image: Images.noteTemplateAi,
  route: '',
);

BoardNoteTemplate noteTemplateFlashcards = BoardNoteTemplate(
  type: NoteTemplateType.flashcards,
  body: 'Question and answer cards',
  image: Images.noteTemplateFlashcards,
  route: Routes.flashCards,
  isPopular: true,
);

BoardNoteTemplate noteTemplateLapReport = BoardNoteTemplate(
  type: NoteTemplateType.labReport,
  body: 'Scientific experiment doc',
  image: Images.noteTemplateLapReport,
  route: Routes.noteLabReport,
);

BoardNoteTemplate noteTemplateApa = BoardNoteTemplate(
  type: NoteTemplateType.apaFormat,
  body: 'Text analysis framework',
  image: Images.noteTemplateApa,
);

BoardNoteTemplate noteTemplateResearch = BoardNoteTemplate(
  type: NoteTemplateType.mlaResearch,
  body: 'Humanities formatting',
  image: Images.noteTemplateResearch,
  route: '',
);

BoardNoteTemplate noteTemplateComparative = BoardNoteTemplate(
  type: NoteTemplateType.comparativeAnalysis,
  body: 'Multi-subject comparison',
  image: Images.noteTemplateComparative,
  route: '',
);

BoardNoteTemplate noteTemplateCritical = BoardNoteTemplate(
  type: NoteTemplateType.criticalReview,
  body: 'Evaluative framework',
  image: Images.noteTemplateCritical,
  route: '',
);

BoardNoteTemplate noteTemplateThesis = BoardNoteTemplate(
  type: NoteTemplateType.thesisDevelopment,
  body: 'Argument construction',
  image: Images.noteTemplateThesis,
  route: '',
);
