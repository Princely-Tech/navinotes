import 'package:navinotes/packages.dart';
import 'package:navinotes/screens/main/pdf_view/vm.dart';
import 'package:navinotes/screens/main/pdf_view/header.dart';

class PdfViewMain extends StatelessWidget {
  const PdfViewMain({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PdfViewVm>(
      builder: (_, vm, _) {
        return PopScope(
          canPop: false,
          onPopInvoked: (didPop) async {
            if (didPop) return;

            final shouldExit = await vm.handleExit(context);
            if (shouldExit && context.mounted) {
              Navigator.of(context).pop();
            }
          },
          child: Column(
            children: [PdfViewHeader(), Expanded(child: _buildContent(vm))],
          ),
        );
      },
    );
  }
}

class _AnnotationToolbar extends StatelessWidget {
  final PdfViewVm vm;
  const _AnnotationToolbar({required this.vm});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 2)),
        ],
        border: Border.all(color: Colors.black12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          _toolButton(
            icon: Icons.pan_tool_alt,
            label: 'None',
            active: vm.currentMode == PdfAnnotMode.none,
            onTap: () => vm.setMode(PdfAnnotMode.none),
          ),
          _toolButton(
            icon: Icons.brush,
            label: 'Ink',
            active: vm.currentMode == PdfAnnotMode.drawing,
            onTap: () => vm.setMode(PdfAnnotMode.drawing),
          ),
          _toolButton(
            icon: Icons.highlight,
            label: 'Highlight',
            active: vm.currentMode == PdfAnnotMode.highlight,
            onTap: () => vm.setMode(PdfAnnotMode.highlight),
          ),
          // _toolButton(
          //   icon: Icons.text_fields,
          //   label: 'Text',
          //   active: vm.currentMode == PdfAnnotMode.text,
          //   onTap: () => vm.setMode(PdfAnnotMode.text),
          // ),
          // _toolButton(
          //   icon: Icons.image_outlined,
          //   label: 'Image',
          //   active: vm.currentMode == PdfAnnotMode.image,
          //   onTap: () => vm.setMode(PdfAnnotMode.image),
          // ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: vm.canUndo ? () => vm.undo() : null,
            icon: const Icon(Icons.undo, size: 18),
            tooltip: 'Undo',
          ),
          IconButton(
            onPressed: vm.canRedo ? () => vm.redo() : null,
            icon: const Icon(Icons.redo, size: 18),
            tooltip: 'Redo',
          ),
          if (vm.hasSelectedAnnotation)
            IconButton(
              onPressed: () => vm.deleteSelectedAnnotation(),
              icon: const Icon(Icons.delete, size: 18),
              tooltip: 'Delete selected annotation',
              color: Colors.red,
            ),
          ElevatedButton.icon(
            onPressed:
                vm.hasAnnotations
                    ? () async {
                      try {
                        await vm.saveAnnotations();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Annotations saved successfully'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Failed to save annotations: $e'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                    : null,
            icon:
                vm.isLoading
                    ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                    : const Icon(Icons.save, size: 18),
            label: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Widget _toolButton({
    required IconData icon,
    required String label,
    required bool active,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            color: active ? Colors.blue.shade50 : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 18,
                color: active ? Colors.blue : Colors.black87,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  color: active ? Colors.blue : Colors.black87,
                  fontWeight: active ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AnnotationOverlayPainter extends CustomPainter {
  final PdfViewVm vm;
  _AnnotationOverlayPainter(this.vm);

  final Paint _strokePaint =
      Paint()
        ..color = Colors.redAccent
        ..strokeWidth = 2.5
        ..style = PaintingStyle.stroke
        ..strokeJoin = StrokeJoin.round
        ..strokeCap = StrokeCap.round;

  final Paint _selectedStrokePaint =
      Paint()
        ..color = Colors.blue
        ..strokeWidth = 3.0
        ..style = PaintingStyle.stroke
        ..strokeJoin = StrokeJoin.round
        ..strokeCap = StrokeCap.round;

  final Paint _highlightPaint =
      Paint()
        ..color = Colors.yellow.withOpacity(0.3)
        ..style = PaintingStyle.fill;

  final Paint _selectedHighlightPaint =
      Paint()
        ..color = Colors.blue.withOpacity(0.3)
        ..style = PaintingStyle.fill;

  final Paint _selectionBorderPaint =
      Paint()
        ..color = Colors.blue
        ..strokeWidth = 2.0
        ..style = PaintingStyle.stroke;

  @override
  void paint(Canvas canvas, Size size) {
    // Draw ink strokes
    final strokes = vm.pageStrokes[vm.currentPageNumber] ?? const [];
    for (int strokeIndex = 0; strokeIndex < strokes.length; strokeIndex++) {
      final stroke = strokes[strokeIndex];
      if (stroke.length < 2) continue;

      final isSelected =
          vm.selectedStrokeIndex == strokeIndex &&
          vm.selectedAnnotationPage == vm.currentPageNumber;
      final paint = isSelected ? _selectedStrokePaint : _strokePaint;

      // Transform PDF coordinates to screen coordinates for rendering
      final first = vm.pdfToScreenCoordinates(stroke.first, size);
      final path = Path()..moveTo(first.dx, first.dy);
      for (int i = 1; i < stroke.length; i++) {
        final screenPoint = vm.pdfToScreenCoordinates(stroke[i], size);
        path.lineTo(screenPoint.dx, screenPoint.dy);
      }
      canvas.drawPath(path, paint);
    }

    // Draw highlights
    final highlights = vm.pageHighlights[vm.currentPageNumber] ?? const [];
    for (
      int highlightIndex = 0;
      highlightIndex < highlights.length;
      highlightIndex++
    ) {
      final highlight = highlights[highlightIndex];
      final isSelected =
          vm.selectedHighlightIndex == highlightIndex &&
          vm.selectedAnnotationPage == vm.currentPageNumber;

      // Transform PDF coordinates to screen coordinates
      final topLeft = vm.pdfToScreenCoordinates(
        Offset(highlight.left, highlight.top),
        size,
      );
      final bottomRight = vm.pdfToScreenCoordinates(
        Offset(highlight.right, highlight.bottom),
        size,
      );

      final rect = Rect.fromPoints(topLeft, bottomRight);

      // Draw highlight fill
      canvas.drawRect(
        rect,
        isSelected ? _selectedHighlightPaint : _highlightPaint,
      );

      // Draw selection border if selected
      if (isSelected) {
        canvas.drawRect(rect, _selectionBorderPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _AnnotationOverlayPainter oldDelegate) {
    // Repaint whenever the annotations change or page changes
    return oldDelegate.vm.pageStrokes != vm.pageStrokes ||
        oldDelegate.vm.pageHighlights != vm.pageHighlights ||
        oldDelegate.vm.currentPageNumber != vm.currentPageNumber ||
        oldDelegate.vm.selectedStrokeIndex != vm.selectedStrokeIndex ||
        oldDelegate.vm.selectedHighlightIndex != vm.selectedHighlightIndex ||
        oldDelegate.vm.selectedAnnotationPage != vm.selectedAnnotationPage;
  }
}

Widget _buildContent(PdfViewVm vm) {
  // Show loading state
  if (vm.isLoading) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text(
            'Loading PDF...',
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  // Show error state
  if (vm.errorMessage != null) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.red[400]),
          SizedBox(height: 16),
          Text(
            'Error Loading PDF',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.red[700],
            ),
          ),
          SizedBox(height: 8),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              vm.errorMessage!,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ),
          SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => NavigationHelper.pop(),
            child: Text('Go Back'),
          ),
        ],
      ),
    );
  }

  // Show PDF viewer if document is loaded
  debugPrint('PdfViewMain: Checking document state...');
  debugPrint('PdfViewMain: vm.comPdfVm.document = ${vm.comPdfVm.document}');
  debugPrint(
    'PdfViewMain: document isEmpty = ${(vm.comPdfVm.document ?? '').isEmpty}',
  );

  if ((vm.comPdfVm.document ?? '').isNotEmpty) {
    debugPrint(
      'Rendering ComPDF viewer with document: ${vm.comPdfVm.document}',
    );

    // Use ComPDF viewer with annotation overlay
    return LayoutBuilder(
      builder: (context, constraints) {
        debugPrint(
          'ComPDF layout size: ${constraints.maxWidth}x${constraints.maxHeight}',
        );
        // Simplified: Direct CPDFReaderWidget without Stack for testing
        try {
          debugPrint('ComPDF: Attempting to create CPDFReaderWidget');
          debugPrint('ComPDF: Document path: ${vm.comPdfVm.document}');
          debugPrint(
            'ComPDF: File exists: ${File(vm.comPdfVm.document!).existsSync()}',
          );

          return CPDFReaderWidget(
            key: ValueKey('${vm.comPdfVm.document}-${vm.viewerReloadTick}'),
            document: vm.comPdfVm.document!,
            configuration: CPDFConfiguration(
              toolbarConfig: CPDFToolbarConfig(
                mainToolbarVisible: true, // Enable toolbar temporarily to test
              ),
              readerViewConfig: CPDFReaderViewConfig(formFieldHighlight: false),
            ),
            onSaveCallback: () {
              debugPrint('ComPDF: Document saved');
            },
            onCreated: (controller) {
              debugPrint('ComPDF: Reader created with controller: $controller');
              vm.setComPdfController(controller);
            },
          );
        } catch (e, stackTrace) {
          debugPrint('ComPDF: Error creating CPDFReaderWidget: $e');
          debugPrint('ComPDF: Stack trace: $stackTrace');
          return Container(
            color: Colors.red.withOpacity(0.1),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error, color: Colors.red, size: 64),
                  SizedBox(height: 16),
                  Text('ComPDF Error: $e'),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  // Fallback loading state
  debugPrint(
    'PdfViewMain: Falling back to loading state - document not loaded yet',
  );
  debugPrint('PdfViewMain: VM loading state: ${vm.isLoading}');
  debugPrint('PdfViewMain: VM error message: ${vm.errorMessage}');

  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const CircularProgressIndicator(),
        const SizedBox(height: 16),
        Text(
          vm.isLoading ? 'Loading PDF...' : 'Waiting for document...',
          style: const TextStyle(fontSize: 16),
        ),
        if (vm.errorMessage != null) ...[
          const SizedBox(height: 8),
          Text(
            'Error: ${vm.errorMessage}',
            style: const TextStyle(color: Colors.red, fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    ),
  );
}
