import 'package:navinotes/packages.dart';

enum FlashCardsSide {
  front,
  back;

  @override
  String toString() {
    switch (this) {
      case front:
        return 'Front Side';
      case back:
        return 'Back Side';
    }
  }
}

class TagField {
  final TextEditingController controller;
  final FocusNode focusNode;

  TagField(String text)
    : controller = TextEditingController(text: text),
      focusNode = FocusNode();
}

List<String> flashCardsTextTypes = [
  'Normal Text',
  'Italic Text',
  'Underlined Text',
];

class FlashCardsVm extends ChangeNotifier {
  GlobalKey<ScaffoldState> scaffoldKey;
  FlashCardsVm({required this.scaffoldKey});

  List<TagField> tagFields = [TagField('#neuroscience'), TagField('#biology')];
  TextEditingController textTypeController = TextEditingController(
    text: flashCardsTextTypes.first,
  );

  FlashCardsSide currentSide = FlashCardsSide.front;

  void toggleSide() {
    currentSide =
        currentSide == FlashCardsSide.front
            ? FlashCardsSide.back
            : FlashCardsSide.front;
    notifyListeners();
  }

  //For development purposes, will be removed in production
  void initialize() {
    for (var field in tagFields) {
      field.focusNode.addListener(() {
        if (!field.focusNode.hasFocus && field.controller.text.trim().isEmpty) {
          tagFields.remove(field);
          notifyListeners();
        }
      });
    }
  }

  void addTagField() {
    final newField = TagField('#');
    newField.focusNode.addListener(() {
      if (!newField.focusNode.hasFocus &&
          newField.controller.text.trim().isEmpty) {
        tagFields.remove(newField);
        notifyListeners();
      }
    });
    tagFields.add(newField);
    notifyListeners();
  }

  // void addTagControllers() {
  //   tagControllers.add(TextEditingController(text: '#'));
  //   notifyListeners();
  // }

  void openDrawer() {
    scaffoldKey.currentState?.openDrawer();
  }

  void openEndDrawer() {
    scaffoldKey.currentState?.openEndDrawer();
  }
}
