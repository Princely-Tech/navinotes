import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_drawing_board/flutter_drawing_board.dart';
import 'package:flutter_drawing_board/paint_contents.dart';
import 'package:flutter_quill/flutter_quill.dart';
import '../../../../../models/note_page.dart';
import '../../../../../settings/time_helpers.dart';
import '../managers/text_box_manager.dart';

class PageController extends ChangeNotifier {
  final NotePage _page;
  final Function(NotePage) _onPageUpdated;
  // Private controllers
  late final QuillController _textController;
  late final TextBoxManager _textBoxManager;
  late final DrawingController _drawingController;

  // Auto-save
  Timer? _autoSaveTimer;
  bool _isDisposed = false;

  PageController({
    required NotePage page,
    required Function(NotePage) onPageUpdated,
  }) : _page = page,
       _onPageUpdated = onPageUpdated {
    _initializeControllers();
    _loadPageContent();
  }

  // Getters
  NotePage get page => _page;
  QuillController get textController => _textController;
  DrawingController get drawingController => _drawingController;
  TextBoxManager get textBoxManager => _textBoxManager;

  /// Get the drawing controller (always use pressure controller now)
  DrawingController get activeDrawingController {
    return _drawingController;
  }

  void _initializeControllers() {
    // Initialize text controller
    _textController = QuillController.basic();
    _textController.document.changes.listen((_) => _scheduleAutoSave());
    // Initialize text box manager
    _textBoxManager = TextBoxManager();
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

      

      // Load content into pressure controller
      for (var item in data) {
        if (item is Map<String, dynamic>) {
          final PaintContent? paintContent = _createPaintContentFromJson(item);
          if (paintContent != null) {
            _drawingController.addContent(paintContent);
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
        updatedAt: generateUnixTimestamp(),
      );

      // Notify parent about the update
      _onPageUpdated(updatedPage);

      debugPrint(
        'Auto-saved page ${_page.id}: text: ${textContentJson}, drawing: ${jsonList.length} items, text boxes: ${textBoxList.length}',
      );
    } catch (e) {
      debugPrint('Error auto-saving page content: $e');
    }
  }


  @override
  void dispose() {

    // Dispose controllers
    _textController.dispose();
    _drawingController.dispose();
    _textBoxManager.dispose();

    super.dispose();
  }
}
