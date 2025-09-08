import 'package:navinotes/packages.dart';

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

enum AiSummaryType {
  textInput,
  upload,
  fromNotes;

  @override
  toString() {
    switch (this) {
      case textInput:
        return 'Text Input';
      case upload:
        return 'Upload';
      case fromNotes:
        return 'From Notes';
    }
  }
}

enum MindMapFilterType {
  showPdf,
  showNotes,
  showImages,
  showDecks;

  @override
  toString() {
    switch (this) {
      case showPdf:
        return 'Show PDF Files';
      case showNotes:
        return 'Show Notes';
      case showImages:
        return 'Show Images';
      case showDecks:
        return 'Show Flashcard Decks';
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
  flashcardDeck,
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
      case flashcardDeck:
        return 'Flashcard Deck';
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
  aiFlashCards,
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
      case aiFlashCards:
        return 'AI-Generated FlashCards';
      case flashcards:
        return 'FlashCards';
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

enum AIContentSource {
  fromNotes,
  upload,
  textInput;

  @override
  String toString() {
    switch (this) {
      case fromNotes:
        return '🗒️ From My Notes';
      case upload:
        return '📄 Upload Document';
      case textInput:
        return '✏️ Text Input';
    }
  }
}

enum FlashcardDifficulty {
  again,
  easy,
  medium,
  hard;

  @override
  String toString() {
    switch (this) {
      case easy:
        return 'Easy';
      case again:
        return 'Again';
      case medium:
        return 'Medium';
      case hard:
        return 'Hard';
    }
  }

  Color get color {
    switch (this) {
      case again:
        return const Color(0xFFFEE2E2);
      case hard:
        return const Color(0xFFFFEDD5);
      default:
        return const Color(0xFFD1FAE5);
    }
  }

  Color get textColor {
    switch (this) {
      case again:
        return const Color(0xFFDC2626);
      case hard:
        return const Color(0xFFEA580C);
      default:
        return const Color(0xFF059669);
    }
  }
}
