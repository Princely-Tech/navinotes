import 'package:navinotes/packages.dart';

class FlashCardAiCreationVm extends ChangeNotifier {
  GlobalKey<ScaffoldState> scaffoldKey;
  FlashCardDeck deck;
  FlashCardAiCreationVm({required this.scaffoldKey, required this.deck});
  AIContentSource selectedAISource = AIContentSource.fromNotes;
  TextEditingController noteBookController = TextEditingController();
  // Board selectedBoard = 

  void updateNoteBookControllerText(String text) {
    noteBookController.text = text;
    notifyListeners();
  }

  void updateSelectedAiSource(AIContentSource source) {
    selectedAISource = source;
    notifyListeners();
  }

  void openDrawer() {
    scaffoldKey.currentState?.openDrawer();
  }

  void openEndDrawer() {
    scaffoldKey.currentState?.openEndDrawer();
  }
}
