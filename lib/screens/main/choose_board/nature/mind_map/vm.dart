import 'package:navinotes/packages.dart';

enum BorderStyleItem {
  noBorder,
  thinBoder,
  dashed,
  glow;

  @override
  String toString() {
    switch (this) {
      case thinBoder:
        return 'Thin Border';
      case dashed:
        return 'Dashed';
      case glow:
        return 'Glowing';
      case noBorder:
        return 'No Border';
    }
  }
}

enum BordeLineType {
  straight,
  curved,
  dashed,
  dotted;

  @override
  String toString() {
    switch (this) {
      case curved:
        return 'Curved';
      case dashed:
        return 'Dashed';
      case dotted:
        return 'Dotted';
      case straight:
        return 'Straight';
    }
  }
}

class BoardNatureMindMapVm extends ChangeNotifier {
  GlobalKey<ScaffoldState> scaffoldKey;
  BoardNatureMindMapVm({required this.scaffoldKey});
  List<MindMapFilterType> selectedFilters = [
    MindMapFilterType.showPdf,
    MindMapFilterType.showNotes,
  ];

  FontWeight fontWeight = FontWeight.w500;
  BorderStyleItem borderStyleItem = BorderStyleItem.thinBoder;
  int shape = 0;
  BordeLineType selectedLine = BordeLineType.curved;

  void updateLine(BordeLineType line) {
    selectedLine = line;
    notifyListeners();
  }

  void updateBorderItem(BorderStyleItem item) {
    borderStyleItem = item;
    notifyListeners();
  }

  void updateShape(int shape) {
    this.shape = shape;
    notifyListeners();
  }

  void updateFontWeight(FontWeight fontWeight) {
    this.fontWeight = fontWeight;
    notifyListeners();
  }

  void updateSelectedFilters(MindMapFilterType filter) {
    if (selectedFilters.contains(filter)) {
      selectedFilters.remove(filter);
    } else {
      selectedFilters.add(filter);
    }
    notifyListeners();
  }

  void openDrawer() {
    scaffoldKey.currentState?.openDrawer();
  }

  void openEndDrawer() {
    scaffoldKey.currentState?.openEndDrawer();
  }
}
