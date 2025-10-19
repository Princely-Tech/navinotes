import 'package:flutter/material.dart';
import 'package:navinotes/models/note_page.dart';
import 'package:navinotes/packages.dart';
import 'package:navinotes/screens/main/note_template/read/vm.dart';
import 'package:navinotes/screens/main/note_template/read/widget/text_editor.dart';
import 'package:navinotes/screens/main/note_template/read/widget/drawing.dart';
import 'package:flutter_drawing_board/flutter_drawing_board.dart';
import 'package:flutter_drawing_board/paint_contents.dart';
import 'package:navinotes/screens/main/note_template/read/widget/lined_rule.dart';
import 'package:navinotes/screens/main/note_template/read/widget/squared_rule.dart';
import 'package:navinotes/screens/main/note_template/read/widget/dotted.dart';
import '../../creation/models/text_box.dart';

class NotePageContent extends StatefulWidget {
  final NotePage page;
  final NoteReadVm vm;
  final Color backgroundColor;
  final double inputWidth;
  final double inputHeight;
  final bool isThumbnail;

  const NotePageContent({
    Key? key,
    required this.page,
    required this.vm,
    required this.backgroundColor,
    required this.inputWidth,
    required this.inputHeight,
    this.isThumbnail = false,
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
    // Use the vm passed as parameter instead of Consumer to avoid provider scope issues
    final vm = widget.vm;
    return Listener(
      onPointerDown: (_) => _safeSetState(() => fingerCount++),
      onPointerUp:
          (_) =>
              _safeSetState(() => fingerCount = (fingerCount - 1).clamp(0, 10)),
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

              // Page content based on mode (expandable to show all content)
              Container(
                width: widget.inputWidth,
                height: widget.inputHeight,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: getPageContent(vm),
                ),
              ),
            ],
          ),

          // Page number indicator (only for multi-page view)
          if (widget.vm.notePages.length > 1) _buildPageNumber(),
        ],
      ),
    );
  }

  bool _isCurrentPage(NoteReadVm vm) {
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

  List<Widget> getPageContent(NoteReadVm vm) {
    // For thumbnails, always show static content to avoid GlobalKey conflicts
    if (widget.isThumbnail) {
      final validWidth =
          widget.inputWidth.isFinite && widget.inputWidth > 10
              ? widget.inputWidth
              : 595.0;
      final validHeight =
          widget.inputHeight.isFinite && widget.inputHeight > 10
              ? widget.inputHeight
              : 842.0;
      return [
        _buildStaticTextContent(),
        _buildStaticDrawingContent(),
        _buildStaticTextBoxContent(validWidth, validHeight),
      ];
    }

    // Only show interactive content for the current page
    final isCurrentPage = _isCurrentPage(vm);

    if (!isCurrentPage) {
      // For non-current pages, show static content
      final validWidth =
          widget.inputWidth.isFinite && widget.inputWidth > 10
              ? widget.inputWidth
              : 595.0;
      final validHeight =
          widget.inputHeight.isFinite && widget.inputHeight > 10
              ? widget.inputHeight
              : 842.0;
      return [
        _buildStaticTextContent(),
        _buildStaticDrawingContent(),
        _buildStaticTextBoxContent(validWidth, validHeight),
      ];
    }

    // For current page, show interactive content based on mode
    switch (vm.currentMode) {
      case NoteMode.text:
        // Validate dimensions to prevent "Invalid image dimensions" error
        final validWidth =
            widget.inputWidth.isFinite && widget.inputWidth > 10
                ? widget.inputWidth
                : 595.0;
        final validHeight =
            widget.inputHeight.isFinite && widget.inputHeight > 10
                ? widget.inputHeight
                : 842.0;

        return [
          // Drawing layer (non-interactive in text mode) - bottom layer
          IgnorePointer(
            ignoring: true,
            child: SizedBox(
              width: validWidth,
              height: validHeight,
              child: buildDrawingBoard(vm, validWidth, validHeight),
            ),
          ),
          // Text box overlay (read-only in text mode) - middle layer
          Positioned.fill(
            child: _buildTextBoxOverlay(
              vm,
              validWidth,
              validHeight,
              readOnly: true,
            ),
          ),
          // Text editor (interactive) - TOP layer for easy tapping
          Positioned.fill(
            child: Container(
              width: validWidth,
              height: validHeight,
              child: buildTextEditor(vm, validWidth, validHeight),
            ),
          ),
        ];
      case NoteMode.drawing:
        // Validate dimensions to prevent "Invalid image dimensions" error
        final validWidth =
            widget.inputWidth.isFinite && widget.inputWidth > 10
                ? widget.inputWidth
                : 595.0;
        final validHeight =
            widget.inputHeight.isFinite && widget.inputHeight > 10
                ? widget.inputHeight
                : 842.0;

        return [
          // Text editor (non-interactive in drawing mode)
          Positioned.fill(
            child: Container(
              width: validWidth,
              height: validHeight,
              child: buildTextEditor(vm, validWidth, validHeight),
            ),
          ),
          // Drawing layer (interactive) - expandable for drawing
          Positioned.fill(
            child: Container(
              width: validWidth,
              height: validHeight,
              child: buildDrawingBoard(vm, validWidth, validHeight),
            ),
          ),
          // Text box overlay (interactive)
          Positioned.fill(
            child: _buildTextBoxOverlay(
              vm,
              validWidth,
              validHeight,
              readOnly: false,
            ),
          ),
        ];
      case NoteMode.read:
        // In read mode, show static content only
        final validWidth =
            widget.inputWidth.isFinite && widget.inputWidth > 10
                ? widget.inputWidth
                : 595.0;
        final validHeight =
            widget.inputHeight.isFinite && widget.inputHeight > 10
                ? widget.inputHeight
                : 842.0;

        return [
          _buildStaticTextContent(),
          // Text box overlay (read-only in read mode)
          Positioned.fill(
            child: _buildTextBoxOverlay(
              vm,
              validWidth,
              validHeight,
              readOnly: true,
            ),
          ),
          _buildStaticDrawingContent(),
        ];
      case NoteMode.voice:
        // Voice mode is now handled independently in MultiPageViewer
        return [];
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
        widget.inputWidth.isFinite && widget.inputWidth > 10
            ? widget.inputWidth
            : 595.0;
    final validHeight =
        widget.inputHeight.isFinite && widget.inputHeight > 10
            ? widget.inputHeight
            : 842.0;

    debugPrint(
      'NotePageContent dimensions: width=$validWidth, height=$validHeight, isThumbnail=${widget.isThumbnail}',
    );

    // For thumbnails with very small dimensions, skip DrawingBoard to avoid errors
    if (widget.isThumbnail && (validWidth < 50 || validHeight < 50)) {
      return const SizedBox.shrink();
    }

    // Additional safety check for invalid dimensions
    if (validWidth < 10 ||
        validHeight < 10 ||
        !validWidth.isFinite ||
        !validHeight.isFinite) {
      debugPrint(
        'Skipping DrawingBoard due to invalid dimensions: $validWidth x $validHeight',
      );
      return const SizedBox.shrink();
    }

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
            child: RepaintBoundary(
              child: Builder(
                builder: (context) {
                  try {
                    return DrawingBoard(
                      controller: drawingController,
                      background: Container(
                        width: validWidth,
                        height: validHeight,
                        color: Colors.transparent,
                      ),
                      showDefaultActions: false,
                      showDefaultTools: false,
                    );
                  } catch (e) {
                    debugPrint('Error creating static DrawingBoard: $e');
                    return Container(
                      width: validWidth,
                      height: validHeight,
                      color: Colors.grey.withOpacity(0.1),
                      child: const Center(
                        child: Icon(Icons.draw, color: Colors.grey, size: 24),
                      ),
                    );
                  }
                },
              ),
            ),
          ),
        ),
      );
    } catch (e) {
      debugPrint('Error loading page drawing content: $e');
      return const SizedBox.shrink();
    }
  }

  Widget _buildTemplateBackground() {
    // Use the current page from ViewModel to get the latest template
    // Since we already have vm passed as parameter, use it directly
    final vm = widget.vm;
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
  }

  Widget _buildTextBoxOverlay(
    NoteReadVm vm,
    double width,
    double height, {
    bool readOnly = true,
  }) {
    return _buildStaticTextBoxContent(width, height);
  }

  Widget _buildStaticTextBoxContent(double width, double height) {
    if (widget.page.textBoxData == null || widget.page.textBoxData!.isEmpty) {
      return const SizedBox.shrink();
    }

    try {
      final List<dynamic> textBoxList = jsonDecode(widget.page.textBoxData!);

      return Stack(
        children:
            textBoxList.map<Widget>((json) {
              try {
                final textBox = TextBox.fromJson(json as Map<String, dynamic>);

                return Positioned(
                  left: textBox.position.dx,
                  top: textBox.position.dy,
                  child: Container(
                    width: textBox.size.width,
                    height: textBox.size.height,
                    padding: textBox.padding,
                    decoration: BoxDecoration(
                      color:
                          textBox.backgroundColor.opacity > 0
                              ? textBox.backgroundColor
                              : Colors.white.withOpacity(0.9),
                      border:
                          textBox.hasBorder
                              ? Border.all(
                                color: textBox.borderColor,
                                width: textBox.borderWidth,
                              )
                              : Border.all(
                                color: Colors.grey.withOpacity(0.3),
                                width: 1.0,
                              ),
                      borderRadius: textBox.borderRadius,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      textBox.text.isEmpty ? 'Text' : textBox.text,
                      style:
                          textBox.text.isEmpty
                              ? textBox.textStyle.copyWith(color: Colors.grey)
                              : textBox.textStyle,
                      textAlign: textBox.textAlign,
                      maxLines: null,
                      overflow: TextOverflow.visible,
                    ),
                  ),
                );
              } catch (e) {
                debugPrint('Error rendering static text box: $e');
                return const SizedBox.shrink();
              }
            }).toList(),
      );
    } catch (e) {
      debugPrint('Error loading static text box content: $e');
      return const SizedBox.shrink();
    }
  }
}
