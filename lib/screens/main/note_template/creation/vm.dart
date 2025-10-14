import 'package:flutter_drawing_board/paint_contents.dart';
import 'package:navinotes/packages.dart';
import 'package:navinotes/models/note_page.dart';
import 'package:navinotes/models/page_format.dart';
import 'package:flutter_drawing_board/flutter_drawing_board.dart';
import 'package:record/record.dart';
import 'package:just_audio/just_audio.dart';
import 'managers/text_box_manager.dart';
import 'models/drawing_tools.dart';
import 'models/stylus_settings.dart';
import 'controllers/page_controller.dart' as page_ctrl;

enum NoteMode { text, drawing, voice, read }

class NoteCreationVm extends ChangeNotifier {
  GlobalKey<ScaffoldState> scaffoldKey;
  BoardNoteTemplate template;
  NoteCreationProp? creationProp;
  final dbHelper = DatabaseHelper.instance;
  final BuildContext context;
  NoteCreationVm({
    required this.scaffoldKey,
    required this.creationProp,
    required this.context,
  }) : template = creationProp?.template ?? noteTemplateBlank;
  TextEditingController titleController = TextEditingController();

  final DrawingController _drawingController = DrawingController();

  // Stylus settings
  StylusSettings _stylusSettings = const StylusSettings();

  // Audio recording
  final AudioRecorder _audioRecorder = AudioRecorder();
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isRecording = false;
  bool _isPlaying = false;
  String? _recordingPath;
  int? _currentlyPlayingIndex;
  double _playbackSpeed = 1.0;
  Duration _currentPosition = Duration.zero;
  Duration _totalDuration = Duration.zero;
  DateTime? _lastPositionUpdate;
  StreamSubscription<Duration>? _positionSubscription;
  StreamSubscription<PlayerState>? _playerStateSubscription;

  // UI state
  NoteMode _currentMode = NoteMode.read;
  bool _isTextBoxMode = false;
  String? _selectedTextBoxTool;

  // Drawing tool state
  Color _selectedColor = Colors.black;
  double _strokeWidth = 2.0;
  DrawingToolType _selectedDrawingTool = DrawingToolType.simpleLine;

  // Multi-page functionality
  List<NotePage> _notePages = [];
  int _currentPageIndex = 0;
  Map<String, page_ctrl.PageController> _pageControllers = {};

  List<NotePage> get notePages => _notePages;
  int get currentPageIndex => _currentPageIndex;
  NotePage? get currentPage =>
      _notePages.isNotEmpty ? _notePages[_currentPageIndex] : null;

  DrawingController get drawingController =>
      getCurrentPageController()?.activeDrawingController ?? _drawingController;
  bool get isRecording => _isRecording;
  bool get isPlaying => _isPlaying;
  bool get hasRecording => _recordingPath != null;
  NoteMode get currentMode => _currentMode;

  bool creatingContent = false;

  void setCreatingContent(bool creating) {
    creatingContent = creating;
    notifyListeners();
  }

  PlatformFile? aiSummaryFile;

  void updateAiSummaryFile(PlatformFile file) {
    aiSummaryFile = file;
    notifyListeners();
  }

  // Getters for voice playback
  int? get currentlyPlayingIndex => _currentlyPlayingIndex;
  double get playbackSpeed => _playbackSpeed;
  Duration get currentPosition => _currentPosition;
  Duration get totalDuration => _totalDuration;

  // Voice playback control methods
  Future<void> setPlaybackSpeed(double speed) async {
    _playbackSpeed = speed;
    if (_isPlaying) {
      await _audioPlayer.setSpeed(speed);
    }
    notifyListeners();
  }

  Future<void> seekToPosition(Duration position) async {
    _currentPosition = position;
    if (_isPlaying) {
      await _audioPlayer.seek(position);
    }
    notifyListeners();
  }

  Future<void> updateVoiceNoteName(int index, String newName) async {
    // Validate input
    if (content == null ||
        index < 0 ||
        index >= content!.voiceNotes.length ||
        newName.trim().isEmpty) {
      return;
    }

    try {
      final oldVoiceNote = content!.voiceNotes[index];

      // Check if name actually changed
      if (oldVoiceNote.name == newName) {
        return;
      }

      // Create new list to ensure immutability
      final updatedVoiceNotes = List<VoiceNote>.from(content!.voiceNotes);

      // Create new voice note with updated name
      final updatedVoiceNote = VoiceNote(
        name: newName.trim(),
        createdAt: oldVoiceNote.createdAt,
        file: oldVoiceNote.file,
        duration: oldVoiceNote.duration,
        fileSize: oldVoiceNote.fileSize,
      );

      // Update the list
      updatedVoiceNotes[index] = updatedVoiceNote;

      // Update content
      content = content!.getUpdatedContent(
        voiceNotes: updatedVoiceNotes,
        updatedAt: generateUnixTimestamp(),
      );

      // Save to database
      await updateContentInDb(showSnackBar: false);

      // Notify listeners after successful update
      notifyListeners();
    } catch (e) {
      debugPrint('Error updating voice note name: $e');
      // Consider showing an error to the user
      rethrow;
    }
  }

  // Update the togglePlayback method
  Future<void> toggleVoiceNotePlayback(int index) async {
    if (_currentlyPlayingIndex == index && _isPlaying) {
      // Pause current playback
      await _audioPlayer.pause();
      _isPlaying = false;
    } else {
      // Stop any current playback and cancel existing subscriptions
      await _audioPlayer.stop();
      _positionSubscription?.cancel();
      _playerStateSubscription?.cancel();

      // Start new playback
      if (content?.voiceNotes.isNotEmpty ?? false) {
        final voiceNote = content!.voiceNotes[index];
        await _audioPlayer.setFilePath(voiceNote.file);
        await _audioPlayer.setSpeed(_playbackSpeed);
        await _audioPlayer.play();

        _currentlyPlayingIndex = index;
        _isPlaying = true;
        _totalDuration = voiceNote.duration ?? Duration.zero;
        _currentPosition = Duration.zero;

        // Listen for position changes (throttled to avoid excessive rebuilds)
        _positionSubscription = _audioPlayer.positionStream.listen((position) {
          _currentPosition = position;
          // Only notify listeners every 500ms to avoid excessive rebuilds
          if (_lastPositionUpdate == null ||
              DateTime.now().difference(_lastPositionUpdate!) >
                  const Duration(milliseconds: 500)) {
            _lastPositionUpdate = DateTime.now();
            notifyListeners();
          }
        });

        // Listen for playback completion
        _playerStateSubscription = _audioPlayer.playerStateStream.listen((
          state,
        ) {
          if (state.processingState == ProcessingState.completed) {
            _isPlaying = false;
            _currentlyPlayingIndex = null;
            _currentPosition = Duration.zero;
            _positionSubscription?.cancel();
            _playerStateSubscription?.cancel();
            notifyListeners();
          }
        });
      }
    }
    notifyListeners();
  }

  // Add this method to delete a voice note
  Future<void> deleteVoiceNote(int index) async {
    if (content == null || index < 0 || index >= content!.voiceNotes.length) {
      return;
    }

    try {
      // Get the voice note to delete
      final voiceNoteToDelete = content!.voiceNotes[index];

      // Stop playback if this voice note is currently playing
      if (_currentlyPlayingIndex == index) {
        await _audioPlayer.stop();
        _positionSubscription?.cancel();
        _playerStateSubscription?.cancel();
        _isPlaying = false;
        _currentlyPlayingIndex = null;
      }

      // Delete the file
      final file = File(voiceNoteToDelete.file);
      if (await file.exists()) {
        await file.delete();
      }

      // Update the content
      final updatedVoiceNotes = List<VoiceNote>.from(content!.voiceNotes);
      updatedVoiceNotes.removeAt(index);

      content = content!.getUpdatedContent(
        voiceNotes: updatedVoiceNotes,
        updatedAt: generateUnixTimestamp(),
      );

      // Save to database
      await updateContentInDb();

      notifyListeners();

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Voice note deleted'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      debugPrint('Error deleting voice note: $e');
      if (context.mounted) {
        MessageDisplayService.showErrorMessage(
          context,
          'Could not delete voice note',
        );
      }
    }
  }

  Timer? _autoSaveTimer;
  static const Duration _autoSaveInterval = Duration(seconds: 10);

  void initialize() {
    richEditorController.readOnly = false;

    // Add listener to main text controller for auto-save
    richEditorController.document.changes.listen((event) {
      debugPrint('Rich text changed');
      _autoSaveCurrentPage();
    });

    // Load stylus settings
    loadStylusSettings();

    getContent().then((_) {
      _initializePages();
      _startAutoSave();
    });
    notifyListeners();
  }

  // Multi-page methods
  void _initializePages() {
    if (_notePages.isEmpty) {
      // Create first page if none exist
      addNewPage();
    } else {
      // Load content for the current page when app starts
      debugPrint('Initializing content for current page: ${currentPage?.id}');
      final controller = getCurrentPageController();
      if (controller != null) {
        debugPrint(
          'Page controller created and content loaded for: ${controller.page.id}',
        );
      }
    }
  }

  page_ctrl.PageController? getCurrentPageController() {
    if (currentPage == null) return null;

    final pageId = currentPage!.id;
    if (!_pageControllers.containsKey(pageId)) {
      final controller = page_ctrl.PageController(
        page: currentPage!,
        onPageUpdated: _updatePageInList,
        stylusSettings: _stylusSettings,
      );
      _pageControllers[pageId] = controller;
      debugPrint('Created new page controller for page: $pageId');
    }
    return _pageControllers[pageId]!;
  }

  QuillController getCurrentPageTextController() {
    return getCurrentPageController()?.textController ?? richEditorController;
  }

  TextBoxManager getCurrentPageTextBoxManager() {
    return getCurrentPageController()?.textBoxManager ?? TextBoxManager();
  }

  // Text box management methods - delegate to page controller
  void addTextBox(Offset position, {String? text}) {
    debugPrint('Adding text box at position: $position');
    getCurrentPageController()?.addTextBox(position, text: text);
    notifyListeners();
  }

  void selectTextBox(String? textBoxId) {
    getCurrentPageController()?.selectTextBox(textBoxId);
  }

  void startEditingTextBox(String textBoxId) {
    getCurrentPageController()?.startEditingTextBox(textBoxId);
  }

  void stopEditingTextBox() {
    getCurrentPageController()?.stopEditingTextBox();
  }

  void deleteTextBox(String textBoxId) {
    getCurrentPageController()?.deleteTextBox(textBoxId);
    notifyListeners();
  }

  void clearTextBoxSelection() {
    getCurrentPageController()?.clearTextBoxSelection();
  }

  // Get text box manager for current page
  TextBoxManager get textBoxManager => getCurrentPageTextBoxManager();

  // Text box mode getters and setters
  bool get isTextBoxMode => _isTextBoxMode;
  String? get selectedTextBoxTool => _selectedTextBoxTool;

  void setTextBoxMode(bool enabled, {String? tool}) {
    _isTextBoxMode = enabled;
    _selectedTextBoxTool = tool;
    notifyListeners();
  }

  void selectTextBoxTool(String tool) {
    debugPrint('Selecting text box tool: $tool');
    _isTextBoxMode = true;
    _selectedTextBoxTool = tool;
    notifyListeners();
  }

  void exitTextBoxMode() {
    debugPrint('Exiting text box mode');
    _isTextBoxMode = false;
    _selectedTextBoxTool = null;
    // Also clear any text box selection
    clearTextBoxSelection();
    notifyListeners();
  }

  // Drawing tool getters and setters
  Color get selectedColor => _selectedColor;
  double get strokeWidth => _strokeWidth;
  DrawingToolType get selectedDrawingTool => _selectedDrawingTool;

  void setSelectedColor(Color color) {
    _selectedColor = color;
    notifyListeners();
  }

  void setStrokeWidth(double width) {
    _strokeWidth = width;
    notifyListeners();
  }

  void setSelectedDrawingTool(DrawingToolType tool) {
    _selectedDrawingTool = tool;
    notifyListeners();
  }

  void setCurrentPageIndex(int index) {
    if (index >= 0 && index < _notePages.length) {
      debugPrint('Switching from page $_currentPageIndex to page $index');

      // Force save current page before switching
      final currentController = getCurrentPageController();
      if (currentController != null) {
        debugPrint(
          'Saving current page ${currentController.page.id} before switch',
        );
        currentController.forceSave();
      }

      // Save to database when switching pages
      updateContentInDb();

      _currentPageIndex = index;

      // Load content for new page
      final newController = getCurrentPageController();
      if (newController != null) {
        debugPrint('Loaded controller for new page ${newController.page.id}');
      }

      notifyListeners();
    }
  }

  void _updatePageInList(NotePage updatedPage) {
    final index = _notePages.indexWhere((page) => page.id == updatedPage.id);
    if (index != -1) {
      _notePages[index] = updatedPage;
    }

    debugPrint(
      'Updated page ${updatedPage.id} in memory (not saved to DB yet)',
    );
    // Note: Only update in-memory data, DB save happens on explicit save or page exit
  }

  NotePage addNewPage() {
    final newPage = NotePage(
      noteId: content?.id ?? '',
      pageNumber: _notePages.length + 1,
      format: PageFormat.defaultFormat, // A4 Portrait
      template: template, // Use current global template as default
      createdAt: generateUnixTimestamp(),
      updatedAt: generateUnixTimestamp(),
    );

    _notePages.add(newPage);
    _currentPageIndex = _notePages.length - 1;
    notifyListeners();
    return newPage;
  }

  NotePage addNewPageBefore(int index) {
    final newPage = NotePage(
      noteId: content?.id ?? '',
      pageNumber: index + 1,
      format: PageFormat.defaultFormat, // A4 Portrait
      template: template, // Use current global template as default
      createdAt: generateUnixTimestamp(),
      updatedAt: generateUnixTimestamp(),
    );

    _notePages.insert(index, newPage);
    _renumberPages();
    _currentPageIndex = index;
    notifyListeners();
    return newPage;
  }

  NotePage addNewPageAfter(int index) {
    final newPage = NotePage(
      noteId: content?.id ?? '',
      pageNumber: index + 2,
      format: PageFormat.defaultFormat, // A4 Portrait
      template: template, // Use current global template as default
      createdAt: generateUnixTimestamp(),
      updatedAt: generateUnixTimestamp(),
    );

    _notePages.insert(index + 1, newPage);
    _renumberPages();
    _currentPageIndex = index + 1;
    notifyListeners();
    return newPage;
  }

  void _renumberPages() {
    for (int i = 0; i < _notePages.length; i++) {
      _notePages[i] = _notePages[i].copyWith(pageNumber: i + 1);
    }
  }

  void deletePage(int index) {
    if (_notePages.length <= 1) return; // Don't delete the last page

    final pageToDelete = _notePages[index];
    _notePages.removeAt(index);

    // Clean up the page controller for the deleted page
    final pageId = pageToDelete.id;
    if (_pageControllers.containsKey(pageId)) {
      _pageControllers[pageId]?.dispose();
      _pageControllers.remove(pageId);
    }

    // Adjust current page index if necessary
    if (_currentPageIndex >= _notePages.length) {
      _currentPageIndex = _notePages.length - 1;
    }

    notifyListeners();
  }

  void updateCurrentPageFormat(PageFormat newFormat) {
    if (currentPage != null) {
      final pageIndex = _notePages.indexOf(currentPage!);
      if (pageIndex != -1) {
        _notePages[pageIndex] = currentPage!.copyWith(format: newFormat);
        notifyListeners();

        // Save to database
        updateContentInDb();
      }
    }
  }

  void updateCurrentPageTemplate(BoardNoteTemplate newTemplate) {
    if (currentPage != null) {
      final pageIndex = _notePages.indexOf(currentPage!);
      if (pageIndex != -1) {
        _notePages[pageIndex] = currentPage!.copyWith(template: newTemplate);
        notifyListeners();

        // Save to database
        updateContentInDb();
      }
    }
  }

  void updateTemplate(BoardNoteTemplate newTemplate) {
    template = newTemplate;
    notifyListeners();

    // Save template change to database
    updateContentInDb();
  }

  void _createPagesFromLegacyContent() {
    // Create a single page from existing content with A4 Portrait default
    final page = NotePage(
      noteId: content?.id ?? '',
      pageNumber: 1,
      format: PageFormat.defaultFormat, // A4 Portrait
      template: template, // Use current global template
      textContent: content?.content,
      drawingData: content?.drawing,
      createdAt: content?.createdAt ?? generateUnixTimestamp(),
      updatedAt: content?.updatedAt ?? generateUnixTimestamp(),
    );

    _notePages = [page];
    _currentPageIndex = 0;
  }

  Future<void> updateTitle(String newTitle) async {
    if (content != null) {
      titleController.text = newTitle;
      final updatedContent = content!.getUpdatedContent(
        title: newTitle,
        updatedAt: generateUnixTimestamp(),
      );

      try {
        await dbHelper.updateContent(updatedContent);
        content = updatedContent;
        notifyListeners();

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Title updated successfully!'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      } catch (err) {
        debugPrint('Error updating title: $err');
        if (context.mounted) {
          MessageDisplayService.showErrorMessage(
            context,
            'Could not update title!',
          );
        }
      }
    }
  }

  Future<void> updateContentInDb({bool showSnackBar = false}) async {
    try {
      if (content != null) {
        // Force save all page controllers before updating
        // Create a copy of controllers to avoid concurrent modification
        final controllers = List.from(_pageControllers.values);
        for (final controller in controllers) {
          await controller.forceSave();
        }

        // For backward compatibility, use the first page's content as main content
        String richEditorContent = '';
        String drawingContent = '';

        if (_notePages.isNotEmpty) {
          final firstPage = _notePages.first;
          richEditorContent = firstPage.textContent ?? '';
          drawingContent = firstPage.drawingData ?? '';
        } else {
          // Fallback to legacy single-page content
          richEditorContent = jsonEncode(
            richEditorController.document.toDelta().toJson(),
          );
          drawingContent = JsonEncoder.withIndent(
            '  ',
          ).convert(_drawingController.getJsonList());
        }

        // Store pages data in metadata
        final pagesData = _notePages.map((page) => page.toMap()).toList();
        final updatedMetaData = Map<String, dynamic>.from(content!.metaData);
        updatedMetaData['pages'] = pagesData;
        updatedMetaData['currentPageIndex'] = _currentPageIndex;

        // Create updated content with all current data including voice notes
        final newContent = content!.getUpdatedContentWithMeta(
          title: titleController.text,
          content: richEditorContent,
          drawing: drawingContent,
          metaData: updatedMetaData,
          updatedAt: generateUnixTimestamp(),
        );

        // Save to database
        await dbHelper.updateContent(newContent);

        // Update local content reference
        content = newContent;

        if (showSnackBar) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Note saved successfully!'),
                duration: Duration(seconds: 2),
              ),
            );
          }
        }
      }
    } catch (err) {
      debugPrint('Error updating content: $err');
      if (context.mounted) {
        MessageDisplayService.showErrorMessage(
          context,
          'Could not update content!',
        );
      }
    }
  }

  Content? content;
  bool fetchingContent = true;

  bool isCreatingNote = false;

  bool showAiSection = false;

  void openAiSection() {
    showAiSection = true;
    notifyListeners();
  }

  void closeAiSection() {
    showAiSection = false;
    notifyListeners();
  }

  QuillController richEditorController = QuillController.basic();

  // Override richEditorController getter to use current page controller
  QuillController get currentTextController => getCurrentPageTextController();

  void setMode(NoteMode mode) {
    _currentMode = mode;

    // Handle mode-specific initialization for current page
    final currentController = getCurrentPageTextController();
    currentController.readOnly = true;

    if (mode == NoteMode.text) {
      currentController.readOnly = false;
      // Move cursor to end of existing text when switching to text mode
      final pageController = getCurrentPageController();
      pageController?.moveCursorToEnd();
    } else if (mode == NoteMode.voice) {
      _initRecorder();
    }

    notifyListeners();
  }

  Future<void> _initRecorder() async {
    try {
      final status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        throw 'Microphone permission not granted';
      }
    } catch (e) {
      debugPrint('Error initializing recorder: $e');
      rethrow;
    }
  }

  Future<void> toggleRecording() async {
    if (_isRecording) {
      await _stopRecording();
    } else {
      await _startRecording();
    }
    notifyListeners();
  }

  Future<void> _startRecording() async {
    try {
      final tempDir = await getTemporaryDirectory();
      final path =
          '${tempDir.path}/recording_${DateTime.now().millisecondsSinceEpoch}.m4a';

      await _audioRecorder.start(
        const RecordConfig(encoder: AudioEncoder.aacLc),
        path: path,
      );

      _isRecording = true;
      _recordingPath = path;
      notifyListeners();
    } catch (e) {
      debugPrint('Error starting recording: $e');
      rethrow;
    }
  }

  Future<void> _stopRecording() async {
    try {
      await _audioRecorder.stop();
      _isRecording = false;

      if (_recordingPath != null && content != null) {
        final audioFile = File(_recordingPath!);
        Duration? duration;
        int fileSize = 0;

        try {
          // Get audio duration
          await _audioPlayer.setFilePath(_recordingPath!);
          duration = await _audioPlayer.duration;
          await _audioPlayer.stop();

          // Get file size
          if (await audioFile.exists()) {
            fileSize = await audioFile.length();
          }
        } catch (e) {
          debugPrint('Error getting audio metadata: $e');
        }

        // Create a new voice note with duration and file size
        final voiceNote = VoiceNote(
          name: DateTime.now().toString().substring(0, 19),
          createdAt: generateUnixTimestamp(),
          file: _recordingPath!,
          duration: duration,
          fileSize: fileSize,
        );

        // Update content with the new voice note
        final updatedVoiceNotes = List<VoiceNote>.from(content!.voiceNotes)
          ..add(voiceNote);
        content = content!.getUpdatedContent(
          voiceNotes: updatedVoiceNotes,
          updatedAt: generateUnixTimestamp(),
        );

        // Save to database
        await updateContentInDb();
      }

      notifyListeners();
    } catch (e) {
      debugPrint('Error stopping recording: $e');
      rethrow;
    }
  }

  Future<void> togglePlayback() async {
    if (_recordingPath == null) return;

    if (_isPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.setFilePath(_recordingPath!);
      await _audioPlayer.play();
    }

    _isPlaying = !_isPlaying;
    notifyListeners();
  }

  void clearRecording() {
    if (_recordingPath != null) {
      final file = File(_recordingPath!);
      if (file.existsSync()) {
        file.deleteSync();
      }
      _recordingPath = null;
      _isPlaying = false;
      notifyListeners();
    }
  }

  void clearDrawing() {
    getCurrentPageController()?.clearDrawing();
    notifyListeners();
  }

  void refreshDrawingState() {
    // Force a state update to ensure drawing changes are reflected
    notifyListeners();
  }

  Future<void> manualSaveAndReload() async {
    // Manual save for debugging
    debugPrint('Manual save triggered');
    await getCurrentPageController()?.forceSave();
    await updateContentInDb(showSnackBar: true);
    notifyListeners();
  }

  /// Explicit save method for save button
  Future<void> saveToDatabase() async {
    debugPrint('Explicit save to database triggered');
    // Force save current page content first
    await getCurrentPageController()?.forceSave();
    // Then save to database
    await updateContentInDb(showSnackBar: true);
  }

  /// Force save current page synchronously (for dispose)
  void _forceSaveCurrentPageSync() {
    try {
      debugPrint('Force saving current page synchronously before dispose');
      final currentController = getCurrentPageController();
      if (currentController != null) {
        // Force immediate save without waiting (synchronous)
        currentController.forceSave();
        debugPrint(
          'Current page ${currentController.page.id} saved synchronously',
        );
      }
    } catch (e) {
      debugPrint('Error in synchronous page save: $e');
    }
  }

  /// Call this method when screen is about to be popped/exited
  Future<void> onScreenExit() async {
    try {
      debugPrint('Screen exit triggered - saving current page and database');

      // Force save current page first
      final currentController = getCurrentPageController();
      if (currentController != null) {
        await currentController.forceSave();
        debugPrint('Current page ${currentController.page.id} saved on exit');
      }

      // Save to database
      await updateContentInDb(showSnackBar: false);
      debugPrint('Database save completed on screen exit');
    } catch (e) {
      debugPrint('Error saving on screen exit: $e');
    }
  }

  void debugDrawingController() {
    // Debug method to check controller state
    final controller = getCurrentPageController()?.activeDrawingController;
    if (controller != null) {
      final items = controller.getJsonList();
      debugPrint('Current page: ${currentPage?.id}');
      debugPrint('Controller has ${items.length} items');
      for (int i = 0; i < items.length; i++) {
        debugPrint('Item $i: ${items[i]['type']}');
      }
    } else {
      debugPrint('No active drawing controller');
    }
  }

  void setDrawingState(bool isDrawing) {
    // Drawing state is now handled by individual PageControllers
    // This method is kept for compatibility but does nothing
  }

  Timer? _debounceTimer;

  void _autoSaveCurrentPage() {
    // Auto-save is now handled by individual PageControllers
    // This method is kept for compatibility but does nothing
  }

  void openDrawer() {
    scaffoldKey.currentState?.openDrawer();
  }

  void openEndDrawer() {
    scaffoldKey.currentState?.openEndDrawer();
  }

  Future<List<Content>> getAllContent() async {
    final List<Content> contents = [];
    final boards = await dbHelper.getAllBoards();
    for (var board in boards) {
      contents.addAll(await dbHelper.getAllContents(board.id));
    }
    return contents;
  }

  void updateFetchingContent(bool loading) {
    fetchingContent = loading;
    notifyListeners();
  }

  AiSummaryType selectedAiSummaryType = AiSummaryType.textInput;

  void updateAiSummaryType(AiSummaryType type) {
    selectedAiSummaryType = type;
    notifyListeners();
  }

  Future<void> getContent() async {
    try {
      updateFetchingContent(true);
      Content? response = await dbHelper.getContentById(
        creationProp!.contentId,
      );

      if (response != null) {
        content = response;
        titleController.text = content!.title;

        try {
          if (content!.drawing != null && content!.drawing!.isNotEmpty) {
            final List<dynamic> drawingData = jsonDecode(content!.drawing!);
            _drawingController.clear();
            for (var item in drawingData) {
              if (item is Map<String, dynamic>) {
                final String type = item['type'] as String;
                PaintContent? paintContent;

                // Handle different types of paint content
                switch (type) {
                  case 'SimpleLine':
                    paintContent = SimpleLine.fromJson(item);
                    break;
                  case 'SmoothLine':
                    paintContent = SmoothLine.fromJson(item);
                    break;
                  case 'StraightLine':
                    paintContent = StraightLine.fromJson(item);
                    break;
                  case 'Rectangle':
                    paintContent = Rectangle.fromJson(item);
                    break;
                  case 'Circle':
                    paintContent = Circle.fromJson(item);
                    break;
                  case 'Eraser':
                    paintContent = Eraser.fromJson(item);
                    break;
                  default:
                    debugPrint('Unknown paint content type: $type');
                }

                if (paintContent != null) {
                  _drawingController.addContent(paintContent);
                }
              }
            }
          }
        } catch (err) {
          debugPrint('Error loading drawing: $err');
        }

        // Load pages data from metadata
        if (content!.metaData.containsKey('pages')) {
          try {
            final pagesData = content!.metaData['pages'] as List<dynamic>;
            _notePages =
                pagesData
                    .map(
                      (pageData) =>
                          NotePage.fromMap(Map<String, dynamic>.from(pageData)),
                    )
                    .toList();

            if (content!.metaData.containsKey('currentPageIndex')) {
              _currentPageIndex = content!.metaData['currentPageIndex'] as int;
              _currentPageIndex = _currentPageIndex.clamp(
                0,
                _notePages.length - 1,
              );
            }
          } catch (e) {
            debugPrint('Error loading pages data: $e');
            // Fallback to creating pages from legacy content
            _createPagesFromLegacyContent();
          }
        } else {
          // Create pages from legacy content
          _createPagesFromLegacyContent();
        }

        // Load legacy content for backward compatibility
        if (content!.content != null) {
          try {
            richEditorController.document = Document.fromJson(
              jsonDecode(content!.content!),
            );
          } catch (e1) {
            try {
              String txt = content!.content!;
              richEditorController.document = Document()..insert(0, txt);
            } catch (e2) {
              debugPrint('Error loading content: $e2');
              if (context.mounted) {
                MessageDisplayService.showErrorMessage(
                  context,
                  'Could not fetch content!',
                );
              }
            }

            debugPrint('Error loading content: $e1');
          }
        }

        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error fetching content: $e');
      if (context.mounted) {
        MessageDisplayService.showErrorMessage(
          context,
          'Could not fetch content!',
        );
      }
    } finally {
      updateFetchingContent(false);
      // Load content for current page after everything is loaded
      if (_notePages.isNotEmpty) {
        debugPrint(
          'Loading content for current page after DB load: ${currentPage?.id}',
        );
        final controller = getCurrentPageController();
        if (controller != null) {
          debugPrint(
            'Current page controller loaded with content: ${controller.page.id}',
          );
        }
      }
      // Notify listeners to rebuild the UI
      notifyListeners();
    }
  }

  void _setCreateNoteLoading(bool loading) {
    isCreatingNote = loading;
    // Notify listeners to rebuild the UI
    notifyListeners();
  }

  void getAllBoards() {}

  Future<void> createNote() async {
    if (content == null) {
      MessageDisplayService.showErrorMessage(context, 'Content is null');
      return;
    }
    await createContentInDb(
      template: template,
      context: context,
      boardId: content!.boardId,
      setLoading: _setCreateNoteLoading,
    );
    getContent();
  }

  Future<void> goToRoute(String route) async {
    await NavigationHelper.push(route);
    getContent();
  }

  void _startAutoSave() {
    // ZZZ: commented all
    // _autoSaveTimer?.cancel();
    // _autoSaveTimer = Timer.periodic(_autoSaveInterval, (_) {
    //   updateContentInDb(showSnackBar: false);
    // });
  }

  Future<void> save() async {
    return updateContentInDb(showSnackBar: true);
  }

  TextEditingController summaryController = TextEditingController();
  TextEditingController focusAreaController = TextEditingController();
  TextEditingController summaryLengthController = TextEditingController();

  String? summary;
  bool processingSummary = false;

  void updateProcessingSummary(bool processing) {
    processingSummary = processing;
    notifyListeners();
  }

  void updateSummary(String summary) {
    this.summary = summary;
    notifyListeners();
  }

  Future<void> summarizeContent(
    BuildContext context,
    GlobalKey<FormState> formKey,
  ) async {
    switch (selectedAiSummaryType) {
      case AiSummaryType.textInput:
        if (formKey.currentState!.validate()) {
          _processSummary(context, summaryController.text);
        }
        break;
      case AiSummaryType.upload:
        summarizeFile(context);
        break;
      case AiSummaryType.fromNotes:
        summarizeNote(context);
        break;
    }
  }

  Future<void> summarizeFile(BuildContext context) async {
    updateProcessingSummary(true);
    try {
      if (aiSummaryFile == null) {
        MessageDisplayService.showErrorMessage(
          context,
          'Upload a file to summarize',
        );
      } else {
        final apiServiceProvider = context.read<ApiServiceProvider>();
        int? length = int.tryParse(summaryLengthController.text);
        final body = {"length": length, "focus": focusAreaController.text};
        final request = FormDataRequest.post(
          ApiEndpoints.fileSummarize,
          files: {'file': File(aiSummaryFile!.path!)},
          body: body,
        );
        final response = await apiServiceProvider.apiService
            .sendFormDataRequest(request);
        final data = response['response'];
        updateSummary(data['summary']);
      }
    } catch (err) {
      debugPrint('Error summarizing content: $err');
      if (context.mounted) {
        MessageDisplayService.showErrorMessage(
          context,
          'Error summarizing content',
        );
      }
    }
    updateProcessingSummary(false);
  }

  Future<void> summarizeNote(BuildContext context) async {
    String plainText = richEditorController.document.toPlainText().trim();
    _processSummary(context, plainText);
  }

  Future<void> _processSummary(BuildContext context, String textInput) async {
    updateProcessingSummary(true);
    try {
      final apiServiceProvider = context.read<ApiServiceProvider>();
      int? length = int.tryParse(summaryLengthController.text);
      final body = {
        "content": textInput,
        "length": length,
        "focus": focusAreaController.text,
      };
      final request = JsonRequest.post(ApiEndpoints.contentSummarize, body);
      final response = await apiServiceProvider.apiService.sendJsonRequest(
        request,
      );
      final data = response['response'];
      updateSummary(data['summary']);
    } catch (err) {
      MessageDisplayService.showErrorMessage(
        context,
        'Error summarizing content',
      );
    }
    updateProcessingSummary(false);
  }

  @override
  void dispose() {
    try {
      // Force save current page immediately (synchronous)
      _forceSaveCurrentPageSync();

      // Cancel timers first to prevent new auto-saves
      _autoSaveTimer?.cancel();
      _debounceTimer?.cancel();
      _positionSubscription?.cancel();
      _playerStateSubscription?.cancel();

      // Try to save to database (fire and forget since dispose must be sync)
      updateContentInDb(showSnackBar: false).catchError((error) {
        debugPrint('Error saving to DB during dispose: $error');
      });
    } catch (e) {
      debugPrint('Error during dispose save: $e');
    }

    // Dispose all page controllers
    // Create a copy to avoid concurrent modification
    final controllers = List.from(_pageControllers.values);
    for (final controller in controllers) {
      controller.dispose();
    }
    _pageControllers.clear();

    _audioRecorder.dispose();
    _audioPlayer.dispose();
    titleController.dispose();
    _drawingController.dispose();
    summaryController.dispose();
    focusAreaController.dispose();
    summaryLengthController.dispose();
    richEditorController.dispose();
    super.dispose();
  }

  // Stylus Settings Methods
  /// Get current stylus settings
  StylusSettings get stylusSettings => _stylusSettings;

  /// Update stylus settings
  void updateStylusSettings(StylusSettings settings) {
    _stylusSettings = settings;

    // Update all page controllers with new settings
    // Create a copy to avoid concurrent modification
    final controllers = List.from(_pageControllers.values);
    for (final controller in controllers) {
      controller.updateStylusSettings(settings);
    }

    notifyListeners();
  }

  /// Show stylus settings dialog
  void showStylusSettings() {
    // This method would be called from the UI to show the settings dialog
    notifyListeners();
  }

  /// Reset stylus settings to defaults
  void resetStylusSettings() {
    updateStylusSettings(const StylusSettings());
  }

  /// Load stylus settings from storage
  Future<void> loadStylusSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final settingsJson = prefs.getString('stylus_settings');

      if (settingsJson != null) {
        final settingsMap = jsonDecode(settingsJson) as Map<String, dynamic>;
        final loadedSettings = StylusSettings.fromJson(settingsMap);
        updateStylusSettings(loadedSettings);
        debugPrint('Loaded stylus settings: $settingsMap');
      } else {
        // Use default settings if no saved settings found
        final defaultSettings = const StylusSettings();
        updateStylusSettings(defaultSettings);
        debugPrint('No saved stylus settings found, using defaults');
      }
    } catch (e) {
      debugPrint('Error loading stylus settings: $e');
      // Fallback to default settings
      updateStylusSettings(const StylusSettings());
    }
  }

  /// Save stylus settings to storage
  Future<void> saveStylusSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final json = _stylusSettings.toJson();
      await prefs.setString('stylus_settings', jsonEncode(json));
      debugPrint('Saved stylus settings: $json');
    } catch (e) {
      debugPrint('Error saving stylus settings: $e');
    }
  }

  /// Check if stylus is connected (platform-specific implementation)
  bool get isStylusConnected {
    try {
      if (Platform.isIOS) {
        // On iOS, Apple Pencil support is built into the system
        // We can assume stylus capability is available on iPad devices
        // This could be enhanced with device-specific detection
        return true;
      } else if (Platform.isAndroid) {
        // On Android, check for Samsung S Pen or other stylus support
        // This is a simplified check - could be enhanced with device detection
        return _hasAndroidStylusSupport();
      } else if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
        // Desktop platforms may have stylus/tablet support
        return _hasDesktopStylusSupport();
      }
      return false;
    } catch (e) {
      debugPrint('Error detecting stylus: $e');
      return false;
    }
  }

  /// Get stylus input type based on platform and device
  StylusInputType get detectedStylusType {
    try {
      if (Platform.isIOS) {
        // iOS devices with stylus support typically use Apple Pencil
        return StylusInputType.applePencil;
      } else if (Platform.isAndroid) {
        // Check for Samsung devices or other Android stylus types
        return _getAndroidStylusType();
      } else {
        // Desktop or other platforms
        return StylusInputType.genericStylus;
      }
    } catch (e) {
      debugPrint('Error detecting stylus type: $e');
      return StylusInputType.genericStylus;
    }
  }

  /// Check for Android stylus support
  bool _hasAndroidStylusSupport() {
    // This is a simplified implementation
    // In a real app, you might check:
    // - Device manufacturer (Samsung for S Pen)
    // - System properties
    // - Hardware capabilities
    // - Previous stylus input detection

    // For now, assume Android devices may have stylus support
    // This could be enhanced with device-specific detection
    return true;
  }

  /// Get Android-specific stylus type
  StylusInputType _getAndroidStylusType() {
    // This could be enhanced to detect specific stylus types:
    // - Check device manufacturer for Samsung S Pen
    // - Check for other OEM stylus implementations
    // - Use system APIs to detect stylus capabilities

    // Simplified detection based on common patterns
    try {
      // This is where you could add device-specific detection
      // For example, checking device model for Samsung devices
      return StylusInputType.genericStylus;
    } catch (e) {
      return StylusInputType.genericStylus;
    }
  }

  /// Check for desktop stylus support
  bool _hasDesktopStylusSupport() {
    // Desktop platforms may have:
    // - Wacom tablets
    // - Surface Pen (Windows)
    // - Other graphics tablets

    // This is a simplified implementation
    // Real detection would involve checking for:
    // - Connected tablet devices
    // - System drivers
    // - Hardware capabilities

    return false; // Conservative default for desktop
  }

  /// Enhanced stylus detection with runtime checks
  Future<bool> detectStylusAsync() async {
    try {
      // This method could perform more comprehensive async detection:
      // - Query system services
      // - Check hardware capabilities
      // - Test for stylus input events
      // - Cache results for performance

      if (Platform.isIOS) {
        // Could check for iPad models that support Apple Pencil
        return true;
      } else if (Platform.isAndroid) {
        // Could use platform channels to check Android-specific APIs
        return _hasAndroidStylusSupport();
      }

      return false;
    } catch (e) {
      debugPrint('Error in async stylus detection: $e');
      return false;
    }
  }

  /// Get stylus capabilities for the current device
  Map<String, bool> get stylusCapabilities {
    return {
      'pressureSensitivity': _supportsPressure(),
      'tiltSensitivity': _supportsTilt(),
      'hoverDetection': _supportsHover(),
      'palmRejection': _supportsPalmRejection(),
    };
  }

  /// Test stylus functionality (for debugging)
  void testStylusFeatures() {
    debugPrint('=== Stylus System Test ===');
    debugPrint('Stylus connected: $isStylusConnected');
    debugPrint('Detected stylus type: $detectedStylusType');
    debugPrint(
      'Pressure sensitivity enabled: ${_stylusSettings.pressureSensitivityEnabled}',
    );
    debugPrint('Palm rejection level: ${_stylusSettings.palmRejectionLevel}');
    debugPrint('Stylus capabilities: $stylusCapabilities');

    final pageController = getCurrentPageController();
    debugPrint('Current page has controller: ${pageController != null}');

    if (pageController != null) {
      final regularItems =
          pageController.drawingController.getJsonList().length;
      final pressureItems =
          pageController.pressureController.getJsonList().length;
      debugPrint('Regular controller items: $regularItems');
      debugPrint('Pressure controller items: $pressureItems');
    }
    debugPrint('=========================');
  }

  /// Check if device supports pressure sensitivity
  bool _supportsPressure() {
    if (Platform.isIOS) {
      return true; // Apple Pencil supports pressure
    } else if (Platform.isAndroid) {
      return true; // Many Android styluses support pressure
    }
    return false;
  }

  /// Check if device supports tilt sensitivity
  bool _supportsTilt() {
    if (Platform.isIOS) {
      return true; // Apple Pencil supports tilt
    } else if (Platform.isAndroid) {
      return true; // Some Android styluses support tilt
    }
    return false;
  }

  /// Check if device supports hover detection
  bool _supportsHover() {
    if (Platform.isIOS) {
      return true; // Apple Pencil supports hover (iPad Pro)
    } else if (Platform.isAndroid) {
      return true; // Samsung S Pen supports hover
    }
    return false;
  }

  /// Check if device supports palm rejection
  bool _supportsPalmRejection() {
    // Most modern stylus implementations support some form of palm rejection
    return Platform.isIOS || Platform.isAndroid;
  }
}
