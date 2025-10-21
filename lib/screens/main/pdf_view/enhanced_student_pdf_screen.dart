import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'simple_student_pdf_vm.dart';
import 'dart:io';

/// Enhanced student PDF viewer with rich annotation capabilities
class EnhancedStudentPdfScreen extends StatelessWidget {
  const EnhancedStudentPdfScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    // Get contentId from route arguments
    final String contentId =
        ModalRoute.of(context)?.settings.arguments as String;
    
    return ChangeNotifierProvider(
      create: (_) => SimpleStudentPdfVm(contentId: contentId),
      child: const _EnhancedStudentPdfView(),
    );
  }
}

class _EnhancedStudentPdfView extends StatefulWidget {
  const _EnhancedStudentPdfView();
  
  @override
  State<_EnhancedStudentPdfView> createState() => _EnhancedStudentPdfViewState();
}

class _EnhancedStudentPdfViewState extends State<_EnhancedStudentPdfView> {
  @override
  void initState() {
    super.initState();
    // Initialize the PDF viewer
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SimpleStudentPdfVm>().initialize(context);
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Consumer<SimpleStudentPdfVm>(
        builder: (context, vm, child) {
          if (vm.isLoading) {
            return _buildLoadingView(vm);
          }
          
          if (vm.errorMessage != null) {
            return _buildErrorView(vm);
          }
          
          return Stack(
            children: [
              Column(
                children: [
                  _buildHeader(context, vm),
                  Expanded(child: _buildPdfViewer(vm)),
                ],
              ),
              
              // Floating annotation toolbar
              if (vm.isAnnotationMode) 
                _buildAnnotationToolbar(vm),
              
              // Text note dialog
              if (vm.pendingTextNote != null)
                _buildTextNoteDialog(vm),
            ],
          );
        },
      ),
    );
  }
  
  Widget _buildLoadingView(SimpleStudentPdfVm vm) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            color: Colors.blue,
            strokeWidth: 3,
          ),
          const SizedBox(height: 24),
          Text(
            '📚 Loading your study material...',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            vm.content?.title ?? 'PDF Document',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
  
  Widget _buildErrorView(SimpleStudentPdfVm vm) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red[400],
            ),
            const SizedBox(height: 24),
            Text(
              'Oops! Something went wrong',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.red[700],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              vm.errorMessage!,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton.icon(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Go Back'),
                ),
                const SizedBox(width: 16),
                OutlinedButton.icon(
                  onPressed: () => vm.initialize(context),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildHeader(BuildContext context, SimpleStudentPdfVm vm) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Back button
            IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.arrow_back),
              tooltip: 'Back',
            ),
            
            const SizedBox(width: 16),
            
            // Document info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    vm.content?.title ?? 'PDF Document',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.school,
                        size: 16,
                        color: Colors.green[600],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Student PDF Viewer',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.green[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (vm.isAnnotationMode) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'Annotating',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.blue[700],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            
            // Action buttons
            Row(
              children: [
                // Annotation mode toggle
                IconButton(
                  onPressed: () => vm.toggleAnnotationMode(),
                  icon: Icon(
                    vm.isAnnotationMode ? Icons.edit_off : Icons.edit,
                    color: vm.isAnnotationMode ? Colors.blue : Colors.grey[600],
                  ),
                  tooltip: vm.isAnnotationMode ? 'Exit Annotation Mode' : 'Enter Annotation Mode',
                ),
                
                // Zoom out
                IconButton(
                  onPressed: () => vm.zoomOut(),
                  icon: const Icon(Icons.zoom_out),
                  tooltip: 'Zoom Out',
                ),
                
                // Zoom in
                IconButton(
                  onPressed: () => vm.zoomIn(),
                  icon: const Icon(Icons.zoom_in),
                  tooltip: 'Zoom In',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildPdfViewer(SimpleStudentPdfVm vm) {
    if (vm.documentPath == null) {
      return const Center(
        child: Text('No document path available'),
      );
    }
    
    return Stack(
      children: [
        // PDF Viewer
        Container(
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Stack(
              children: [
                SfPdfViewer.file(
                  File(vm.documentPath!),
                  controller: vm.pdfController,
                  enableDoubleTapZooming: true,
                  enableTextSelection: !vm.isAnnotationMode,
                  canShowScrollHead: true,
                  canShowScrollStatus: true,
                  canShowPaginationDialog: true,
                  onDocumentLoaded: (PdfDocumentLoadedDetails details) {
                    debugPrint('PDF loaded successfully: ${details.document.pages.count} pages');
                  },
                  onDocumentLoadFailed: (PdfDocumentLoadFailedDetails details) {
                    debugPrint('PDF load failed: ${details.error}');
                  },
                ),
                
                // Annotation overlay
                if (vm.isAnnotationMode)
                  Positioned.fill(
                    child: GestureDetector(
                      onTapDown: (details) => _handleTap(details.localPosition, vm),
                      onPanStart: (details) => _handlePanStart(details.localPosition, vm),
                      onPanUpdate: (details) => _handlePanUpdate(details.localPosition, vm),
                      onPanEnd: (details) => _handlePanEnd(vm),
                      child: CustomPaint(
                        painter: AnnotationPainter(
                          strokes: vm.currentPageStrokes,
                          textNotes: vm.currentPageTextNotes,
                          currentStroke: vm.currentStroke,
                          currentColor: vm.currentColor,
                          currentWidth: vm.strokeWidth,
                        ),
                        size: Size.infinite,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
  
  Widget _buildAnnotationToolbar(SimpleStudentPdfVm vm) {
    return Positioned(
      left: 20,
      right: 20,
      bottom: 30,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Tool selector
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildToolButton(
                      icon: Icons.highlight,
                      label: 'Highlight',
                      tool: StudentAnnotationType.highlight,
                      vm: vm,
                    ),
                    _buildToolButton(
                      icon: Icons.edit,
                      label: 'Draw',
                      tool: StudentAnnotationType.drawing,
                      vm: vm,
                    ),
                    _buildToolButton(
                      icon: Icons.note_add,
                      label: 'Note',
                      tool: StudentAnnotationType.textNote,
                      vm: vm,
                    ),
                    _buildToolButton(
                      icon: Icons.crop_square,
                      label: 'Rectangle',
                      tool: StudentAnnotationType.rectangle,
                      vm: vm,
                    ),
                    _buildToolButton(
                      icon: Icons.circle_outlined,
                      label: 'Circle',
                      tool: StudentAnnotationType.circle,
                      vm: vm,
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(width: 16),
            
            // Color picker
            Container(
              height: 40,
              child: Row(
                children: _buildColorPalette(vm),
              ),
            ),
            
            const SizedBox(width: 16),
            
            // Action buttons
            Row(
              children: [
                IconButton(
                  onPressed: () => vm.undoLastAnnotation(),
                  icon: const Icon(Icons.undo),
                  tooltip: 'Undo',
                ),
                IconButton(
                  onPressed: () => vm.clearCurrentPageAnnotations(),
                  icon: const Icon(Icons.clear_all),
                  tooltip: 'Clear Page',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildToolButton({
    required IconData icon,
    required String label,
    required StudentAnnotationType tool,
    required SimpleStudentPdfVm vm,
  }) {
    final isSelected = vm.currentTool == tool;
    
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: InkWell(
        onTap: () => vm.setTool(tool),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? Colors.blue.withOpacity(0.1) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: isSelected ? Border.all(color: Colors.blue, width: 2) : null,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: isSelected ? Colors.blue : Colors.grey[600],
                size: 20,
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  color: isSelected ? Colors.blue : Colors.grey[600],
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  List<Widget> _buildColorPalette(SimpleStudentPdfVm vm) {
    final colors = vm.currentTool == StudentAnnotationType.highlight 
        ? vm.highlightColors 
        : vm.drawingColors;
    
    return colors.map((color) {
      final isSelected = vm.currentColor == color;
      
      return Padding(
        padding: const EdgeInsets.only(right: 6),
        child: InkWell(
          onTap: () => vm.setColor(color),
          borderRadius: BorderRadius.circular(20),
          child: Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: isSelected 
                  ? Border.all(color: Colors.black, width: 2)
                  : Border.all(color: Colors.grey[300]!, width: 1),
            ),
            child: isSelected
                ? const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 16,
                  )
                : null,
          ),
        ),
      );
    }).toList();
  }
  
  Widget _buildTextNoteDialog(SimpleStudentPdfVm vm) {
    final controller = TextEditingController();
    
    return Positioned.fill(
      child: Container(
        color: Colors.black26,
        child: Center(
          child: Container(
            width: 320,
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Icon(Icons.note_add, color: Colors.orange[600]),
                    const SizedBox(width: 8),
                    const Text(
                      'Add Study Note',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                TextField(
                  controller: controller,
                  maxLines: 4,
                  autofocus: true,
                  decoration: const InputDecoration(
                    hintText: 'Type your study note here...',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Color(0xFFFFF8E1),
                  ),
                  style: const TextStyle(fontSize: 14),
                ),
                
                const SizedBox(height: 16),
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => vm.cancelTextNote(),
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        final text = controller.text.trim();
                        if (text.isNotEmpty) {
                          vm.createTextNote(text);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange[600],
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Add Note'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  // Gesture handlers
  void _handleTap(Offset position, SimpleStudentPdfVm vm) {
    if (vm.currentTool == StudentAnnotationType.textNote) {
      vm.startTextNote(position);
    }
  }
  
  void _handlePanStart(Offset position, SimpleStudentPdfVm vm) {
    if (vm.currentTool != StudentAnnotationType.textNote) {
      vm.startStroke(position);
    }
  }
  
  void _handlePanUpdate(Offset position, SimpleStudentPdfVm vm) {
    if (vm.currentTool != StudentAnnotationType.textNote) {
      vm.addStrokePoint(position);
    }
  }
  
  void _handlePanEnd(SimpleStudentPdfVm vm) {
    if (vm.currentTool != StudentAnnotationType.textNote) {
      vm.finishStroke();
    }
  }
}

/// Custom painter for annotations
class AnnotationPainter extends CustomPainter {
  final List<StudentStroke> strokes;
  final List<StudentTextNote> textNotes;
  final List<Offset> currentStroke;
  final Color currentColor;
  final double currentWidth;
  
  AnnotationPainter({
    required this.strokes,
    required this.textNotes,
    required this.currentStroke,
    required this.currentColor,
    required this.currentWidth,
  });
  
  @override
  void paint(Canvas canvas, Size size) {
    // Draw saved strokes
    for (final stroke in strokes) {
      _drawStroke(canvas, stroke);
    }
    
    // Draw current stroke
    if (currentStroke.length > 1) {
      final stroke = StudentStroke(
        points: currentStroke,
        color: currentColor,
        width: currentWidth,
        type: StudentAnnotationType.drawing,
      );
      _drawStroke(canvas, stroke);
    }
    
    // Draw text notes
    for (final note in textNotes) {
      _drawTextNote(canvas, note);
    }
  }
  
  void _drawStroke(Canvas canvas, StudentStroke stroke) {
    if (stroke.points.length < 2) return;
    
    final paint = Paint()
      ..color = stroke.color
      ..strokeWidth = stroke.width
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    
    final path = Path();
    path.moveTo(stroke.points.first.dx, stroke.points.first.dy);
    
    for (int i = 1; i < stroke.points.length; i++) {
      path.lineTo(stroke.points[i].dx, stroke.points[i].dy);
    }
    
    canvas.drawPath(path, paint);
  }
  
  void _drawTextNote(Canvas canvas, StudentTextNote note) {
    // Draw note indicator
    final paint = Paint()
      ..color = note.color
      ..style = PaintingStyle.fill;
    
    canvas.drawCircle(note.position, 12, paint);
    
    // Draw "N" for Note
    final textPainter = TextPainter(
      text: const TextSpan(
        text: 'N',
        style: TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    
    textPainter.layout();
    textPainter.paint(
      canvas,
      note.position - Offset(textPainter.width / 2, textPainter.height / 2),
    );
  }
  
  @override
  bool shouldRepaint(AnnotationPainter oldDelegate) {
    return oldDelegate.strokes != strokes ||
        oldDelegate.textNotes != textNotes ||
        oldDelegate.currentStroke != currentStroke ||
        oldDelegate.currentColor != currentColor ||
        oldDelegate.currentWidth != currentWidth;
  }
}
