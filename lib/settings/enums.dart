var educationLevel = [
  'High School',
  'Vocational Training',
  'Associate Degree',
  'Undergraduate (Bachelor’s)',
  'Graduate (Master’s)',
  'Postgraduate / Doctorate (PhD)',
];

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
  // syllabus,
  file;

  @override
  toString() {
    switch (this) {
      case note:
        return 'Note';
      case mindmap:
        return 'Mindmap';
      // case syllabus:
      //   return 'Syllabus';
      case file:
        return 'File';
    }
  }
}

enum EditBoardTab {
  overview,
  uploads,
  assignments;

  @override
  String toString() {
    switch (this) {
      case overview:
        return 'Overview';
      case uploads:
        return 'Uploads';
      case assignments:
        return 'Assignments';
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
      case blank:
        return 'Blank Page';
      case cornell:
        return 'Cornell Notes';
      case lined:
        return 'Lined Paper';
      case squared:
        return 'Squared Paper';
      case dotted:
        return 'Dotted Paper';
      case kanban:
        return 'Kanban Board';
      case timeline:
        return 'Timeline';
      case compareContrast:
        return 'Compare & Contrast';
      case aiFlashcards:
        return 'AI-Generated Flashcards';
      case flashcards:
        return 'Flashcards';
      case labReport:
        return 'Lab Report Format';
      case apaFormat:
        return 'APA Format Guide';
      case mlaResearch:
        return 'MLA Research Format';
      case comparativeAnalysis:
        return 'Comparative Analysis';
      case criticalReview:
        return 'Critical Review';
      case thesisDevelopment:
        return 'Thesis Development';
    }
  }
}

enum NoteSortType {
  updatedAt,
  createdAt;

  bool get isModifiedAt => this == updatedAt;

  @override
  String toString() {
    switch (this) {
      case updatedAt:
        return 'updated_at';
      case createdAt:
        return 'created_at';
    }
  }
}
