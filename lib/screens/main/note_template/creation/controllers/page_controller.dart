import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_drawing_board/flutter_drawing_board.dart';
import 'package:flutter_drawing_board/paint_contents.dart';
import 'package:flutter_quill/flutter_quill.dart';
import '../../../../../models/note_page.dart';
import '../managers/text_box_manager.dart';
import '../models/stylus_settings.dart';
import 'pressure_drawing_controller.dart';

/// Manages all controllers and state for a single page
class PageController extends ChangeNotifier {
  final NotePage _page;
  final Function(NotePage) _onPageUpdated;
  final StylusSettings _stylusSettings;

  // Controllers
  late final QuillController _textController;
  late final DrawingController _drawingController;
  late final PressureDrawingController _pressureController;
  late final TextBoxManager _textBoxManager;

  // Auto-save
  Timer? _autoSaveTimer;
  bool _isDisposed = false;

  PageController({
    required NotePage page,
    required Function(NotePage) onPageUpdated,
    required StylusSettings stylusSettings,
  })  : _page = page,
        _onPageUpdated = onPageUpdated,
        _stylusSettings = stylusSettings {
    _initializeControllers();
    _loadPageContent();
  }

  // Getters
  NotePage get page => _page;
  QuillController get textController => _textController;
  DrawingController get drawingController => _drawingController;
  PressureDrawingController get pressureController => _pressureController;
  TextBoxManager get textBoxManager => _textBoxManager;

  /// Get the appropriate drawing controller based on stylus settings
  DrawingController get activeDrawingController {
    return _stylusSettings.pressureSensitivityEnabled 
        ? _pressureController.drawingController 
        : _drawingController;
  }

  void _initializeControllers() {
    // Initialize text controller
    _textController = QuillController.basic();
    _textController.document.changes.listen((_) => _scheduleAutoSave());

    // Initialize drawing controllers
    _drawingController = DrawingController();
    _pressureController = PressureDrawingController(stylusSettings: _stylusSettings);

    // Initialize text box manager
    _textBoxManager = TextBoxManager();
    _textBoxManager.addListener(_scheduleAutoSave);
  }

  void _loadPageContent() {
    try {
      // Load text content
      if (_page.textContent != null && _page.textContent!.isNotEmpty) {
        try {
          _textController.document = Document.fromJson(
            jsonDecode(_page.textContent!),
          );
        } catch (e) {
          debugPrint('Error loading page text content: $e');
        }
      }

      // Load drawing content
      if (_page.drawingData != null && _page.drawingData!.isNotEmpty) {
        _loadDrawingContent(_page.drawingData!);
      }

      // Load text box content
      if (_page.textBoxData != null && _page.textBoxData!.isNotEmpty) {
        try {
          final List<dynamic> textBoxData = jsonDecode(_page.textBoxData!);
          _textBoxManager.loadFromJson(textBoxData);
        } catch (e) {
          debugPrint('Error loading text box content: $e');
        }
      }
    } catch (e) {
      debugPrint('Error loading page content: $e');
    }
  }

  void _loadDrawingContent(String drawingData) {
    try {
      final List<dynamic> data = jsonDecode(drawingData);
      
      // Clear both controllers
      _drawingController.clear();
      _pressureController.clear();

      // Load content into both controllers for compatibility
      for (var item in data) {
        if (item is Map<String, dynamic>) {
          final PaintContent? paintContent = _createPaintContentFromJson(item);
          if (paintContent != null) {
            _drawingController.addContent(paintContent);
            _pressureController.addContent(paintContent);
          }
        }
      }

      debugPrint('Loaded ${data.length} drawing items for page ${_page.id}');
    } catch (e) {
      debugPrint('Error loading drawing content: $e');
    }
  }

  PaintContent? _createPaintContentFromJson(Map<String, dynamic> item) {
    try {
      final String type = item['type'] as String;
      switch (type) {
        case 'SimpleLine':
          return SimpleLine.fromJson(item);
        case 'SmoothLine':
          return SmoothLine.fromJson(item);
        case 'StraightLine':
          return StraightLine.fromJson(item);
        case 'Rectangle':
          return Rectangle.fromJson(item);
        case 'Circle':
          return Circle.fromJson(item);
        case 'Eraser':
          return Eraser.fromJson(item);
        default:
          debugPrint('Unknown paint content type: $type');
          return null;
      }
    } catch (e) {
      debugPrint('Error creating paint content from JSON: $e');
      return null;
    }
  }

  void _scheduleAutoSave() {
    if (_isDisposed) return;
    
    _autoSaveTimer?.cancel();
    _autoSaveTimer = Timer(const Duration(milliseconds: 500), () {
      if (!_isDisposed) {
        _savePageContent();
      }
    });
  }

  Future<void> _savePageContent() async {
    if (_isDisposed) return;

    try {
      // Save text content
      final textContent = _textController.document.toDelta().toJson();
      final textContentJson = JsonEncoder.withIndent('  ').convert(textContent);

      // Save drawing content (use active controller)
      final activeController = activeDrawingController;
      final jsonList = activeController.getJsonList();
      final drawingContent = JsonEncoder.withIndent('  ').convert(jsonList);

      // Save text box content
      final textBoxList = _textBoxManager.toJson();
      final textBoxContent = JsonEncoder.withIndent('  ').convert(textBoxList);

      // Create updated page
      final updatedPage = _page.copyWith(
        textContent: textContentJson,
        drawingData: drawingContent,
        textBoxData: textBoxContent,
        updatedAt: DateTime.now().millisecondsSinceEpoch,
      );

      // Notify parent about the update
      _onPageUpdated(updatedPage);

      debugPrint('Auto-saved page ${_page.id}: ${jsonList.length} drawing items, ${textBoxList.length} text boxes');
    } catch (e) {
      debugPrint('Error auto-saving page content: $e');
    }
  }

  /// Force save page content immediately
  Future<void> forceSave() async {
    _autoSaveTimer?.cancel();
    await _savePageContent();
  }

  /// Update stylus settings for pressure controller
  void updateStylusSettings(StylusSettings settings) {
    _pressureController.updateStylusSettings(settings);
  }

  /// Clear all drawing content
  void clearDrawing() {
    _drawingController.clear();
    _pressureController.clear();
    _scheduleAutoSave();
    notifyListeners();
  }

  /// Undo last drawing action
  void undoDrawing() {
    activeDrawingController.undo();
    _scheduleAutoSave();
    notifyListeners();
  }

  /// Redo last undone drawing action
  void redoDrawing() {
    activeDrawingController.redo();
    _scheduleAutoSave();
    notifyListeners();
  }

  /// Check if undo is available
  bool canUndoDrawing() => activeDrawingController.canUndo();

  /// Check if redo is available
  bool canRedoDrawing() => activeDrawingController.canRedo();

  /// Add text box at position
  void addTextBox(Offset position, {String? text}) {
    _textBoxManager.addTextBox(position, text: text);
    _scheduleAutoSave();
    notifyListeners();
  }

  /// Select text box
  void selectTextBox(String? textBoxId) {
    _textBoxManager.selectTextBox(textBoxId);
    notifyListeners();
  }

  /// Start editing text box
  void startEditingTextBox(String textBoxId) {
    _textBoxManager.startEditing(textBoxId);
    notifyListeners();
  }

  /// Stop editing text box
  void stopEditingTextBox() {
    _textBoxManager.stopEditing();
    _scheduleAutoSave();
    notifyListeners();
  }

  /// Delete text box
  void deleteTextBox(String textBoxId) {
    _textBoxManager.deleteTextBox(textBoxId);
    _scheduleAutoSave();
    notifyListeners();
  }

  /// Clear text box selection
  void clearTextBoxSelection() {
    _textBoxManager.clearSelection();
    notifyListeners();
  }

  @override
  void dispose() {
    _isDisposed = true;
    _autoSaveTimer?.cancel();
    
    // Force final save before disposal
    _savePageContent();
    
    // Dispose controllers
    _textController.dispose();
    _drawingController.dispose();
    _pressureController.dispose();
    _textBoxManager.dispose();
    
    super.dispose();
  }
}
