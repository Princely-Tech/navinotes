import 'package:flutter/material.dart';
import 'package:navinotes/models/note_page.dart';
import 'package:navinotes/packages.dart';
import 'package:navinotes/screens/main/note_template/creation/vm.dart';
import 'package:navinotes/screens/main/note_template/creation/widget/dotted.dart';
import 'package:navinotes/screens/main/note_template/creation/widget/drawing.dart';
import 'package:navinotes/screens/main/note_template/creation/widget/lined_rule.dart';
import 'package:navinotes/screens/main/note_template/creation/widget/squared_rule.dart';
import 'package:navinotes/screens/main/note_template/creation/widget/text_editor.dart';

class NotePageContent extends StatefulWidget {
  final NotePage page;
  final NoteCreationVm vm;
  final Color backgroundColor;
  final double inputWidth;
  final double inputHeight;

  const NotePageContent({
    Key? key,
    required this.page,
    required this.vm,
    required this.backgroundColor,
    required this.inputWidth,
    required this.inputHeight,
  }) : super(key: key);

  @override
  State<NotePageContent> createState() => _NotePageContentState();
}

class _NotePageContentState extends State<NotePageContent> {
  int fingerCount = 0;

  void _safeSetState(VoidCallback fn) {
    if (mounted) {
      setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NoteCreationVm>(
      builder: (context, vm, child) {
        return Listener(
          onPointerDown: (_) => _safeSetState(() => fingerCount++),
          onPointerUp: (_) => _safeSetState(() => fingerCount = (fingerCount - 1).clamp(0, 10)),
          child: Stack(
            children: [
              // Scrollable background + content
              SingleChildScrollView(
                physics: (vm.currentMode == NoteMode.drawing && fingerCount < 2)
                    ? const NeverScrollableScrollPhysics()
                    : const BouncingScrollPhysics(),
                child: Stack(
                  children: [
                    // Background pattern
                    SizedBox(
                      height: widget.inputHeight,
                      width: widget.inputWidth,
                      child: Stack(
                        children: [
                          Container(
                            width: widget.inputWidth,
                            height: widget.inputHeight,
                            color: widget.backgroundColor,
                          ),
                          const SquaredNoteBackground(),
                          const LinedNoteBackground(),
                          const DottedNoteBackground(),
                        ],
                      ),
                    ),
                    
                    // Page content based on mode
                    ...getPageContent(vm),
                  ],
                ),
              ),
              
              // Page number indicator
              _buildPageNumber(),
              
              // Toolbar (only show for current page)
              if (_isCurrentPage(vm)) ...[
                if (vm.currentMode == NoteMode.text) buildEditorToolBar(vm),
                if (vm.currentMode == NoteMode.drawing) buildDrawingToolbar(vm: vm),
              ],
            ],
          ),
        );
      },
    );
  }

  bool _isCurrentPage(NoteCreationVm vm) {
    return vm.notePages.indexOf(widget.page) == vm.currentPageIndex;
  }

  Widget _buildPageNumber() {
    return Positioned(
      top: 16,
      right: 16,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          'Page ${widget.page.pageNumber}',
          style: TextStyle(
            fontSize: 12,
            color: Colors.black54,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  List<Widget> getPageContent(NoteCreationVm vm) {
    // Only show interactive content for the current page
    final isCurrentPage = _isCurrentPage(vm);
    
    if (!isCurrentPage) {
      // For non-current pages, show static content
      return [
        _buildStaticTextContent(),
        _buildStaticDrawingContent(),
      ];
    }
    
    // For current page, show interactive content based on mode
    return (vm.currentMode == NoteMode.text)
        ? [
            // Drawing layer (non-interactive in text mode)
            IgnorePointer(
              ignoring: true,
              child: buildDrawingBoard(vm, widget.inputWidth, widget.inputHeight),
            ),
            // Text editor (interactive)
            Positioned.fill(
              child: buildTextEditor(vm, widget.inputWidth, widget.inputHeight),
            ),
          ]
        : [
            // Text editor (non-interactive in drawing mode)
            buildTextEditor(vm, widget.inputWidth, widget.inputHeight),
            // Drawing layer (interactive)
            Positioned.fill(
              child: IgnorePointer(
                ignoring: false,
                child: buildDrawingBoard(
                  vm,
                  widget.inputWidth,
                  widget.inputHeight,
                ),
              ),
            ),
          ];
  }

  Widget _buildStaticTextContent() {
    if (widget.page.textContent == null || widget.page.textContent!.isEmpty) {
      return const SizedBox.shrink();
    }
    
    try {
      // Create a read-only QuillController for this page
      final controller = QuillController.basic();
      controller.document = Document.fromJson(
        jsonDecode(widget.page.textContent!),
      );
      controller.readOnly = true;
      
      return Positioned.fill(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: QuillEditor.basic(
            controller: controller,
          ),
        ),
      );
    } catch (e) {
      debugPrint('Error loading page text content: $e');
      return const SizedBox.shrink();
    }
  }

  Widget _buildStaticDrawingContent() {
    if (widget.page.drawingData == null || widget.page.drawingData!.isEmpty) {
      return const SizedBox.shrink();
    }
    
    // For now, just show a placeholder for drawing content
    // TODO: Implement proper drawing display when drawing system is ready
    return Positioned.fill(
      child: Container(
        color: Colors.transparent,
        child: Center(
          child: Text(
            'Drawing Content',
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }
}
