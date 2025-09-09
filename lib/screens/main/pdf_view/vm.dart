import 'package:navinotes/packages.dart';

enum PdfAnnotMode { none, drawing, highlight, text, image }

class PdfViewVm extends ChangeNotifier {
  GlobalKey<ScaffoldState> scaffoldKey;
  ComPdfVm comPdfVm;
  int contentId;
  Content? content;
  bool isLoading = true;
  String? errorMessage;
  // Temporary flag to force loading a sample PDF from assets for testing
  bool useSampleAssetPdf = false;
  // Temporary flag to render with Syncfusion viewer instead of ComPDFKit for diagnostics
  bool useSyncfusionFallback = true;

  PdfViewVm({
    required this.scaffoldKey,
    required this.comPdfVm,
    required this.contentId,
  });

  String currentPdfPath = '';

  // Syncfusion viewer controller and state
  final PdfViewerController sfController = PdfViewerController();
  int currentPageNumber = 1;
  int viewerReloadTick = 0;

  // Annotation state
  PdfAnnotMode currentMode = PdfAnnotMode.none;
  // Map of pageNumber -> list of strokes (each stroke is list of normalized points 0..1)
  final Map<int, List<List<Offset>>> pageStrokes = {};
  // Map of pageNumber -> list of highlight rectangles
  final Map<int, List<Rect>> pageHighlights = {};
  
  // Undo/Redo functionality
  final List<Map<String, dynamic>> _annotationHistory = [];
  int _historyIndex = -1;
  static const int _maxHistorySize = 50;

  // Uint8List? pdfData;

  // void updatePdfData(Uint8List data) {
  //   pdfData = data;
  //   notifyListeners();
  // }

  Future<void> initialize(BuildContext context) async {
    try {
      isLoading = true;
      notifyListeners();

      if (useSampleAssetPdf) {
        // Load from bundled asset for testing
        currentPdfPath = 'assets/example.pdf';
        debugPrint('PdfViewVm: Using sample asset PDF => $currentPdfPath');
        comPdfVm.initialize(context, currentPdfPath);
      } else {
        // Load content from database (original behavior)
        content = await DatabaseHelper.instance.getContentById(contentId);

        if (content == null) {
          errorMessage = 'Content not found';
          isLoading = false;
          notifyListeners();
          return;
        }

        // Check if content has a file path
        if (content!.file == null || content!.file!.isEmpty) {
          errorMessage = 'PDF file not found for this content';
          isLoading = false;
          notifyListeners();
          return;
        }

        // Verify file exists
        final file = File(content!.file!);
        if (!await file.exists()) {
          errorMessage = 'PDF file does not exist at: ${content!.file}';
          isLoading = false;
          notifyListeners();
          return;
        }

        // Update current PDF path and initialize ComPdfVm
        currentPdfPath = content!.file!;
        comPdfVm.initialize(context, currentPdfPath);
        
        // Skip loading annotations from metadata to avoid conflicts with PDF-embedded annotations
        // _loadAnnotationsFromMetadata();
      }

      // Initialize undo/redo history with empty state
      _saveAnnotationState();
      
      isLoading = false;
      notifyListeners();
    } catch (e) {
      debugPrint('Error initializing PDF view: $e');
      errorMessage = 'Error loading PDF: $e';
      isLoading = false;
      notifyListeners();
    }
  }

  // // String currentPdfPath = 'assets/example.pdf';

  // // void updatePdfPath(String newPath) {
  // //   currentPdfPath = newPath;
  // //   notifyListeners();
  // // }

  void openDrawer() {
    scaffoldKey.currentState?.openEndDrawer();
  }

  // Annotation helpers
  void setMode(PdfAnnotMode mode) {
    currentMode = mode;
    notifyListeners();
  }

  void setCurrentPage(int pageNumber) {
    if (currentPageNumber != pageNumber) {
      currentPageNumber = pageNumber;
      notifyListeners();
    }
  }

  void startStroke() {
    pageStrokes.putIfAbsent(currentPageNumber, () => []);
    pageStrokes[currentPageNumber]!.add([]);
  }

  void addPointWithSize(Offset p, Size size) {
    if (size.width == 0 || size.height == 0) return;
    final strokes = pageStrokes[currentPageNumber];
    if (strokes == null || strokes.isEmpty) return;
    
    // Transform screen coordinates to PDF document coordinates
    final pdfPoint = _screenToPdfCoordinates(p, size);
    strokes.last.add(pdfPoint);
    notifyListeners();
  }

  void endStroke() {
    // Save state for undo/redo after completing stroke
    _saveAnnotationState();
    markAsUnsaved();
    notifyListeners();
  }

  void clearCurrentPageAnnotations() {
    if (pageStrokes.containsKey(currentPageNumber)) {
      pageStrokes.remove(currentPageNumber);
    }
    if (pageHighlights.containsKey(currentPageNumber)) {
      pageHighlights.remove(currentPageNumber);
    }
    notifyListeners();
  }

  void clearAllAnnotations() {
    pageStrokes.clear();
    pageHighlights.clear();
    notifyListeners();
  }

  bool get hasAnnotations => pageStrokes.isNotEmpty || pageHighlights.isNotEmpty;
  bool get hasCurrentPageAnnotations => 
      (pageStrokes.containsKey(currentPageNumber) && pageStrokes[currentPageNumber]!.isNotEmpty) ||
      (pageHighlights.containsKey(currentPageNumber) && pageHighlights[currentPageNumber]!.isNotEmpty);
  
  // Track if there are unsaved changes
  bool _hasUnsavedChanges = false;
  bool get hasUnsavedChanges => _hasUnsavedChanges;
  
  void markAsUnsaved() {
    _hasUnsavedChanges = true;
    notifyListeners();
  }
  
  void markAsSaved() {
    _hasUnsavedChanges = false;
    notifyListeners();
  }

  // Highlight annotation methods
  Offset? _highlightStart;
  
  // Selection state for annotation deletion
  int? _selectedStrokeIndex;
  int? _selectedHighlightIndex;
  int? _selectedAnnotationPage;
  
  void startHighlight(Offset position, Size size) {
    if (size.width == 0 || size.height == 0) return;
    _highlightStart = _screenToPdfCoordinates(position, size);
  }
  
  void updateHighlight(Offset position, Size size) {
    // Live preview of highlight rectangle during drag
    if (_highlightStart != null && size.width > 0 && size.height > 0) {
      notifyListeners(); // Trigger repaint for live preview
    }
  }

  void endHighlight(Offset position, Size size) {
    if (_highlightStart == null || size.width == 0 || size.height == 0) return;
    
    final pdfEnd = _screenToPdfCoordinates(position, size);
    final rect = Rect.fromPoints(_highlightStart!, pdfEnd);
    
    // Only add highlight if it has meaningful size
    if (rect.width > 0.005 && rect.height > 0.005) { // Reduced threshold for better responsiveness
      pageHighlights.putIfAbsent(currentPageNumber, () => []);
      pageHighlights[currentPageNumber]!.add(rect);
      _saveAnnotationState();
      markAsUnsaved();
      notifyListeners();
    }
    
    _highlightStart = null;
  }

  // Undo/Redo methods
  void _saveAnnotationState() {
    final state = {
      'strokes': Map<int, List<List<Offset>>>.from(
        pageStrokes.map((k, v) => MapEntry(k, v.map((stroke) => List<Offset>.from(stroke)).toList()))
      ),
      'highlights': Map<int, List<Rect>>.from(
        pageHighlights.map((k, v) => MapEntry(k, List<Rect>.from(v)))
      ),
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    };
    
    // Remove any history after current index (when undoing then making new changes)
    if (_historyIndex < _annotationHistory.length - 1) {
      _annotationHistory.removeRange(_historyIndex + 1, _annotationHistory.length);
    }
    
    _annotationHistory.add(state);
    _historyIndex = _annotationHistory.length - 1;
    
    // Limit history size
    if (_annotationHistory.length > _maxHistorySize) {
      _annotationHistory.removeAt(0);
      _historyIndex--;
    }
  }
  
  void _restoreAnnotationState(Map<String, dynamic> state) {
    pageStrokes.clear();
    pageHighlights.clear();
    
    if (state['strokes'] != null) {
      final strokesData = state['strokes'] as Map<dynamic, dynamic>;
      strokesData.forEach((key, value) {
        final pageNum = key is int ? key : int.tryParse(key.toString());
        if (pageNum != null && value is List) {
          pageStrokes[pageNum] = (value as List).map((stroke) {
            if (stroke is List) {
              return stroke.map((point) {
                if (point is Offset) return point;
                if (point is Map) {
                  return Offset(
                    (point['dx'] ?? point['x'] ?? 0.0).toDouble(),
                    (point['dy'] ?? point['y'] ?? 0.0).toDouble(),
                  );
                }
                return Offset.zero;
              }).toList();
            }
            return <Offset>[];
          }).toList();
        }
      });
    }
    
    if (state['highlights'] != null) {
      final highlightsData = state['highlights'] as Map<dynamic, dynamic>;
      highlightsData.forEach((key, value) {
        final pageNum = key is int ? key : int.tryParse(key.toString());
        if (pageNum != null && value is List) {
          pageHighlights[pageNum] = (value as List).map((highlight) {
            if (highlight is Rect) return highlight;
            if (highlight is Map) {
              return Rect.fromLTWH(
                (highlight['left'] ?? 0.0).toDouble(),
                (highlight['top'] ?? 0.0).toDouble(),
                (highlight['width'] ?? 0.0).toDouble(),
                (highlight['height'] ?? 0.0).toDouble(),
              );
            }
            return Rect.zero;
          }).toList();
        }
      });
    }
    
    notifyListeners();
  }
  
  bool get canUndo => _historyIndex > 0;
  bool get canRedo => _historyIndex < _annotationHistory.length - 1;
  
  void undo() {
    if (canUndo) {
      _historyIndex--;
      _restoreAnnotationState(_annotationHistory[_historyIndex]);
    }
  }
  
  void redo() {
    if (canRedo) {
      _historyIndex++;
      _restoreAnnotationState(_annotationHistory[_historyIndex]);
    }
  }
  
  // Selective annotation deletion
  void selectAnnotationAt(Offset position, Size size) {
    final pdfPos = _screenToPdfCoordinates(position, size);
    
    // Clear previous selection
    _selectedStrokeIndex = null;
    _selectedHighlightIndex = null;
    _selectedAnnotationPage = null;
    
    // Check highlights first (they're usually larger and easier to select)
    final highlights = pageHighlights[currentPageNumber];
    if (highlights != null) {
      for (int i = 0; i < highlights.length; i++) {
        if (highlights[i].contains(pdfPos)) {
          _selectedHighlightIndex = i;
          _selectedAnnotationPage = currentPageNumber;
          notifyListeners();
          return;
        }
      }
    }
    
    // Check strokes
    final strokes = pageStrokes[currentPageNumber];
    if (strokes != null) {
      for (int i = 0; i < strokes.length; i++) {
        final stroke = strokes[i];
        for (final point in stroke) {
          final distance = (point - pdfPos).distance;
          if (distance < 0.02) { // 2% tolerance
            _selectedStrokeIndex = i;
            _selectedAnnotationPage = currentPageNumber;
            notifyListeners();
            return;
          }
        }
      }
    }
    
    notifyListeners();
  }
  
  void deleteSelectedAnnotation() {
    if (_selectedAnnotationPage == null) return;
    
    bool deleted = false;
    
    if (_selectedHighlightIndex != null) {
      final highlights = pageHighlights[_selectedAnnotationPage!];
      if (highlights != null && _selectedHighlightIndex! < highlights.length) {
        highlights.removeAt(_selectedHighlightIndex!);
        if (highlights.isEmpty) {
          pageHighlights.remove(_selectedAnnotationPage!);
        }
        deleted = true;
      }
    } else if (_selectedStrokeIndex != null) {
      final strokes = pageStrokes[_selectedAnnotationPage!];
      if (strokes != null && _selectedStrokeIndex! < strokes.length) {
        strokes.removeAt(_selectedStrokeIndex!);
        if (strokes.isEmpty) {
          pageStrokes.remove(_selectedAnnotationPage!);
        }
        deleted = true;
      }
    }
    
    if (deleted) {
      _saveAnnotationState();
      markAsUnsaved();
      _selectedStrokeIndex = null;
      _selectedHighlightIndex = null;
      _selectedAnnotationPage = null;
      notifyListeners();
    }
  }
  
  bool get hasSelectedAnnotation => _selectedStrokeIndex != null || _selectedHighlightIndex != null;
  
  // Transform screen coordinates to PDF document coordinates
  Offset _screenToPdfCoordinates(Offset screenPoint, Size viewerSize) {
    if (viewerSize.width == 0 || viewerSize.height == 0) return Offset.zero;
    
    // Get current scroll offset and zoom from Syncfusion controller
    final scrollOffset = sfController.scrollOffset;
    final zoomLevel = sfController.zoomLevel;
    
    // Transform screen point to PDF document coordinates
    // Account for scroll offset and zoom level
    final adjustedX = (screenPoint.dx + scrollOffset.dx) / zoomLevel;
    final adjustedY = (screenPoint.dy + scrollOffset.dy) / zoomLevel;
    
    // Normalize to 0-1 range based on the actual PDF page size
    // Note: This assumes the PDF viewer fills the available space
    final normalizedX = adjustedX / viewerSize.width;
    final normalizedY = adjustedY / viewerSize.height;
    
    return Offset(normalizedX, normalizedY);
  }
  
  // Transform PDF document coordinates back to screen coordinates for rendering
  Offset pdfToScreenCoordinates(Offset pdfPoint, Size viewerSize) {
    if (viewerSize.width == 0 || viewerSize.height == 0) return Offset.zero;
    
    final scrollOffset = sfController.scrollOffset;
    final zoomLevel = sfController.zoomLevel;
    
    // Denormalize from 0-1 range to actual pixel coordinates
    final pixelX = pdfPoint.dx * viewerSize.width;
    final pixelY = pdfPoint.dy * viewerSize.height;
    
    // Apply zoom and subtract scroll offset to get screen coordinates
    final screenX = (pixelX * zoomLevel) - scrollOffset.dx;
    final screenY = (pixelY * zoomLevel) - scrollOffset.dy;
    
    return Offset(screenX, screenY);
  }
  
  // Getters for accessing private selection state
  int? get selectedStrokeIndex => _selectedStrokeIndex;
  int? get selectedHighlightIndex => _selectedHighlightIndex;
  int? get selectedAnnotationPage => _selectedAnnotationPage;

  void _loadAnnotationsFromMetadata() {
    try {
      if (content?.metaData['pdf_annotations'] != null) {
        final annotations = content!.metaData['pdf_annotations'] as Map<String, dynamic>;
        // Load strokes
        if (annotations['strokes'] != null) {
          final strokesData = annotations['strokes'] as Map<String, dynamic>;
          pageStrokes.clear();
          strokesData.forEach((pageStr, strokeList) {
            final pageNum = int.tryParse(pageStr);
            if (pageNum != null && strokeList is List) {
              pageStrokes[pageNum] = strokeList
                  .map((stroke) => (stroke as List)
                      .map((point) => Offset(
                          (point['x'] as num).toDouble(),
                          (point['y'] as num).toDouble()))
                      .toList())
                  .toList();
            }
          });
        }
        
        // Load highlights
        if (annotations['highlights'] != null) {
          final highlightsData = annotations['highlights'] as Map<String, dynamic>;
          pageHighlights.clear();
          highlightsData.forEach((pageStr, highlightList) {
            final pageNum = int.tryParse(pageStr);
            if (pageNum != null && highlightList is List) {
              pageHighlights[pageNum] = highlightList
                  .map((highlight) => Rect.fromLTWH(
                      (highlight['left'] as num).toDouble(),
                      (highlight['top'] as num).toDouble(),
                      (highlight['width'] as num).toDouble(),
                      (highlight['height'] as num).toDouble()))
                  .toList();
            }
          });
        }
        
        debugPrint('PdfViewVm: Loaded ${pageStrokes.length} pages of strokes and ${pageHighlights.length} pages of highlights');
        
        // Initialize history with loaded state
        _saveAnnotationState();
      }
    } catch (e) {
      debugPrint('PdfViewVm: Error loading annotations from metadata: $e');
    }
  }

  void toggleViewer() {
    useSyncfusionFallback = !useSyncfusionFallback;
    notifyListeners();
  }

  Future<void> saveAnnotations() async {
    try {
      // Show loading state during save
      final wasLoading = isLoading;
      if (!wasLoading) {
        isLoading = true;
        notifyListeners();
      }

      // 1) Embed ink into the PDF file (only ink for first iteration)
      if (currentPdfPath.isEmpty) {
        throw Exception('No PDF path available for saving');
      }
      final file = File(currentPdfPath);
      if (!await file.exists()) {
        throw Exception('PDF file not found at: $currentPdfPath');
      }

      final bytes = await file.readAsBytes();
      final pdf = PdfDocument(inputBytes: bytes);

      pageStrokes.forEach((pageNum, strokes) {
        if (pageNum < 1 || pageNum > pdf.pages.count) return;
        final page = pdf.pages[pageNum - 1];
        final size = Size(page.size.width, page.size.height);
        final pen = PdfPen(PdfColor(255, 0, 0))..width = 2.5;

        for (final stroke in strokes) {
          if (stroke.length < 2) continue;
          // Draw as polyline using denormalized coordinates
          for (int i = 1; i < stroke.length; i++) {
            final p1 = Offset(stroke[i - 1].dx * size.width, stroke[i - 1].dy * size.height);
            final p2 = Offset(stroke[i].dx * size.width, stroke[i].dy * size.height);
            page.graphics.drawLine(pen, p1, p2);
          }
        }
      });

      final out = await pdf.save();
      pdf.dispose();
      await file.writeAsBytes(out, flush: true);

      // Preserve current page before reload
      final currentPage = currentPageNumber;
      
      // Ask viewer to reload by changing a key source
      viewerReloadTick++;
      
      // Restore page position after reload
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (currentPage > 1) {
          sfController.jumpToPage(currentPage);
        }
      });

      // 2) Sidecar JSON in Content.metaData (ink only for now)
      if (content != null) {
        final ann = {
          'strokes': pageStrokes.map((k, v) => MapEntry(
              k.toString(),
              v
                  .map((stroke) => stroke
                      .map((p) => {'x': p.dx, 'y': p.dy})
                      .toList())
                  .toList())),
          'highlights': pageHighlights.map((k, v) => MapEntry(
              k.toString(),
              v
                  .map((rect) => {
                        'left': rect.left,
                        'top': rect.top,
                        'width': rect.width,
                        'height': rect.height,
                      })
                  .toList())),
          'saved_at': DateTime.now().toIso8601String(),
        };
        final updated = content!.getUpdatedContentWithMeta(metaData: {
          ...content!.metaData,
          'pdf_annotations': ann,
        });
        await DatabaseHelper.instance.updateContent(updated);
        debugPrint('PdfViewVm: Annotations saved successfully');
      }

      // Mark as saved after successful save
      markAsSaved();
      
      // Restore loading state
      if (!wasLoading) {
        isLoading = false;
      }
      notifyListeners();
    } catch (e, st) {
      debugPrint('PdfViewVm: saveAnnotations error: $e');
      debugPrint('$st');
      errorMessage = 'Failed to save annotations: $e';
      isLoading = false;
      notifyListeners();
      
      // Show error to user
      rethrow;
    }
  }
}
