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

  String shortString() {
    switch (this) {
      case front:
        return 'Front';
      case back:
        return 'Back';
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

class FlashCardCreationVm extends ChangeNotifier {
  GlobalKey<ScaffoldState> scaffoldKey;
  BuildContext context;
  ManualFlashCardProps props;
  FlashCardDeck deck;
  FlashCardCreationVm({
    required this.scaffoldKey,
    required this.context,
    required this.props,
  }) : deckNameController = TextEditingController(text: props.deck.name),
       deck = props.deck;

  TextEditingController deckNameController;
  Map<String, dynamic>? generationInfo;

  void updateGenerationInfo(Map<String, dynamic> info) {
    generationInfo = info;
    notifyListeners();
  }

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
        try {
          selectFlashCard(userFlashCards[props.targetIndex!]);
        } catch (err) {
          selectFlashCard(userFlashCards.first);
        }
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
        FlashCard card = FlashCard(
          guid: generateGUID(currentUser!.id!),
          deckId: deck.id!,
          front: defaultContent,
          back: defaultContent,
          difficulty: FlashcardDifficulty.easy,
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
      final resizedPath = await compressImage(pickedFile.path, width: 400);
      // Insert image into editor
      final index = controller.selection.baseOffset;

      controller.replaceText(
        index,
        0,
        BlockEmbed.image(resizedPath),
        TextSelection.collapsed(offset: index + 1),
      );

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

  List<Board> allBoards = [];
  Board? selectedBoard;
  List<Content> allContent = [];
  List<Content> selectedContent = [];
  bool gettingAllBoards = false;
  int numberOfCards = 12;

  void updateNumberOfCards(int value) {
    numberOfCards = value;
    notifyListeners();
  }

  List<String> cardTypes = [
    'Question & Answer',
    'Definition & Term',
    'Multiple Choice',
    'True/False',
  ];

  List<String> selectedCardTypes = [];

  void updateSelectedCardTypes(String type) {
    if (selectedCardTypes.contains(type)) {
      selectedCardTypes.remove(type);
    } else {
      selectedCardTypes.add(type);
    }
    notifyListeners();
  }

  TextEditingController difficultyController = TextEditingController();

  List<FlashcardDifficulty> selectedDifficulties = [];

  void updateSelectedDifficulties(FlashcardDifficulty difficulty) {
    if (selectedDifficulties.contains(difficulty)) {
      selectedDifficulties.remove(difficulty);
    } else {
      selectedDifficulties.add(difficulty);
    }
    notifyListeners();
  }

  void selectAllContents() {
    selectedContent = [];
    for (var content in allContent) {
      selectedContent.add(content);
    }
    notifyListeners();
  }

  void deselectAllContents() {
    selectedContent = [];
    notifyListeners();
  }

  void updateSelectedContents(Content content) {
    if (selectedContent.contains(content)) {
      selectedContent.remove(content);
    } else {
      selectedContent.add(content);
    }
    notifyListeners();
  }

  void updateGettingAllBoards(bool value) {
    gettingAllBoards = value;
    notifyListeners();
  }

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
    getBoards();
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

  AIContentSource selectedAISource = AIContentSource.fromNotes;
  void updateSelectedAiSource(AIContentSource source) {
    selectedAISource = source;
    notifyListeners();
  }

  void generateCardsHandler(
    ApiServiceProvider apiServiceProvider, {
    bool replace = false,
  }) async {
    try {
      updateLoading(true);
      String content = '';
      switch (selectedAISource) {
        case AIContentSource.fromNotes:
          content = getContentFromNotes();
          break;
        default:
      }

      if (content.isNotEmpty) {
        final body = initializeBodyValues();

        print(body);

        body['content'] = content;

        final requestBody = FormDataRequest.post(
          ApiEndpoints.flashcardAiContent,
          body: body,
        );
        final response = await apiServiceProvider.apiService
            .sendFormDataRequest(requestBody);
        updateGenerationInfo(response['response']);
        if (context.mounted) {
          final flashCards = await parseResponseFlashCards(
            response: response['response'],
            context: context,
            deckId: deck.id!,
          );

          updateGeneratedFlashCards(flashCards, replace: replace);
          if (context.mounted) {
            MessageDisplayService.showMessage(
              context,
              'Cards generated successfully',
            );
          }
        }
      }
    } catch (err) {
      print('Error generating cards: $err');
    }
    updateLoading(false);
  }

  void regenerateCardsHandler() {
    //
  }

  List<FlashCard> generatedFlashCards = [];

  void updateGeneratedFlashCards(
    List<FlashCard> cards, {
    bool replace = false,
  }) {
    if (replace) {
      generatedFlashCards = cards;
    } else {
      generatedFlashCards.addAll(cards);
    }
    notifyListeners();
    loadDeckFlashCards();
  }

  void getBoardContents() async {
    try {
      if (selectedBoard != null) {
        allContent = await DatabaseHelper.instance.getAllContents(
          selectedBoard!.id!,
        );
        notifyListeners();
      }
    } catch (err) {
      if (context.mounted) {
        MessageDisplayService.showErrorMessage(
          context,
          'Could not fetch notes',
        );
      }
    }
  }

  void getBoards() async {
    try {
      updateGettingAllBoards(true);
      allBoards = await DatabaseHelper.instance.getAllBoards();
      updateGettingAllBoards(false);
    } catch (err) {
      if (context.mounted) {
        MessageDisplayService.showErrorMessage(
          context,
          'Could not fetch boards',
        );
      }
    }
  }

  Map<String, dynamic> initializeBodyValues() {
    return {
      'length': numberOfCards,
      'difficulties': jsonEncode(
        selectedDifficulties.map((e) => e.name).toList(),
      ), // serialize
      'types': jsonEncode(selectedCardTypes.map((e) => e).toList()), //
    };
  }

  void goToCreateNote() async {
    await NavigationHelper.gotToNewNoteTemplate(selectedBoard!);
    getBoardContents();
  }

  void updateNoteBookControllerText(Board board) {
    selectedContent = [];
    selectedBoard = board;
    getBoardContents();
    notifyListeners();
  }

  String getContentFromNotes() {
    if (selectedContent.isEmpty) {
      MessageDisplayService.showErrorMessage(
        context,
        'Select at least one note',
      );
      return '';
    }

    final texts = <String>[];

    for (var item in selectedContent) {
      if (item.content != null && item.content!.isNotEmpty) {
        final plainText = getPlainTextFromDelta(item.content!);
        if (plainText.isNotEmpty) {
          texts.add(plainText);
        }
      }
    }
    return texts.join('. ') + (texts.isNotEmpty ? '.' : '');
  }
}
