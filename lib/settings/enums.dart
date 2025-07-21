enum ImagePlaceHolderTypes {
  asset,
  network;

  bool get isAsset => this == asset;
  bool get isNetwork => this == network;
}

enum PageDisplayFormat {
  grid,
  list;

  bool get isGrid => this == grid;
  bool get isList => this == list;
}

enum MindMapFilterType {
  showPdf,
  showNotes,
  showImages;

  @override
  toString() {
    switch (this) {
      case showPdf:
        return 'Show PDF Files';
      case showNotes:
        return 'Show Notes';
      case showImages:
        return 'Show Images';
    }
  }
}

enum KanbanTaskTag {
  notStarted,
  ready,
  inProgress,
  needsReview,
  completed;

  @override
  toString() {
    switch (this) {
      case notStarted:
        return 'Not Started';
      case completed:
        return 'Completed';
      case needsReview:
        return 'Needs Review';
      case inProgress:
        return 'In Progress';
      case ready:
        return 'Ready';
    }
  }
}

enum AppContentType {
  note,
  mindmap,
  syllabus;

  @override
  toString() {
    switch (this) {
      case note:
        return 'Note';
      case mindmap:
        return 'Mindmap';
      case syllabus:
        return 'Syllabus';
    }
  }
}

enum NoteTemplateType {
  blank,
  cornell,
  lined,
  squared,
  dotted,
  kanban,
  timeline,
  compareContrast,
  aiFlashcards,
  flashcards,
  labReport,
  apaFormat,
  mlaResearch,
  comparativeAnalysis,
  criticalReview,
  thesisDevelopment;

  @override
  String toString() {
    switch (this) {
      case NoteTemplateType.blank:
        return 'Blank Page';
      case NoteTemplateType.cornell:
        return 'Cornell Notes';
      case NoteTemplateType.lined:
        return 'Lined Paper';
      case NoteTemplateType.squared:
        return 'Squared Paper';
      case NoteTemplateType.dotted:
        return 'Dotted Paper';
      case NoteTemplateType.kanban:
        return 'Kanban Board';
      case NoteTemplateType.timeline:
        return 'Timeline';
      case NoteTemplateType.compareContrast:
        return 'Compare & Contrast';
      case NoteTemplateType.aiFlashcards:
        return 'AI-Generated Flashcards';
      case NoteTemplateType.flashcards:
        return 'Flashcards';
      case NoteTemplateType.labReport:
        return 'Lab Report Format';
      case NoteTemplateType.apaFormat:
        return 'APA Format Guide';
      case NoteTemplateType.mlaResearch:
        return 'MLA Research Format';
      case NoteTemplateType.comparativeAnalysis:
        return 'Comparative Analysis';
      case NoteTemplateType.criticalReview:
        return 'Critical Review';
      case NoteTemplateType.thesisDevelopment:
        return 'Thesis Development';
    }
  }
}
