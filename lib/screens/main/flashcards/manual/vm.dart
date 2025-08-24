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

final cardFlipController = FlipCardController();

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

class FlashCardsManualCreationVm extends ChangeNotifier {
  GlobalKey<ScaffoldState> scaffoldKey;
  BuildContext context;
  FlashCardDeck deck;
  FlashCardsManualCreationVm({
    required this.scaffoldKey,
    required this.context,
    required this.deck,
  }) : deckNameController = TextEditingController(text: deck.name);

  TextEditingController deckNameController;

  FlashCard? currentFlashCard; // the flashcard tied to this session
  ValueNotifier<FlashCard?> currentFlashCardNotifier = ValueNotifier(null);
  Timer? _debounce;

  List<TagField> tagFields = [TagField('#neuroscience'), TagField('#biology')];
  TextEditingController textTypeController = TextEditingController(
    text: flashCardsTextTypes.first,
  );

  QuillController frontController = QuillController.basic();
  QuillController backController = QuillController.basic();

  final frontFocusNode = FocusNode();
  final backFocusNode = FocusNode();

  FlashCardsSide currentSide = FlashCardsSide.front;

  // list of flashcards for current user
  List<FlashCard> userFlashCards = [];

  final ImagePicker _picker = ImagePicker();

  bool loading = true;

  int? deletingCardId;

  void updateDeletingCardId(int? id) {
    deletingCardId = id;
    notifyListeners();
  }

  void updateLoading(bool value) {
    loading = value;
    notifyListeners();
  }

  void _attachListeners() {
    frontController.addListener(_scheduleAutoSave);
    backController.addListener(_scheduleAutoSave);
  }

  Future<void> handleDeleteFlashCard(FlashCard card) async {
    updateDeletingCardId(card.id);
    await deleteFlashCard(context: context, card: card);
    updateDeletingCardId(null);
    if (currentFlashCard?.id == card.id) {
      currentFlashCard = null;
      notifyListeners();
    }
    loadDeckFlashCards();
  }

  Future<void> loadDeckFlashCards() async {
    userFlashCards = await fetchDeckFlashCards(context: context, deck: deck);
    if (userFlashCards.isEmpty) {
      await initFlashCard();
    } else {
      if (currentFlashCard == null) {
        selectFlashCard(userFlashCards.first);
      }
    }
    notifyListeners();
    updateLoading(false);
  }

  void selectFlashCard(FlashCard card) {
    try {
      frontController = QuillController(
        document: safeDocFromJson(card.front),
        selection: const TextSelection.collapsed(offset: 0),
      );

      backController = QuillController(
        document: safeDocFromJson(card.back),
        selection: const TextSelection.collapsed(offset: 0),
      );
      currentFlashCard = card;
      _attachListeners();
      notifyListeners();
    } catch (err) {
      debugPrint('Error loading flashcard: $err');
      if (context.mounted) {
        MessageDisplayService.showErrorMessage(
          context,
          'Failed to load flashcard',
        );
      }
    }
  }

  Future<void> initFlashCard() async {
    updateLoading(true);
    try {
      final currentUser = getCurrentUserFromSession(context);
      List<Map<String, dynamic>> defaultContent = [];
      if (isNotNull(currentUser)) {
        final currentTimestamp = generateUnixTimestamp();
        // Create a new flashcard immediately
        FlashCard card = FlashCard(
          guid: generateGUID(currentUser!.id!),
          deckId: deck.id!,
          front: defaultContent,
          back: defaultContent,
          createdAt: currentTimestamp,
          updatedAt: currentTimestamp,
        );
        // Save to database
        int id = await DatabaseHelper.instance.insertFlashCard(card);
        card.setIDAfterCreate(id);
        // currentFlashCard = card;
        selectFlashCard(card);
        loadDeckFlashCards();
      }
    } catch (err) {
      debugPrint('Error creating flashcard: $err');
      if (context.mounted) {
        MessageDisplayService.showErrorMessage(
          context,
          'Failed to create flashcard',
        );
      }
    }
    updateLoading(false);
  }

  void _scheduleAutoSave() {
    // debounce so we don't save on every keystroke
    _debounce?.cancel();
    _debounce = Timer(const Duration(seconds: 1), _autoSaveFlashCard);
  }

  Future<void> _autoSaveFlashCard() async {
    if (currentFlashCard == null) return;

    await currentFlashCard!.update(
      front: frontController.document.toDelta().toJson(),
      back: backController.document.toDelta().toJson(),
    );

    loadDeckFlashCards();
  }

  Future<void> addImage() async {
    try {
      // Let user pick an image
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
      );
      if (pickedFile == null) return;

      // Determine active controller
      final isFrontActive =
          frontFocusNode.hasFocus || currentSide == FlashCardsSide.front;
      final controller = isFrontActive ? frontController : backController;

      // Insert image into editor
      final index = controller.selection.baseOffset;
      controller.replaceText(
        index,
        0,
        BlockEmbed.image(pickedFile.path),
        TextSelection.collapsed(offset: index + 1),
      );
      // controller.insertEmbed(index, 'image', pickedFile.path);

      notifyListeners();
    } catch (e) {
      debugPrint('Error picking image: $e');
    }
  }

  void clearCard() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text('Clear Card?'),
            content: Text(
              'This will erase all text and images on this card. \nThis action cannot be undone.',
            ),
            actions: [
              AppButton.text(onTap: NavigationHelper.pop, text: 'Cancel'),
              SizedBox(width: 15),
              AppButton.text(
                onTap: () => NavigationHelper.pop(true),
                text: 'Clear Card',
                color: AppTheme.coralRed,
              ),
            ],
          ),
    );
    if (confirm == true) {
      if (currentSide == FlashCardsSide.front) {
        frontController = QuillController(
          document: Document(),
          selection: const TextSelection.collapsed(offset: 0),
        );
      } else {
        backController = QuillController(
          document: Document(),
          selection: const TextSelection.collapsed(offset: 0),
        );
      }
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    frontController.dispose();
    backController.dispose();
    frontFocusNode.dispose();
    backFocusNode.dispose();
    super.dispose();
  }

  void updateSide(FlashCardsSide side) {
    currentSide = side;
    notifyListeners();
  }

  void toggleSide() {
    updateSide(
      currentSide == FlashCardsSide.front
          ? FlashCardsSide.back
          : FlashCardsSide.front,
    );
  }

  final FocusNode deckNameFocusNode = FocusNode();

  //For development purposes, will be removed in production
  void initialize() async {
    for (var field in tagFields) {
      field.focusNode.addListener(() {
        if (!field.focusNode.hasFocus && field.controller.text.trim().isEmpty) {
          tagFields.remove(field);
          notifyListeners();
        }
      });
    }
    deckNameFocusNode.addListener(() {
      if (!deckNameFocusNode.hasFocus) {
        deck.update(name: deckNameController.text);
      }
    });

    loadDeckFlashCards();
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

  void openDrawer() {
    scaffoldKey.currentState?.openDrawer();
  }

  void openEndDrawer() {
    scaffoldKey.currentState?.openEndDrawer();
  }
}
