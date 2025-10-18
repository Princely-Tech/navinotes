import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:navinotes/models/content.dart';
import 'package:navinotes/models/note_page.dart';
import 'package:navinotes/screens/main/note_template/read/vm.dart';
import 'package:navinotes/screens/main/note_template/read/widget/note_page_content.dart';
import 'package:navinotes/settings/enums.dart';
import 'package:navinotes/settings/packages.dart';

/// Reusable widget for previewing different content types
/// Used in mind map nodes and right panel previews
class ContentCompactPreviewWidget extends StatelessWidget {
  final Content content;
  final double? width;
  final double? height;

  const ContentCompactPreviewWidget({
    super.key,
    required this.content,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final containerWidth = width ?? 180.0;
    final containerHeight = height ?? 80.0;

    return Container(
      width: containerWidth == double.infinity ? null : containerWidth,
      height: containerHeight == double.infinity ? null : containerHeight,
      constraints: BoxConstraints(
        maxWidth:
            containerWidth == double.infinity
                ? double.infinity
                : containerWidth,
        maxHeight:
            containerHeight == double.infinity
                ? double.infinity
                : containerHeight,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: _buildContentPreview(),
      ),
    );
  }

  Widget _buildContentPreview() {
    switch (content.type) {
      case AppContentType.note:
        return _buildNotePreview();
      case AppContentType.file:
        return _buildFilePreview();
      case AppContentType.flashcardDeck:
        return _buildFlashcardPreview();
      case AppContentType.mindmapNode:
        return _buildMindMapNodePreview();
    }
  }

  Widget _buildNotePreview() {
    // Try to parse the first page from content metadata
    NotePage? firstPage = _getFirstPage();
    
    if (firstPage == null) {
      // Fallback to title if no pages found
      return Container(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.note, size: 24, color: Colors.blue.shade600),
            const SizedBox(height: 4),
            Text(
              content.title.isNotEmpty ? content.title : 'Note',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    // Create thumbnail of the first page that fills the entire space
    return _buildPageThumbnail(firstPage);
  }

  NotePage? _getFirstPage() {
    try {
      // Try to get pages from content metadata
      if (content.metaData.containsKey('pages')) {
        final pagesData = content.metaData['pages'];
        if (pagesData is List && pagesData.isNotEmpty) {
          final firstPageData = pagesData[0];
          if (firstPageData is Map<String, dynamic>) {
            return NotePage.fromMap(firstPageData);
          }
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Widget _buildPageThumbnail(NotePage page) {
    // Get the actual page dimensions to calculate the proper scale
    final pageDimensions = page.format.actualDimensions;

    return LayoutBuilder(
      builder: (context, constraints) {
        // Create VM with proper context
        final vm = _createDummyVm(context);
        if (vm == null) {
          // Fallback to simple page representation
          return Container(
            color: Colors.white,
            child: Center(
              child: Text(
                'Page ${page.id}',
                style: TextStyle(fontSize: 10, color: Colors.grey),
              ),
            ),
          );
        }

        // Calculate scale to fill the available space while maintaining aspect ratio
        final availableWidth = constraints.maxWidth;
        final availableHeight = constraints.maxHeight;

        final scaleX = availableWidth / pageDimensions.width;
        final scaleY = availableHeight / pageDimensions.height;

        // Use the larger scale to ensure the page covers/fills the entire space (like page navigator)
        final scale = math.max(scaleX, scaleY);

        return ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: SizedBox(
            width: availableWidth,
            height: availableHeight,
            child: OverflowBox(
              alignment: Alignment.center,
              child: Transform.scale(
                scale: scale,
                child: Container(
                  width: pageDimensions.width,
                  height: pageDimensions.height,
                  child: IgnorePointer(
                    child: NotePageContent(
                      key: ValueKey('compact_thumbnail_${page.id}'),
                      page: page,
                      vm: vm,
                      backgroundColor: Colors.white,
                      inputWidth: pageDimensions.width,
                      inputHeight: pageDimensions.height,
                      isThumbnail: true,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // Create a minimal NoteReadVm for the thumbnail
  NoteReadVm? _createDummyVm(BuildContext context) {
    try {
      return NoteReadVm(
        content: content,
        context: context,
      );
    } catch (e) {
      return null;
    }
  }

  Widget _buildFilePreview() {
    final fileName = content.file ?? content.title;
    final fileExtension = fileName.split('.').last.toLowerCase();

    return Container(
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // File icon based on extension
          Icon(
            _getFileIcon(fileExtension),
            size: 32,
            color: _getFileColor(fileExtension),
          ),
          const SizedBox(height: 8),
          // File name
          Text(
            fileName,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFlashcardPreview() {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          // Flashcard icon
          Icon(Icons.quiz, size: 32, color: Colors.orange.shade600),
          const SizedBox(height: 8),
          // Title
          Text(
            content.title.isNotEmpty ? content.title : 'Flashcard Deck',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
          const Spacer(),
          // Card count (if available in metadata)
          if (content.metaData.containsKey('cardCount'))
            Text(
              '${content.metaData['cardCount']} cards',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
        ],
      ),
    );
  }

  Widget _buildMindMapNodePreview() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.indigo.shade100, Colors.indigo.shade50],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.account_tree, size: 20, color: Colors.indigo.shade700),
          const SizedBox(height: 8),
          Text(
            content.title.isNotEmpty ? content.title : 'Mind Map Node',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.indigo.shade800,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  IconData _getFileIcon(String extension) {
    switch (extension) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'doc':
      case 'docx':
        return Icons.description;
      case 'xls':
      case 'xlsx':
        return Icons.table_chart;
      case 'ppt':
      case 'pptx':
        return Icons.slideshow;
      case 'jpg':
      case 'jpeg':
      case 'png':
      case 'gif':
        return Icons.image;
      case 'txt':
        return Icons.text_snippet;
      default:
        return Icons.insert_drive_file;
    }
  }

  Color _getFileColor(String extension) {
    switch (extension) {
      case 'pdf':
        return Colors.red.shade600;
      case 'doc':
      case 'docx':
        return Colors.blue.shade600;
      case 'xls':
      case 'xlsx':
        return Colors.green.shade600;
      case 'ppt':
      case 'pptx':
        return Colors.orange.shade600;
      case 'jpg':
      case 'jpeg':
      case 'png':
      case 'gif':
        return Colors.purple.shade600;
      case 'txt':
        return Colors.grey.shade600;
      default:
        return Colors.grey.shade600;
    }
  }
}
