import 'package:flutter/material.dart';
import 'package:navinotes/models/note_page.dart';
import 'package:navinotes/screens/main/note_template/creation/vm.dart';
import 'package:navinotes/screens/main/note_template/creation/widget/note_page_content.dart';

class PageThumbnail extends StatelessWidget {
  final NotePage page;
  final NoteCreationVm vm;
  final double scale;
  final bool showBorder;
  final Color? borderColor;
  final double borderWidth;
  final BorderRadius? borderRadius;
  final List<BoxShadow>? boxShadow;
  final Widget? overlay;

  const PageThumbnail({
    Key? key,
    required this.page,
    required this.vm,
    this.scale = 0.15,
    this.showBorder = true,
    this.borderColor,
    this.borderWidth = 0.5,
    this.borderRadius,
    this.boxShadow,
    this.overlay,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Calculate thumbnail dimensions
    final pageDimensions = page.format.actualDimensions;
    final thumbnailWidth = pageDimensions.width * scale;
    final thumbnailHeight = pageDimensions.height * scale;

    return Container(
      width: thumbnailWidth,
      height: thumbnailHeight,
      decoration: BoxDecoration(
        color: Colors.white,
        border: showBorder
            ? Border.all(
                color: borderColor ?? Colors.grey.shade300,
                width: borderWidth,
              )
            : null,
        borderRadius: borderRadius ?? BorderRadius.circular(4),
        boxShadow: boxShadow,
      ),
      child: Stack(
        children: [
          // Page content thumbnail
          ClipRRect(
            borderRadius: borderRadius ?? BorderRadius.circular(4),
            child: Transform.scale(
              scale: scale,
              child: Container(
                width: pageDimensions.width,
                height: pageDimensions.height,
                child: IgnorePointer(
                  child: NotePageContent(
                    page: page,
                    vm: vm,
                    backgroundColor: Colors.white,
                    inputWidth: pageDimensions.width,
                    inputHeight: pageDimensions.height,
                  ),
                ),
              ),
            ),
          ),
          
          // Optional overlay
          if (overlay != null) overlay!,
        ],
      ),
    );
  }
}

/// A more advanced thumbnail widget that can render static previews
/// without requiring the full NotePageContent widget
class StaticPageThumbnail extends StatelessWidget {
  final NotePage page;
  final double scale;
  final bool showBorder;
  final Color? borderColor;
  final double borderWidth;
  final BorderRadius? borderRadius;
  final List<BoxShadow>? boxShadow;
  final Widget? overlay;

  const StaticPageThumbnail({
    Key? key,
    required this.page,
    this.scale = 0.15,
    this.showBorder = true,
    this.borderColor,
    this.borderWidth = 0.5,
    this.borderRadius,
    this.boxShadow,
    this.overlay,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pageDimensions = page.format.actualDimensions;
    final thumbnailWidth = pageDimensions.width * scale;
    final thumbnailHeight = pageDimensions.height * scale;

    return Container(
      width: thumbnailWidth,
      height: thumbnailHeight,
      decoration: BoxDecoration(
        color: Colors.white,
        border: showBorder
            ? Border.all(
                color: borderColor ?? Colors.grey.shade300,
                width: borderWidth,
              )
            : null,
        borderRadius: borderRadius ?? BorderRadius.circular(4),
        boxShadow: boxShadow,
      ),
      child: Stack(
        children: [
          // Static content preview
          ClipRRect(
            borderRadius: borderRadius ?? BorderRadius.circular(4),
            child: _buildStaticPreview(),
          ),
          
          // Optional overlay
          if (overlay != null) overlay!,
        ],
      ),
    );
  }

  Widget _buildStaticPreview() {
    return Stack(
      children: [
        // Template background
        _buildTemplateBackground(),
        
        // Text content preview
        if (page.textContent != null && page.textContent!.isNotEmpty)
          _buildTextPreview(),
        
        // Drawing content preview
        if (page.drawingData != null && page.drawingData!.isNotEmpty)
          _buildDrawingPreview(),
      ],
    );
  }

  Widget _buildTemplateBackground() {
    // Add template-specific backgrounds based on page.template
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.white,
      // You can add template patterns here based on page.template
    );
  }

  Widget _buildTextPreview() {
    try {
      // Parse Quill JSON and show text preview
      // This is a simplified version - you might want to use a proper Quill renderer
      return Positioned(
        top: 8 * scale,
        left: 8 * scale,
        right: 8 * scale,
        child: Text(
          'Text content...', // You can parse the actual text content here
          style: TextStyle(
            fontSize: 10 * scale,
            color: Colors.black87,
          ),
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
      );
    } catch (e) {
      return const SizedBox.shrink();
    }
  }

  Widget _buildDrawingPreview() {
    try {
      // This would render drawing content using CustomPainter
      // Similar to what you had in the memory
      return CustomPaint(
        size: Size.infinite,
        painter: _ThumbnailDrawingPainter(page.drawingData!, scale),
      );
    } catch (e) {
      return const SizedBox.shrink();
    }
  }
}

/// Custom painter for drawing thumbnails
class _ThumbnailDrawingPainter extends CustomPainter {
  final String drawingData;
  final double scale;

  _ThumbnailDrawingPainter(this.drawingData, this.scale);

  @override
  void paint(Canvas canvas, Size size) {
    // Parse and render drawing data
    // This would be similar to your previous implementation
    // You can implement the actual drawing rendering here
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
