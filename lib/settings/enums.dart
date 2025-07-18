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
