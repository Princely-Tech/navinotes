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
  final AudioPlayer _audioPlayer = AudioPlayer();
  final AudioRecorder _audioRecorder = AudioRecorder();
  bool _isRecording = false;
  bool _isPlaying = false;
  String? _recordingPath;
  NoteMode _currentMode = NoteMode.text;

  // Multi-page functionality
  List<NotePage> _notePages = [];
  int _currentPageIndex = 0;
  Map<String, DrawingController> _pageDrawingControllers = {};
  Map<String, QuillController> _pageTextControllers = {};

  List<NotePage> get notePages => _notePages;
  int get currentPageIndex => _currentPageIndex;
  NotePage? get currentPage => _notePages.isNotEmpty ? _notePages[_currentPageIndex] : null;

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

  // Add these fields to the class
  int? _currentlyPlayingIndex;
  int? get currentlyPlayingIndex => _currentlyPlayingIndex;

  // Update the togglePlayback method
  Future<void> toggleVoiceNotePlayback(int index) async {
    if (_currentlyPlayingIndex == index && _isPlaying) {
      // Pause current playback
      await _audioPlayer.pause();
      _isPlaying = false;
    } else {
      // Stop any current playback
      await _audioPlayer.stop();

      // Start new playback
      if (content?.voiceNotes.isNotEmpty ?? false) {
        final voiceNote = content!.voiceNotes[index];
        await _audioPlayer.setFilePath(voiceNote.file);
        await _audioPlayer.play();

        _currentlyPlayingIndex = index;
        _isPlaying = true;

        // Listen for playback completion
        _audioPlayer.playerStateStream.listen((state) {
          if (state.processingState == ProcessingState.completed) {
            _isPlaying = false;
            _currentlyPlayingIndex = null;
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
    }
  }

  DrawingController getCurrentPageDrawingController() {
    if (currentPage == null) return _drawingController;
    
    final pageId = currentPage!.id;
    if (!_pageDrawingControllers.containsKey(pageId)) {
      final controller = DrawingController();
      // Add listener to auto-save when drawing changes
      controller.addListener(() {
        _autoSaveCurrentPage();
      });
      _pageDrawingControllers[pageId] = controller;
    }
    return _pageDrawingControllers[pageId]!;
  }

  QuillController getCurrentPageTextController() {
    if (currentPage == null) return richEditorController;
    
    final pageId = currentPage!.id;
    if (!_pageTextControllers.containsKey(pageId)) {
      _pageTextControllers[pageId] = QuillController.basic();
    }
    return _pageTextControllers[pageId]!;
  }

  void setCurrentPageIndex(int index) {
    if (index >= 0 && index < _notePages.length) {
      _currentPageIndex = index;
      _loadPageContent();
      notifyListeners();
    }
  }

  void _loadPageContent() {
    if (currentPage == null) return;
    
    // Load text content for current page
    final textController = getCurrentPageTextController();
    if (currentPage!.textContent != null && currentPage!.textContent!.isNotEmpty) {
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
    if (currentPage!.drawingData != null && currentPage!.drawingData!.isNotEmpty) {
      try {
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
            }
          }
        }
      } catch (e) {
        debugPrint('Error loading page drawing content: $e');
      }
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
      final drawingContent = JsonEncoder.withIndent(
        '  ',
      ).convert(drawingController.getJsonList());
      
      // Update current page
      final updatedPage = currentPage!.getUpdatedPage(
        textContent: textContent,
        drawingData: drawingContent,
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

  void _autoSaveCurrentPage() {
    // Auto-save the current page when drawing changes
    if (currentPage != null) {
      // Use a timer to debounce rapid changes
      Timer(const Duration(milliseconds: 500), () {
        _saveCurrentPageContent();
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
            _notePages = pagesData
                .map((pageData) => NotePage.fromMap(Map<String, dynamic>.from(pageData)))
                .toList();
            
            if (content!.metaData.containsKey('currentPageIndex')) {
              _currentPageIndex = content!.metaData['currentPageIndex'] as int;
              _currentPageIndex = _currentPageIndex.clamp(0, _notePages.length - 1);
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
    _pageDrawingControllers.clear();
    _pageTextControllers.clear();
    
    super.dispose();
  }
}
