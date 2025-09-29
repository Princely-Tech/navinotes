import 'package:flutter_drawing_board/paint_contents.dart';
import 'package:navinotes/packages.dart';
import 'package:navinotes/models/note_page.dart';
import 'package:navinotes/models/page_format.dart';
import 'package:flutter_drawing_board/flutter_drawing_board.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:record/record.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'managers/text_box_manager.dart';
import 'models/drawing_tools.dart';
import 'models/stylus_settings.dart';
import 'controllers/pressure_drawing_controller.dart';

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
  final FocusNode titleFocusNode = FocusNode();
  TextEditingController titleController = TextEditingController();

  final DrawingController _drawingController = DrawingController();
  
  // Stylus settings and pressure-sensitive controllers
  StylusSettings _stylusSettings = const StylusSettings();
  final Map<String, PressureDrawingController> _pagePressureControllers = <String, PressureDrawingController>{};
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
  NoteMode _currentMode = NoteMode.text;
  bool _isTextBoxMode = false;
  String? _selectedTextBoxTool;

  // Drawing tool state
  Color _selectedColor = Colors.black;
  double _strokeWidth = 2.0;
  DrawingToolType _selectedDrawingTool = DrawingToolType.simpleLine;

  // Multi-page functionality
  List<NotePage> _notePages = [];
  int _currentPageIndex = 0;
  Map<String, DrawingController> _pageDrawingControllers = {};
  Map<String, QuillController> _pageTextControllers = {};
  Map<String, TextBoxManager> _pageTextBoxManagers = {};

  List<NotePage> get notePages => _notePages;
  int get currentPageIndex => _currentPageIndex;
  NotePage? get currentPage =>
      _notePages.isNotEmpty ? _notePages[_currentPageIndex] : null;

  DrawingController get drawingController => getCurrentPageDrawingController();
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
      _autoSaveCurrentPage();
    });

    // Load stylus settings
    loadStylusSettings();

    getContent().then((_) {
      _initializePages();
      _startAutoSave();
    });
    notifyListeners();

    titleFocusNode.addListener(() {
      if (!titleFocusNode.hasFocus) {
        updateContentInDb(showSnackBar: false);
      }
    });
  }

  // Multi-page methods
  void _initializePages() {
    if (_notePages.isEmpty) {
      // Create first page if none exist
      addNewPage();
    } else {
      // Load content for the current page
      _loadPageContent();
    }
  }

  DrawingController getCurrentPageDrawingController() {
    if (currentPage == null) return _drawingController;

    final pageId = currentPage!.id;
    if (!_pageDrawingControllers.containsKey(pageId)) {
      final controller = DrawingController();
      // Don't add listeners to avoid interfering with drawing
      _pageDrawingControllers[pageId] = controller;
      debugPrint('Created new drawing controller for page: $pageId');
    } else {
      debugPrint('Using existing drawing controller for page: $pageId');
    }
    return _pageDrawingControllers[pageId]!;
  }

  QuillController getCurrentPageTextController() {
    if (currentPage == null) return richEditorController;

    final pageId = currentPage!.id;
    if (!_pageTextControllers.containsKey(pageId)) {
      final controller = QuillController.basic();
      // Add listener to auto-save when text changes
      controller.document.changes.listen((event) {
        _autoSaveCurrentPage();
      });
      _pageTextControllers[pageId] = controller;
    }
    return _pageTextControllers[pageId]!;
  }

  TextBoxManager getCurrentPageTextBoxManager() {
    if (currentPage == null) {
      // Return a temporary manager for pages that don't exist yet
      return TextBoxManager();
    }

    final pageId = currentPage!.id;
    if (!_pageTextBoxManagers.containsKey(pageId)) {
      final manager = TextBoxManager();
      // Add listener to auto-save when text boxes change
      manager.addListener(() {
        _autoSaveCurrentPage();
      });
      _pageTextBoxManagers[pageId] = manager;
    }
    return _pageTextBoxManagers[pageId]!;
  }

  // Text box management methods
  void addTextBox(Offset position, {String? text}) {
    debugPrint('Adding text box at position: $position');
    final manager = getCurrentPageTextBoxManager();
    final textBox = manager.addTextBox(position, text: text);
    debugPrint('Text box created with ID: ${textBox.id}');
    notifyListeners();
  }

  void selectTextBox(String? textBoxId) {
    final manager = getCurrentPageTextBoxManager();
    manager.selectTextBox(textBoxId);
  }

  void startEditingTextBox(String textBoxId) {
    final manager = getCurrentPageTextBoxManager();
    manager.startEditing(textBoxId);
  }

  void stopEditingTextBox() {
    final manager = getCurrentPageTextBoxManager();
    manager.stopEditing();
  }

  void deleteTextBox(String textBoxId) {
    final manager = getCurrentPageTextBoxManager();
    manager.deleteTextBox(textBoxId);
    notifyListeners();
  }

  void clearTextBoxSelection() {
    final manager = getCurrentPageTextBoxManager();
    manager.clearSelection();
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
      // Save current page content before switching
      if (currentPage != null) {
        _saveCurrentPageContent();
      }

      _currentPageIndex = index;
      _loadPageContent();
      notifyListeners();
    }
  }

  void _loadPageContent() {
    if (currentPage == null) return;

    debugPrint('Loading content for current page: ${currentPage!.id}');

    // Load text content for current page
    final textController = getCurrentPageTextController();
    if (currentPage!.textContent != null &&
        currentPage!.textContent!.isNotEmpty) {
      try {
        textController.document = Document.fromJson(
          jsonDecode(currentPage!.textContent!),
        );
      } catch (e) {
        debugPrint('Error loading page text content: $e');
      }
    }

    // Load drawing content for current page
    final drawingController = getCurrentPageDrawingController();
    if (currentPage!.drawingData != null &&
        currentPage!.drawingData!.isNotEmpty) {
      try {
        // debugPrint(
        //   'Loading drawing data for page ${currentPage!.id}: ${currentPage!.drawingData}',
        // );
        final List<dynamic> drawingData = jsonDecode(currentPage!.drawingData!);
        drawingController.clear();

        for (var item in drawingData) {
          if (item is Map<String, dynamic>) {
            final String type = item['type'] as String;
            PaintContent? paintContent;

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
            }

            if (paintContent != null) {
              drawingController.addContent(paintContent);
              debugPrint('Added paint content: $type');
            }
          }
        }
        debugPrint('Loaded ${drawingData.length} drawing items');

        // Force a refresh to ensure the drawing is displayed
        notifyListeners();

        // Additional delay to ensure the widget rebuilds with the new content
        Future.delayed(const Duration(milliseconds: 100), () {
          notifyListeners();
          // Verify content was loaded
          final currentController = getCurrentPageDrawingController();
          debugPrint(
            'Controller after load has ${currentController.getJsonList().length} items',
          );
        });
      } catch (e) {
        debugPrint('Error loading page drawing content: $e');
      }
    } else {
      debugPrint('No drawing data to load for page ${currentPage!.id}');
      // Clear the drawing controller if no data
      final drawingController = getCurrentPageDrawingController();
      drawingController.clear();
    }

    // Load text box content for current page
    final textBoxManager = getCurrentPageTextBoxManager();
    if (currentPage!.textBoxData != null &&
        currentPage!.textBoxData!.isNotEmpty) {
      try {
        debugPrint('Loading text box data for page ${currentPage!.id}');
        final List<dynamic> textBoxData = jsonDecode(currentPage!.textBoxData!);
        textBoxManager.loadFromJson(textBoxData);
        debugPrint('Loaded ${textBoxData.length} text boxes');
      } catch (e) {
        debugPrint('Error loading page text box content: $e');
      }
    } else {
      debugPrint('No text box data to load for page ${currentPage!.id}');
      // Clear text boxes if no data
      textBoxManager.clearAll();
    }
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
    _renumberPages();

    // Clean up controllers
    _pageDrawingControllers.remove(pageToDelete.id);
    _pageTextControllers.remove(pageToDelete.id);

    // Adjust current page index
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
        // Save current page content before updating
        await _saveCurrentPageContent();

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

  Future<void> _saveCurrentPageContent() async {
    if (currentPage == null) return;

    try {
      // Save current text content
      final textController = getCurrentPageTextController();
      final textContent = jsonEncode(
        textController.document.toDelta().toJson(),
      );

      // Save current drawing content
      final drawingController = getCurrentPageDrawingController();
      String drawingContent = '[]';
      try {
        // Safely get drawing content, avoiding issues during active drawing
        final jsonList = drawingController.getJsonList();
        debugPrint(
          'Saving drawing content for page ${currentPage!.id}: ${jsonList.length} items',
        );
        drawingContent = JsonEncoder.withIndent('  ').convert(jsonList);
      } catch (e) {
        debugPrint('Error getting drawing content during save: $e');
        // Keep existing drawing data if there's an error
        if (currentPage!.drawingData != null &&
            currentPage!.drawingData!.isNotEmpty) {
          drawingContent = currentPage!.drawingData!;
        }
      }

      // Save current text box content
      final textBoxManager = getCurrentPageTextBoxManager();
      String textBoxContent = '[]';
      try {
        final textBoxList = textBoxManager.toJson();
        debugPrint(
          'Saving text box content for page ${currentPage!.id}: ${textBoxList.length} items',
        );
        textBoxContent = JsonEncoder.withIndent('  ').convert(textBoxList);
      } catch (e) {
        debugPrint('Error getting text box content during save: $e');
        // Keep existing text box data if there's an error
        if (currentPage!.textBoxData != null &&
            currentPage!.textBoxData!.isNotEmpty) {
          textBoxContent = currentPage!.textBoxData!;
        }
      }

      // Update current page
      final updatedPage = currentPage!.copyWith(
        textContent: textContent,
        drawingData: drawingContent,
        textBoxData: textBoxContent,
        updatedAt: generateUnixTimestamp(),
      );

      _notePages[_currentPageIndex] = updatedPage;
    } catch (e) {
      debugPrint('Error saving current page content: $e');
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
    final controller = getCurrentPageDrawingController();
    controller.clear();
    notifyListeners();
  }

  void refreshDrawingState() {
    // Force a state update to ensure drawing changes are reflected
    notifyListeners();
  }

  Future<void> manualSaveAndReload() async {
    // Manual save and reload for debugging
    debugPrint('Manual save and reload triggered');
    await _saveCurrentPageContent();
    _loadPageContent();
    notifyListeners();
  }

  void debugDrawingController() {
    // Debug method to check controller state
    final controller = getCurrentPageDrawingController();
    final items = controller.getJsonList();
    debugPrint('Current page: ${currentPage?.id}');
    debugPrint('Controller has ${items.length} items');
    for (int i = 0; i < items.length; i++) {
      debugPrint('Item $i: ${items[i]['type']}');
    }
  }

  void setDrawingState(bool isDrawing) {
    _isDrawing = isDrawing;
    if (!isDrawing) {
      // When drawing ends, trigger a save after a short delay
      Timer(const Duration(milliseconds: 100), () {
        _autoSaveCurrentPage();
      });
    }
  }

  Timer? _debounceTimer;
  bool _isDrawing = false;

  void _autoSaveCurrentPage() {
    // Auto-save the current page when content changes
    if (currentPage != null) {
      // Cancel previous timer to debounce rapid changes
      _debounceTimer?.cancel();

      // Use a longer debounce for drawing mode to avoid interfering with active drawing
      final debounceMs = currentMode == NoteMode.drawing ? 1000 : 500;

      // Use a timer to debounce rapid changes
      _debounceTimer = Timer(Duration(milliseconds: debounceMs), () async {
        // Don't save if we're in the middle of drawing to avoid interference
        if (!_isDrawing) {
          await _saveCurrentPageContent();
          // Also save to database to prevent data loss
          await updateContentInDb(showSnackBar: false);
        }
      });
    }
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
        _loadPageContent();
      }
    }
  }

  void _setCreateNoteLoading(bool loading) {
    isCreatingNote = loading;
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
    _autoSaveTimer?.cancel();
    _autoSaveTimer = Timer.periodic(_autoSaveInterval, (_) {
      updateContentInDb(showSnackBar: false);
    });
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
    updateContentInDb(showSnackBar: false);
    _autoSaveTimer?.cancel();
    _debounceTimer?.cancel();
    _positionSubscription?.cancel();
    _playerStateSubscription?.cancel();
    _audioRecorder.dispose();
    _audioPlayer.dispose();
    titleController.dispose();
    titleFocusNode.dispose();
    _drawingController.dispose();
    summaryController.dispose();
    focusAreaController.dispose();
    summaryLengthController.dispose();

    // Dispose page controllers to prevent memory leaks
    for (final controller in _pageDrawingControllers.values) {
      controller.dispose();
    }
    for (final controller in _pageTextControllers.values) {
      controller.dispose();
    }
    for (final controller in _pagePressureControllers.values) {
      controller.dispose();
    }
    _pageDrawingControllers.clear();
    _pageTextControllers.clear();
    _pagePressureControllers.clear();

    super.dispose();
  }

  // Stylus Settings Methods
  
  /// Get current stylus settings
  StylusSettings get stylusSettings => _stylusSettings;
  
  /// Update stylus settings
  void updateStylusSettings(StylusSettings settings) {
    _stylusSettings = settings;
    
    // Update all pressure controllers with new settings
    for (final controller in _pagePressureControllers.values) {
      controller.updateStylusSettings(settings);
    }
    
    notifyListeners();
  }
  
  /// Get pressure-sensitive drawing controller for current page
  PressureDrawingController getCurrentPagePressureController() {
    if (currentPage == null) {
      // Return a temporary controller for pages that don't exist yet
      return PressureDrawingController(stylusSettings: _stylusSettings);
    }

    final pageId = currentPage!.id;
    if (!_pagePressureControllers.containsKey(pageId)) {
      final controller = PressureDrawingController(stylusSettings: _stylusSettings);
      _pagePressureControllers[pageId] = controller;
      debugPrint('Created new pressure drawing controller for page: $pageId');
    } else {
      debugPrint('Using existing pressure drawing controller for page: $pageId');
    }
    return _pagePressureControllers[pageId]!;
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
      // In a full implementation, you would load from SharedPreferences or database
      // For now, we'll use default settings
      final defaultSettings = const StylusSettings();
      updateStylusSettings(defaultSettings);
    } catch (e) {
      debugPrint('Error loading stylus settings: $e');
      // Fallback to default settings
      updateStylusSettings(const StylusSettings());
    }
  }
  
  /// Save stylus settings to storage
  Future<void> saveStylusSettings() async {
    try {
      // In a full implementation, you would save to SharedPreferences or database
      final json = _stylusSettings.toJson();
      debugPrint('Saving stylus settings: $json');
      // await SharedPreferences.getInstance().then((prefs) => 
      //   prefs.setString('stylus_settings', jsonEncode(json)));
    } catch (e) {
      debugPrint('Error saving stylus settings: $e');
    }
  }
  
  /// Check if stylus is connected (platform-specific implementation needed)
  bool get isStylusConnected {
    // This would need platform-specific implementation
    // For now, return true to enable stylus features
    return true;
  }
  
  /// Get stylus input type based on platform and device
  StylusInputType get detectedStylusType {
    // This would need platform-specific detection
    // For now, return generic stylus
    return StylusInputType.genericStylus;
  }
}
