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

  void initialize() {
    richEditorController.readOnly = false; //TODO make false
    getContent();
    notifyListeners();

    titleFocusNode.addListener(() {
      if (!titleFocusNode.hasFocus) {
        updateContentInDb();
      }
    });
  }

  void updateContentInDb() {
    try {
      if (isNotNull(content)) {
        final newContent = content!.getUpdatedContent(
          title: titleController.text,
        );
        dbHelper.updateContent(newContent);
      }
    } catch (err) {
      MessageDisplayService.showErrorMessage(
        context,
        'Could not update content!',
      );
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
      final path = '${tempDir.path}/recording_${DateTime.now().millisecondsSinceEpoch}.m4a';

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

  void getContent() async {
    try {
      updateFetchingContent(true);
      Content? response = await dbHelper.getContentById(
        creationProp!.contentId,
      );
      if (isNotNull(response)) {
        content = response;
        titleController.text = content!.title;
        notifyListeners();
      }
    } catch (e) {
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
    if (isNull(content)) {
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

  @override
  void dispose() {
    _drawingController.dispose();
    _audioRecorder.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }
}
