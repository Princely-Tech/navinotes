import 'package:navinotes/packages.dart';

enum DarkAcademiaMindMapFilterType {
  showPdf,
  showNotes,
  showImages;

  @override
  toString() {
    switch (this) {
      case DarkAcademiaMindMapFilterType.showPdf:
        return 'Show PDF Files';
      case DarkAcademiaMindMapFilterType.showNotes:
        return 'Show Notes';
      case DarkAcademiaMindMapFilterType.showImages:
        return 'Show Images';
    }
  }
}

enum BorderStyleItem {
  shadow,
  border,
  glow,
  noBorder;

  @override
  toString() {
    switch (this) {
      case shadow:
        return 'Shadow';
      case border:
        return 'Border';
      case glow:
        return 'Glow';
      case noBorder:
        return 'No Border';
    }
  }
}

class DarkAcademiaMindMapVm extends ChangeNotifier {
  GlobalKey<ScaffoldState> scaffoldKey;
  DarkAcademiaMindMapVm({required this.scaffoldKey});
  List<DarkAcademiaMindMapFilterType> selectedFilters = [
    DarkAcademiaMindMapFilterType.showPdf,
    DarkAcademiaMindMapFilterType.showNotes,
  ];

  FontWeight fontWeight = FontWeight.w500;
  BorderStyleItem borderStyleItem = BorderStyleItem.shadow;
  int shape = 0;
  String selectedLine = Images.squiglyLine;

  void updateLine(String line) {
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

  void updateSelectedFilters(DarkAcademiaMindMapFilterType filter) {
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
