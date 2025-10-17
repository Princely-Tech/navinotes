import 'package:flutter_drawing_board/paint_contents.dart';
import 'package:navinotes/packages.dart';
import 'package:navinotes/models/note_page.dart';
import 'package:navinotes/models/page_format.dart';
import 'package:flutter_drawing_board/flutter_drawing_board.dart';
import 'package:just_audio/just_audio.dart';
import 'managers/text_box_manager.dart';
import 'controllers/page_controller.dart' as page_ctrl;

enum NoteMode { text, drawing, voice, read }

class NoteReadVm extends ChangeNotifier {
  BoardNoteTemplate template;
  Content? content;
  final dbHelper = DatabaseHelper.instance;
  final BuildContext context;
  NoteReadVm({required this.content, required this.context})
    : template = getNoteTemplateFromString(
        content?.metaData[ContentMetadataKey.template],
      );

  final DrawingController _drawingController = DrawingController();

  // Audio recording
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  String? _recordingPath;
  int? _currentlyPlayingIndex;
  double _playbackSpeed = 1.0;
  Duration _currentPosition = Duration.zero;
  Duration _totalDuration = Duration.zero;
  DateTime? _lastPositionUpdate;
  StreamSubscription<Duration>? _positionSubscription;
  StreamSubscription<PlayerState>? _playerStateSubscription;

  bool showPageThumbnails = false;

  // UI state
  NoteMode _currentMode = NoteMode.read;

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
  bool get isPlaying => _isPlaying;
  bool get hasRecording => _recordingPath != null;
  NoteMode get currentMode => _currentMode;

  PlatformFile? aiSummaryFile;

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

  void initialize() {
    richEditorController.readOnly = false;

    // Add listener to main text controller for auto-save
    richEditorController.document.changes.listen((event) {
      debugPrint('Rich text changed');
    });

    getContent().then((_) {
      _initializePages();
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

  // Get text box manager for current page
  TextBoxManager get textBoxManager => getCurrentPageTextBoxManager();

  void setCurrentPageIndex(int index) {
    if (index >= 0 && index < _notePages.length) {
      debugPrint('Switching from page $_currentPageIndex to page $index');
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
      }
    }
  }

  void updateCurrentPageTemplate(BoardNoteTemplate newTemplate) {
    if (currentPage != null) {
      final pageIndex = _notePages.indexOf(currentPage!);
      if (pageIndex != -1) {
        _notePages[pageIndex] = currentPage!.copyWith(template: newTemplate);
        notifyListeners();
      }
    }
  }

  void updateTemplate(BoardNoteTemplate newTemplate) {
    template = newTemplate;
    notifyListeners();
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

  bool fetchingContent = true;

  bool isCreatingNote = false;

  bool showAiSection = false;

  QuillController richEditorController = QuillController.basic();

  // Override richEditorController getter to use current page controller
  QuillController get currentTextController => getCurrentPageTextController();

  void setMode(NoteMode mode) {
    _currentMode = mode;

    // Handle mode-specific initialization for current page
    final currentController = getCurrentPageTextController();
    currentController.readOnly = true;
    notifyListeners();
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

  void refreshDrawingState() {
    // Force a state update to ensure drawing changes are reflected
    notifyListeners();
  }

  Timer? _debounceTimer;

  void updateFetchingContent(bool loading) {
    fetchingContent = loading;
    notifyListeners();
  }

  Future<void> getContent() async {
    try {
      updateFetchingContent(true);

      if (content != null) {
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

  void getAllBoards() {}

  Future<void> goToRoute(String route) async {
    await NavigationHelper.push(route);
    getContent();
  }

  @override
  void dispose() {
    try {
      _debounceTimer?.cancel();
      _positionSubscription?.cancel();
      _playerStateSubscription?.cancel();
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

    _audioPlayer.dispose();
    _drawingController.dispose();
    richEditorController.dispose();
    super.dispose();
  }
}
