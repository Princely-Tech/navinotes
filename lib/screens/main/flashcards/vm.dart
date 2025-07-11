import 'package:navinotes/packages.dart';

class TagField {
  final TextEditingController controller;
  final FocusNode focusNode;

  TagField(String text)
    : controller = TextEditingController(text: text),
      focusNode = FocusNode();
}

class FlashCardsVm extends ChangeNotifier {
  GlobalKey<ScaffoldState> scaffoldKey;
  FlashCardsVm({required this.scaffoldKey});

  List<TagField> tagFields = [TagField('#neuroscience'), TagField('#biology')];

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
