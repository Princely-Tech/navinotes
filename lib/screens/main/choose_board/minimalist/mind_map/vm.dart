import 'package:navinotes/packages.dart';

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

class MinimalistMindMapVm extends ChangeNotifier {
  GlobalKey<ScaffoldState> scaffoldKey;
  MinimalistMindMapVm({required this.scaffoldKey});

  List<MindMapFilterType> selectedFilters = [
    MindMapFilterType.showPdf,
    MindMapFilterType.showNotes,
  ];

  FontWeight fontWeight = FontWeight.w500;
  BorderStyleItem borderStyleItem = BorderStyleItem.shadow;
  int shape = 0;
  int selectedLine = 0;

  void updateLine(int line) {
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
