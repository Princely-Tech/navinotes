import 'package:flutter/material.dart';
import 'package:navinotes/models/note_page.dart';
import 'package:navinotes/packages.dart';
import 'package:navinotes/screens/main/note_template/creation/vm.dart';
import 'package:navinotes/screens/main/note_template/creation/widget/text_editor.dart';
import 'package:navinotes/screens/main/note_template/creation/widget/drawing.dart';
import 'package:flutter_drawing_board/flutter_drawing_board.dart';
import 'package:flutter_drawing_board/paint_contents.dart';
import 'package:navinotes/screens/main/note_template/creation/widget/lined_rule.dart';
import 'package:navinotes/screens/main/note_template/creation/widget/squared_rule.dart';
import 'package:navinotes/screens/main/note_template/creation/widget/dotted.dart';
import 'package:navinotes/screens/main/note_template/creation/widget/voice.dart';

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
          onPointerUp:
              (_) => _safeSetState(
                () => fingerCount = (fingerCount - 1).clamp(0, 10),
              ),
          child: Stack(
            children: [
              // Fixed page content (no scrolling - like real paper)
              Stack(
                children: [
                  // Background pattern based on page template
                  Container(
                    width: widget.inputWidth,
                    height: widget.inputHeight,
                    color: widget.backgroundColor,
                    child: _buildTemplateBackground(),
                  ),

                  // Page content based on mode (clipped to page boundaries)
                  ClipRect(
                    child: SizedBox(
                      width: widget.inputWidth,
                      height: widget.inputHeight,
                      child: Stack(children: getPageContent(vm)),
                    ),
                  ),
                ],
              ),

              // Page number indicator
              _buildPageNumber(),

              // Toolbars are now centralized above the pages
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
      return [_buildStaticTextContent(), _buildStaticDrawingContent()];
    }

    // For current page, show interactive content based on mode
    switch (vm.currentMode) {
      case NoteMode.text:
        // Validate dimensions to prevent "Invalid image dimensions" error
        final validWidth =
            widget.inputWidth.isFinite && widget.inputWidth > 0
                ? widget.inputWidth
                : 595.0;
        final validHeight =
            widget.inputHeight.isFinite && widget.inputHeight > 0
                ? widget.inputHeight
                : 842.0;

        return [
          // Drawing layer (non-interactive in text mode)
          IgnorePointer(
            ignoring: true,
            child: SizedBox(
              width: validWidth,
              height: validHeight,
              child: buildDrawingBoard(vm, validWidth, validHeight),
            ),
          ),
          // Text editor (interactive) - full page coverage
          Positioned.fill(
            child: SizedBox(
              width: validWidth,
              height: validHeight,
              child: buildTextEditor(vm, validWidth, validHeight),
            ),
          ),
        ];
      case NoteMode.drawing:
        // Validate dimensions to prevent "Invalid image dimensions" error
        final validWidth =
            widget.inputWidth.isFinite && widget.inputWidth > 0
                ? widget.inputWidth
                : 595.0;
        final validHeight =
            widget.inputHeight.isFinite && widget.inputHeight > 0
                ? widget.inputHeight
                : 842.0;

        return [
          // Text editor (non-interactive in drawing mode)
          Positioned.fill(
            child: SizedBox(
              width: validWidth,
              height: validHeight,
              child: buildTextEditor(vm, validWidth, validHeight),
            ),
          ),
          // Drawing layer (interactive)
          Positioned.fill(
            child: IgnorePointer(
              ignoring: false,
              child: SizedBox(
                width: validWidth,
                height: validHeight,
                child: buildDrawingBoard(vm, validWidth, validHeight),
              ),
            ),
          ),
        ];
      case NoteMode.read:
        // In read mode, show static content only
        return [_buildStaticTextContent(), _buildStaticDrawingContent()];
      case NoteMode.voice:
        // In voice mode, show voice recorder as full page
        return [_buildVoiceRecorderPage(vm)];
    }
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
        child: Container(
          width: widget.inputWidth,
          height: widget.inputHeight,
          padding: const EdgeInsets.all(16),
          child: QuillEditor.basic(controller: controller),
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

    // Validate dimensions to prevent "Invalid image dimensions" error
    final validWidth =
        widget.inputWidth.isFinite && widget.inputWidth > 0
            ? widget.inputWidth
            : 595.0;
    final validHeight =
        widget.inputHeight.isFinite && widget.inputHeight > 0
            ? widget.inputHeight
            : 842.0;

    try {
      // Create a read-only DrawingController for this page
      final drawingController = DrawingController();
      final List<dynamic> drawingList = jsonDecode(widget.page.drawingData!);

      for (var item in drawingList) {
        if (item is Map<String, dynamic>) {
          final type = item['type'] as String?;
          PaintContent? paintContent;

          switch (type) {
            case 'SimpleLine':
              paintContent = SimpleLine.fromJson(item);
              break;
            case 'SmoothLine':
              paintContent = SmoothLine.fromJson(item);
              break;
            case 'StraightLine':
              paintContent = StraightLine.fromJson(item);
              break;
            case 'Rectangle':
              paintContent = Rectangle.fromJson(item);
              break;
            case 'Circle':
              paintContent = Circle.fromJson(item);
              break;
            case 'Eraser':
              paintContent = Eraser.fromJson(item);
              break;
          }

          if (paintContent != null) {
            drawingController.addContent(paintContent);
          }
        }
      }

      return Positioned.fill(
        child: SizedBox(
          width: validWidth,
          height: validHeight,
          child: IgnorePointer(
            ignoring: true, // Make it non-interactive in read mode
            child: DrawingBoard(
              controller: drawingController,
              background: Container(
                width: validWidth,
                height: validHeight,
                color: Colors.transparent,
              ),
              showDefaultActions: false,
              showDefaultTools: false,
            ),
          ),
        ),
      );
    } catch (e) {
      debugPrint('Error loading page drawing content: $e');
      return const SizedBox.shrink();
    }
  }

  Widget _buildVoiceRecorderPage(NoteCreationVm vm) {
    return Positioned.fill(
      child: Container(
        width: widget.inputWidth,
        height: widget.inputHeight,
        padding: const EdgeInsets.all(24),
        child: buildVoiceRecorder(vm, widget.backgroundColor, context),
      ),
    );
  }

  Widget _buildTemplateBackground() {
    // Use the current page from ViewModel to get the latest template
    return Consumer<NoteCreationVm>(
      builder: (context, vm, child) {
        final currentPage = vm.notePages.firstWhere(
          (page) => page.id == widget.page.id,
          orElse: () => widget.page,
        );

        switch (currentPage.template.type) {
          case NoteTemplateType.lined:
            return ClipRect(
              child: SizedBox(
                width: widget.inputWidth,
                height: widget.inputHeight,
                child: const LinedNoteBackground(),
              ),
            );
          case NoteTemplateType.squared:
            return ClipRect(
              child: SizedBox(
                width: widget.inputWidth,
                height: widget.inputHeight,
                child: const SquaredNoteBackground(),
              ),
            );
          case NoteTemplateType.dotted:
            return ClipRect(
              child: SizedBox(
                width: widget.inputWidth,
                height: widget.inputHeight,
                child: const DottedNoteBackground(),
              ),
            );
          case NoteTemplateType.cornell:
            // Cornell template would need a special background
            return ClipRect(
              child: SizedBox(
                width: widget.inputWidth,
                height: widget.inputHeight,
                child: Container(
                  color: const Color(0xFFD1CDC4), // Cornell background color
                ),
              ),
            );
          case NoteTemplateType.blank:
          default:
            // Blank template - no background pattern
            return const SizedBox.shrink();
        }
      },
    );
  }
}
