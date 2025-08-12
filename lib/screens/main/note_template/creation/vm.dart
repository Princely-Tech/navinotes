import 'package:flutter_drawing_board/paint_contents.dart';
import 'package:navinotes/packages.dart';
import 'package:flutter_drawing_board/flutter_drawing_board.dart';
import 'package:record/record.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

enum NoteMode { text, drawing, voice }

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

  DrawingController get drawingController => _drawingController;
  bool get isRecording => _isRecording;
  bool get isPlaying => _isPlaying;
  bool get hasRecording => _recordingPath != null;
  NoteMode get currentMode => _currentMode;

  bool creatingContent = false;

  void setCreatingContent(bool creating) {
    creatingContent = creating;
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
        updatedAt: DateTime.now().millisecondsSinceEpoch ~/ 1000,
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
      _startAutoSave();
    });
    notifyListeners();

    titleFocusNode.addListener(() {
      if (!titleFocusNode.hasFocus) {
        updateContentInDb(showSnackBar: false);
      }
    });
  }

  Future<void> updateContentInDb({bool showSnackBar = false}) async {
    try {
      if (content != null) {
        // Get the content from the rich editor
        final String richEditorContent = jsonEncode(
          richEditorController.document.toDelta().toJson(),
        );
        final String drawingContent = JsonEncoder.withIndent(
          '  ',
        ).convert(_drawingController.getJsonList());

        // Create updated content with all current data including voice notes
        final newContent = content!.getUpdatedContent(
          title: titleController.text,
          content: richEditorContent,
          // voiceNotes: content!.voiceNotes,
          drawing: drawingContent,
          updatedAt: DateTime.now().millisecondsSinceEpoch ~/ 1000,
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

  void setMode(NoteMode mode) {
    _currentMode = mode;

    richEditorController.readOnly = true;
    // Handle mode-specific initialization
    if (mode == NoteMode.text) {
      richEditorController.readOnly = false;
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
          createdAt: DateTime.now().millisecondsSinceEpoch ~/ 1000,
          file: _recordingPath!,
          duration: duration,
          fileSize: fileSize,
        );

        // Update content with the new voice note
        final updatedVoiceNotes = List<VoiceNote>.from(content!.voiceNotes)
          ..add(voiceNote);
        content = content!.getUpdatedContent(
          voiceNotes: updatedVoiceNotes,
          updatedAt: DateTime.now().millisecondsSinceEpoch ~/ 1000,
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
    _drawingController.clear();
    notifyListeners();
  }

  Future<void> saveDrawing() async {
    // Implement saving the drawing
    // This could save the drawing as an image or keep it as vector data
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
      contents.addAll(await dbHelper.getAllContents(board.id!));
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
    // debugPrint(c.toString());
    // return;
    switch (selectedAiSummaryType) {
      case AiSummaryType.textInput:
        if (formKey.currentState!.validate()) {
          _processSummary(context, summaryController.text);
        }
        break;
      // case AiSummaryType.upload:
      //   break;
      case AiSummaryType.fromNotes:
        summarizeNote(context);
        break;
    }
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
    super.dispose();
  }
}
