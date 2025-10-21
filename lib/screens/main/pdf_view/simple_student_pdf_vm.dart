import 'package:flutter/material.dart';
import 'package:navinotes/packages.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'dart:io';

/// Student annotation types
enum StudentAnnotationType {
  highlight,
  drawing,
  textNote,
  arrow,
  rectangle,
  circle,
}

/// Student drawing stroke
class StudentStroke {
  final List<Offset> points;
  final Color color;
  final double width;
  final StudentAnnotationType type;
  
  StudentStroke({
    required this.points,
    required this.color,
    required this.width,
    required this.type,
  });
  
  Map<String, dynamic> toJson() => {
    'points': points.map((p) => {'x': p.dx, 'y': p.dy}).toList(),
    'color': color.value,
    'width': width,
    'type': type.toString(),
  };
  
  static StudentStroke fromJson(Map<String, dynamic> json) => StudentStroke(
    points: (json['points'] as List).map((p) => Offset(p['x']?.toDouble() ?? 0.0, p['y']?.toDouble() ?? 0.0)).toList(),
    color: Color(json['color'] ?? Colors.black.value),
    width: json['width']?.toDouble() ?? 2.0,
    type: StudentAnnotationType.values.firstWhere(
      (e) => e.toString() == json['type'], 
      orElse: () => StudentAnnotationType.drawing,
    ),
  );
}

/// Student text annotation
class StudentTextNote {
  final Offset position;
  final String text;
  final Color color;
  final DateTime createdAt;
  
  StudentTextNote({
    required this.position,
    required this.text,
    required this.color,
    required this.createdAt,
  });
  
  Map<String, dynamic> toJson() => {
    'position': {'x': position.dx, 'y': position.dy},
    'text': text,
    'color': color.value,
    'createdAt': createdAt.toIso8601String(),
  };
  
  static StudentTextNote fromJson(Map<String, dynamic> json) => StudentTextNote(
    position: Offset(json['position']['x']?.toDouble() ?? 0.0, json['position']['y']?.toDouble() ?? 0.0),
    text: json['text'] ?? '',
    color: Color(json['color'] ?? Colors.orange.value),
    createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
  );
}

/// Enhanced student PDF viewer model with rich annotations
class SimpleStudentPdfVm extends ChangeNotifier {
  final String contentId;
  
  // Syncfusion PDF controller
  late PdfViewerController _pdfController;
  
  // Document state
  Content? _content;
  bool _isLoading = false;
  String? _errorMessage;
  
  // Enhanced annotation state
  StudentAnnotationType _currentTool = StudentAnnotationType.highlight;
  Color _currentColor = Colors.yellow;
  double _strokeWidth = 3.0;
  bool _isAnnotationMode = false;
  
  // Annotations storage
  final Map<int, List<StudentStroke>> _strokes = {};
  final Map<int, List<StudentTextNote>> _textNotes = {};
  List<Offset> _currentStroke = [];
  StudentTextNote? _pendingTextNote;
  
  SimpleStudentPdfVm({
    required this.contentId,
  }) {
    _pdfController = PdfViewerController();
  }
  
  // Getters
  Content? get content => _content;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  PdfViewerController get pdfController => _pdfController;
  String? get documentPath => _content?.file;
  
  // Enhanced getters
  StudentAnnotationType get currentTool => _currentTool;
  Color get currentColor => _currentColor;
  double get strokeWidth => _strokeWidth;
  bool get isAnnotationMode => _isAnnotationMode;
  List<Offset> get currentStroke => _currentStroke;
  StudentTextNote? get pendingTextNote => _pendingTextNote;
  
  // Get annotations for current page
  int get currentPage => _pdfController.pageNumber;
  List<StudentStroke> get currentPageStrokes => _strokes[currentPage] ?? [];
  List<StudentTextNote> get currentPageTextNotes => _textNotes[currentPage] ?? [];
  
  // Student color palettes
  List<Color> get highlightColors => [
    Colors.yellow.withOpacity(0.4),
    Colors.green.withOpacity(0.4),
    Colors.blue.withOpacity(0.4),
    Colors.pink.withOpacity(0.4),
    Colors.orange.withOpacity(0.4),
  ];
  
  List<Color> get drawingColors => [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.purple,
    Colors.orange,
    Colors.black,
  ];
  
  /// Initialize the PDF viewer
  Future<void> initialize(BuildContext context) async {
    try {
      debugPrint('SimpleStudentPdfVm: Starting initialization for contentId: $contentId');
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();
      
      // Load content from database
      debugPrint('SimpleStudentPdfVm: Loading content from database...');
      _content = await DatabaseHelper.instance.getContentById(contentId);
      if (_content == null) {
        throw Exception('Document not found with ID: $contentId');
      }
      
      debugPrint('SimpleStudentPdfVm: Content loaded - title: ${_content!.title}');
      debugPrint('SimpleStudentPdfVm: Content file path: ${_content!.file}');
      
      // Check if content has a file
      if (_content!.file == null || _content!.file!.isEmpty) {
        throw Exception('No PDF file associated with this document');
      }
      
      // Verify file exists
      final file = File(_content!.file!);
      if (!file.existsSync()) {
        throw Exception('PDF file not found at: ${_content!.file}');
      }
      
      debugPrint('SimpleStudentPdfVm: PDF file verified, size: ${file.lengthSync()} bytes');
      
      // Load existing annotations
      await _loadAnnotations();
      
      debugPrint('SimpleStudentPdfVm: Initialization completed successfully');
      _isLoading = false;
      notifyListeners();
      
    } catch (e, stackTrace) {
      debugPrint('SimpleStudentPdfVm: Initialization error: $e');
      debugPrint('SimpleStudentPdfVm: Stack trace: $stackTrace');
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }
  
  /// Set annotation tool
  void setTool(StudentAnnotationType tool) {
    _currentTool = tool;
    _isAnnotationMode = true;
    notifyListeners();
  }
  
  /// Toggle annotation mode
  void toggleAnnotationMode() {
    _isAnnotationMode = !_isAnnotationMode;
    if (!_isAnnotationMode) {
      _currentStroke.clear();
      _pendingTextNote = null;
    }
    notifyListeners();
  }
  
  /// Set annotation color
  void setColor(Color color) {
    _currentColor = color;
    notifyListeners();
  }
  
  /// Set stroke width
  void setStrokeWidth(double width) {
    _strokeWidth = width;
    notifyListeners();
  }
  
  /// Start drawing/annotation
  void startStroke(Offset position) {
    if (!_isAnnotationMode) return;
    
    _currentStroke = [position];
    notifyListeners();
  }
  
  /// Add point to current stroke
  void addStrokePoint(Offset position) {
    if (!_isAnnotationMode || _currentStroke.isEmpty) return;
    
    _currentStroke.add(position);
    notifyListeners();
  }
  
  /// Finish current stroke
  void finishStroke() {
    if (!_isAnnotationMode || _currentStroke.length < 2) {
      _currentStroke.clear();
      return;
    }
    
    final stroke = StudentStroke(
      points: List.from(_currentStroke),
      color: _currentColor,
      width: _strokeWidth,
      type: _currentTool,
    );
    
    final page = currentPage;
    _strokes.putIfAbsent(page, () => []).add(stroke);
    _currentStroke.clear();
    
    _saveAnnotations();
    notifyListeners();
  }
  
  /// Start text note creation
  void startTextNote(Offset position) {
    if (!_isAnnotationMode || _currentTool != StudentAnnotationType.textNote) return;
    
    _pendingTextNote = StudentTextNote(
      position: position,
      text: '',
      color: _currentColor,
      createdAt: DateTime.now(),
    );
    notifyListeners();
  }
  
  /// Create text note
  void createTextNote(String text) {
    if (_pendingTextNote == null || text.trim().isEmpty) {
      _pendingTextNote = null;
      notifyListeners();
      return;
    }
    
    final note = StudentTextNote(
      position: _pendingTextNote!.position,
      text: text.trim(),
      color: _pendingTextNote!.color,
      createdAt: DateTime.now(),
    );
    
    final page = currentPage;
    _textNotes.putIfAbsent(page, () => []).add(note);
    _pendingTextNote = null;
    
    _saveAnnotations();
    notifyListeners();
  }
  
  /// Cancel text note creation
  void cancelTextNote() {
    _pendingTextNote = null;
    notifyListeners();
  }
  
  /// Clear all annotations on current page
  void clearCurrentPageAnnotations() {
    final page = currentPage;
    _strokes.remove(page);
    _textNotes.remove(page);
    _saveAnnotations();
    notifyListeners();
  }
  
  /// Undo last annotation on current page
  void undoLastAnnotation() {
    final page = currentPage;
    
    final pageStrokes = _strokes[page];
    final pageNotes = _textNotes[page];
    
    if (pageStrokes?.isNotEmpty == true) {
      pageStrokes!.removeLast();
      if (pageStrokes.isEmpty) _strokes.remove(page);
    } else if (pageNotes?.isNotEmpty == true) {
      pageNotes!.removeLast();
      if (pageNotes.isEmpty) _textNotes.remove(page);
    }
    
    _saveAnnotations();
    notifyListeners();
  }
  
  /// Load annotations from database
  Future<void> _loadAnnotations() async {
    try {
      if (_content?.metaData['student_annotations'] != null) {
        final data = _content!.metaData['student_annotations'] as Map<String, dynamic>;
        
        // Load strokes
        if (data['strokes'] != null) {
          final strokesData = data['strokes'] as Map<String, dynamic>;
          strokesData.forEach((pageStr, strokesList) {
            final page = int.tryParse(pageStr) ?? 1;
            _strokes[page] = (strokesList as List)
                .map((s) => StudentStroke.fromJson(s))
                .toList();
          });
        }
        
        // Load text notes
        if (data['textNotes'] != null) {
          final notesData = data['textNotes'] as Map<String, dynamic>;
          notesData.forEach((pageStr, notesList) {
            final page = int.tryParse(pageStr) ?? 1;
            _textNotes[page] = (notesList as List)
                .map((n) => StudentTextNote.fromJson(n))
                .toList();
          });
        }
        
        debugPrint('Loaded annotations: ${_strokes.length} pages with strokes, ${_textNotes.length} pages with notes');
      }
    } catch (e) {
      debugPrint('Error loading annotations: $e');
    }
  }
  
  /// Save annotations to database
  Future<void> _saveAnnotations() async {
    try {
      if (_content == null) return;
      
      final annotationData = {
        'strokes': _strokes.map((page, strokes) => 
            MapEntry(page.toString(), strokes.map((s) => s.toJson()).toList())),
        'textNotes': _textNotes.map((page, notes) => 
            MapEntry(page.toString(), notes.map((n) => n.toJson()).toList())),
        'lastSaved': DateTime.now().toIso8601String(),
      };
      
      final updatedContent = _content!.getUpdatedContentWithMeta(
        metaData: {
          ..._content!.metaData,
          'student_annotations': annotationData,
        },
      );
      
      await DatabaseHelper.instance.updateContent(updatedContent);
      _content = updatedContent;
      
      debugPrint('Saved annotations successfully');
    } catch (e) {
      debugPrint('Error saving annotations: $e');
    }
  }
  
  /// Navigation methods
  void goToPage(int page) => _pdfController.jumpToPage(page);
  void nextPage() => _pdfController.nextPage();
  void previousPage() => _pdfController.previousPage();
  void zoomIn() => _pdfController.zoomLevel = _pdfController.zoomLevel * 1.25;
  void zoomOut() => _pdfController.zoomLevel = _pdfController.zoomLevel * 0.8;
  
  @override
  void dispose() {
    _saveAnnotations();
    super.dispose();
  }
}
