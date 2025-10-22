import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_drawing_board/flutter_drawing_board.dart';
import 'package:flutter_drawing_board/paint_contents.dart';
import 'package:flutter_quill/flutter_quill.dart';
import '../../../../../models/note_page.dart';
import '../../../../../settings/time_helpers.dart';
import '../managers/text_box_manager.dart';
import '../models/stylus_settings.dart';
import 'pressure_drawing_controller.dart';

class PageController extends ChangeNotifier {
  final NotePage _page;
  final Function(NotePage) _onPageUpdated;
  final StylusSettings _stylusSettings;

  // Private controllers
  late final QuillController _textController;
  late final PressureDrawingController _pressureController;
  late final TextBoxManager _textBoxManager;

  // Auto-save
  Timer? _autoSaveTimer;
  bool _isDisposed = false;

  PageController({
    required NotePage page,
    required Function(NotePage) onPageUpdated,
    required StylusSettings stylusSettings,
  }) : _page = page,
       _onPageUpdated = onPageUpdated,
       _stylusSettings = stylusSettings {
    _initializeControllers();
    _loadPageContent();
  }

  // Getters
  NotePage get page => _page;
  QuillController get textController => _textController;
  DrawingController get drawingController =>
      _pressureController.drawingController;
  PressureDrawingController get pressureController => _pressureController;
  TextBoxManager get textBoxManager => _textBoxManager;

  /// Get the drawing controller (always use pressure controller now)
  DrawingController get activeDrawingController {
    return _pressureController.drawingController;
  }

  void _initializeControllers() {
    // Initialize text controller
    _textController = QuillController.basic();
    _textController.document.changes.listen((_) => _scheduleAutoSave());

    // Initialize pressure drawing controller (which wraps a regular drawing controller)
    _pressureController = PressureDrawingController(
      stylusSettings: _stylusSettings,
    );

    // Add listener for drawing controller changes (for in-memory auto-save)
    _pressureController.addListener(_scheduleAutoSave);

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
          // Move cursor to end of existing text
          _moveCursorToEnd();
        } catch (e) {
          if (kDebugMode) {
            debugPrint('Error loading page text content: ${e.toString()}');
          }
        }
      } else {
        // For empty pages, position cursor at the beginning (ready for typing)
        _textController.updateSelection(
          const TextSelection.collapsed(offset: 0),
          ChangeSource.local,
        );
        debugPrint('Positioned cursor at start for empty page');
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
          if (kDebugMode) {
            debugPrint('Error loading text box content: ${e.toString()}');
          }
        }
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error loading page content: ${e.toString()}');
      }
    }
  }

  void _loadDrawingContent(String drawingData) {
    try {
      final List<dynamic> data = jsonDecode(drawingData);

      // Clear pressure controller (which handles the drawing)
      _pressureController.clear();

      // Load content into pressure controller
      for (var item in data) {
        if (item is Map<String, dynamic>) {
          final PaintContent? paintContent = _createPaintContentFromJson(item);
          if (paintContent != null) {
            _pressureController.addContent(paintContent);
          }
        }
      }

      debugPrint('Loaded ${data.length} drawing items for page ${_page.id}');
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error loading drawing content: ${e.toString()}');
      }
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
      if (kDebugMode) {
        debugPrint('Error creating paint content from JSON: ${e.toString()}');
      }
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
        updatedAt: generateUnixTimestamp(),
      );

      // Notify parent about the update
      _onPageUpdated(updatedPage);

      debugPrint(
        'Auto-saved page ${_page.id}: text: ${textContentJson}, drawing: ${jsonList.length} items, text boxes: ${textBoxList.length}',
      );
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error auto-saving page content: ${e.toString()}');
      }
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

  /// Move cursor to end of text content
  void _moveCursorToEnd() {
    try {
      final length = _textController.document.length;
      if (length > 0) {
        _textController.updateSelection(
          TextSelection.collapsed(offset: length - 1),
          ChangeSource.local,
        );
        debugPrint('Moved cursor to end of text (position: ${length - 1})');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error moving cursor to end: ${e.toString()}');
      }
    }
  }

  /// Public method to move cursor to end (for external calls)
  void moveCursorToEnd() {
    _moveCursorToEnd();
  }

  @override
  void dispose() {
    _isDisposed = true;
    _autoSaveTimer?.cancel();

    // Force final save before disposal
    _savePageContent();

    // Remove listeners before disposing
    _pressureController.removeListener(_scheduleAutoSave);
    _textBoxManager.removeListener(_scheduleAutoSave);

    // Dispose controllers
    _textController.dispose();
    _pressureController.dispose();
    _textBoxManager.dispose();

    super.dispose();
  }
}
