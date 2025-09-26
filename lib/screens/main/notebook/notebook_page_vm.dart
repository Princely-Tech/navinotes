import 'package:navinotes/packages.dart';
import 'package:navinotes/models/notebook_page.dart';
import 'package:flutter_drawing_board/flutter_drawing_board.dart';
import 'package:record/record.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

enum NotebookPageMode { text, drawing, voice }

class TextBox {
  final String id;
  final Offset position;
  final Size size;
  final String content;
  final bool isSelected;
  final QuillController controller;

  TextBox({
    String? id,
    required this.position,
    required this.size,
    required this.content,
    this.isSelected = false,
    QuillController? controller,
  }) : id = id ?? const Uuid().v4(),
       controller = controller ?? QuillController.basic();

  TextBox copyWith({
    String? id,
    Offset? position,
    Size? size,
    String? content,
    bool? isSelected,
    QuillController? controller,
  }) {
    return TextBox(
      id: id ?? this.id,
      position: position ?? this.position,
      size: size ?? this.size,
      content: content ?? this.content,
      isSelected: isSelected ?? this.isSelected,
      controller: controller ?? this.controller,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'position_x': position.dx,
      'position_y': position.dy,
      'width': size.width,
      'height': size.height,
      'content': content,
    };
  }

  factory TextBox.fromMap(Map<String, dynamic> map) {
    final controller = QuillController.basic();
    // Parse the content and set it to the controller
    if (map['content'] != null && map['content'].isNotEmpty) {
      try {
        final document = Document.fromJson(jsonDecode(map['content']));
        controller.document = document;
      } catch (e) {
        // If parsing fails, treat as plain text
        controller.document = Document()..insert(0, map['content'] ?? '');
      }
    }
    
    return TextBox(
      id: map['id'] ?? const Uuid().v4(),
      position: Offset(
        (map['position_x'] ?? 0.0).toDouble(),
        (map['position_y'] ?? 0.0).toDouble(),
      ),
      size: Size(
        (map['width'] ?? 200.0).toDouble(),
        (map['height'] ?? 100.0).toDouble(),
      ),
      content: map['content'] ?? '',
      controller: controller,
    );
  }
}

class NotebookPageVm extends ChangeNotifier {
  final NotebookPage notebookPage;
  final Content content;
  final Function(Content) onContentChanged;
  
  // Drawing
  final DrawingController _drawingController = DrawingController();
  
  // Voice recording
  final AudioPlayer _audioPlayer = AudioPlayer();
  final AudioRecorder _audioRecorder = AudioRecorder();
  bool _isRecording = false;
  bool _isPlaying = false;
  String? _recordingPath;
  
  // Mode management
  NotebookPageMode _currentMode = NotebookPageMode.text;
  
  // Text boxes
  List<TextBox> _textBoxes = [];
  String? _selectedTextBoxId;
  
  // Getters
  DrawingController get drawingController => _drawingController;
  bool get isRecording => _isRecording;
  bool get isPlaying => _isPlaying;
  bool get hasRecording => _recordingPath != null;
  NotebookPageMode get currentMode => _currentMode;
  List<TextBox> get textBoxes => _textBoxes;
  String? get selectedTextBoxId => _selectedTextBoxId;
  
  NotebookPageVm({
    required this.notebookPage,
    required this.content,
    required this.onContentChanged,
  }) {
    _loadPageData();
  }

  void _loadPageData() {
    // Load existing text boxes
    if (notebookPage.textBoxes != null) {
      try {
        final List<dynamic> textBoxData = jsonDecode(notebookPage.textBoxes!);
        _textBoxes = textBoxData.map((data) => TextBox.fromMap(data)).toList();
      } catch (e) {
        debugPrint('Error loading text boxes: $e');
        _textBoxes = [];
      }
    }
    
    // Load existing drawing data
    if (notebookPage.handwritingData != null) {
      try {
        // Load drawing data into the drawing controller
        // This will be handled by the drawing board widget
      } catch (e) {
        debugPrint('Error loading drawing data: $e');
      }
    }
    
    // Load voice notes
    if (notebookPage.voiceNotes != null) {
      try {
        final List<dynamic> voiceData = jsonDecode(notebookPage.voiceNotes!);
        // Handle voice notes loading
        if (voiceData.isNotEmpty) {
          _recordingPath = voiceData.first['path'];
        }
      } catch (e) {
        debugPrint('Error loading voice notes: $e');
      }
    }
    
    notifyListeners();
  }

  void setMode(NotebookPageMode mode) {
    _currentMode = mode;
    _selectedTextBoxId = null; // Deselect text boxes when switching modes
    notifyListeners();
  }

  // Text box management
  void addTextBox(Offset position) {
    final newTextBox = TextBox(
      position: position,
      size: const Size(200, 100),
      content: '',
    );
    _textBoxes.add(newTextBox);
    _selectedTextBoxId = newTextBox.id;
    notifyListeners();
    _savePageData();
  }

  void selectTextBox(String? textBoxId) {
    _selectedTextBoxId = textBoxId;
    notifyListeners();
  }

  void updateTextBox(String textBoxId, {
    Offset? position,
    Size? size,
    String? content,
  }) {
    final index = _textBoxes.indexWhere((box) => box.id == textBoxId);
    if (index != -1) {
      final oldBox = _textBoxes[index];
      _textBoxes[index] = oldBox.copyWith(
        position: position,
        size: size,
        content: content,
      );
      notifyListeners();
      _savePageData();
    }
  }

  void deleteTextBox(String textBoxId) {
    _textBoxes.removeWhere((box) => box.id == textBoxId);
    if (_selectedTextBoxId == textBoxId) {
      _selectedTextBoxId = null;
    }
    notifyListeners();
    _savePageData();
  }

  // Voice recording methods
  Future<void> startRecording() async {
    try {
      if (await _audioRecorder.hasPermission()) {
        final directory = await getApplicationDocumentsDirectory();
        final fileName = 'voice_note_${DateTime.now().millisecondsSinceEpoch}.m4a';
        final filePath = '${directory.path}/$fileName';
        
        await _audioRecorder.start(
          const RecordConfig(),
          path: filePath,
        );
        
        _isRecording = true;
        _recordingPath = filePath;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error starting recording: $e');
    }
  }

  Future<void> stopRecording() async {
    try {
      await _audioRecorder.stop();
      _isRecording = false;
      notifyListeners();
      _savePageData();
    } catch (e) {
      debugPrint('Error stopping recording: $e');
    }
  }

  Future<void> playRecording() async {
    if (_recordingPath != null) {
      try {
        await _audioPlayer.setFilePath(_recordingPath!);
        await _audioPlayer.play();
        _isPlaying = true;
        notifyListeners();
        
        _audioPlayer.playerStateStream.listen((state) {
          if (state.processingState == ProcessingState.completed) {
            _isPlaying = false;
            notifyListeners();
          }
        });
      } catch (e) {
        debugPrint('Error playing recording: $e');
      }
    }
  }

  Future<void> stopPlaying() async {
    try {
      await _audioPlayer.stop();
      _isPlaying = false;
      notifyListeners();
    } catch (e) {
      debugPrint('Error stopping playback: $e');
    }
  }

  void deleteRecording() {
    if (_recordingPath != null) {
      try {
        final file = File(_recordingPath!);
        if (file.existsSync()) {
          file.deleteSync();
        }
        _recordingPath = null;
        notifyListeners();
        _savePageData();
      } catch (e) {
        debugPrint('Error deleting recording: $e');
      }
    }
  }

  // Save page data
  void _savePageData() {
    try {
      // Save text boxes
      final textBoxData = _textBoxes.map((box) {
        // Update content from controller
        final content = jsonEncode(box.controller.document.toDelta().toJson());
        return box.copyWith(content: content).toMap();
      }).toList();
      
      // Save drawing data
      final drawingData = <Map<String, dynamic>>[];
      // TODO: Implement drawing data serialization from drawing controller
      
      // Save voice notes
      final voiceData = _recordingPath != null 
          ? [{'path': _recordingPath, 'timestamp': DateTime.now().millisecondsSinceEpoch}]
          : <Map<String, dynamic>>[];
      
      // Update the notebook page
      final updatedPage = notebookPage.copyWith(
        textBoxes: jsonEncode(textBoxData),
        handwritingData: jsonEncode(drawingData),
        voiceNotes: jsonEncode(voiceData),
        hasContent: _textBoxes.isNotEmpty || drawingData.isNotEmpty || voiceData.isNotEmpty,
        updatedAt: DateTime.now().millisecondsSinceEpoch,
      );
      
      // Save to database
      DatabaseHelper.instance.updateNotebookPage(updatedPage);
      
      // Update content timestamp
      final updatedContent = content.getUpdatedContent(
        updatedAt: DateTime.now().millisecondsSinceEpoch,
      );
      onContentChanged(updatedContent);
      
    } catch (e) {
      debugPrint('Error saving page data: $e');
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _audioRecorder.dispose();
    for (final textBox in _textBoxes) {
      textBox.controller.dispose();
    }
    super.dispose();
  }
}
