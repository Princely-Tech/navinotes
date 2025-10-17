import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:navinotes/models/content.dart';
import 'package:navinotes/models/others.dart';
import 'package:navinotes/screens/main/note_template/read/index.dart';
import 'package:navinotes/settings/enums.dart';
import 'package:navinotes/settings/packages.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;

/// Reusable widget for previewing different content types
/// Used in mind map nodes and right panel previews
class ContentPreviewWidget extends StatelessWidget {
  final Content content;
  final bool isCompact; // For small previews in mind map nodes
  final double? width;
  final double? height;

  const ContentPreviewWidget({
    super.key,
    required this.content,
    this.isCompact = false,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final containerWidth = width ?? (isCompact ? 180.0 : 300.0);
    final containerHeight = height ?? (isCompact ? 80.0 : 200.0);

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
        boxShadow:
            isCompact
                ? null
                : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
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
    return NoteReadScreen(content: content);
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
            size: isCompact ? 32 : 48,
            color: _getFileColor(fileExtension),
          ),
          const SizedBox(height: 8),
          // File name
          Text(
            fileName,
            style: TextStyle(
              fontSize: isCompact ? 10 : 14,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
            maxLines: isCompact ? 2 : 3,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
          if (!isCompact) ...[
            const SizedBox(height: 4),
            Text(
              fileExtension.toUpperCase(),
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
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
          Icon(
            Icons.quiz,
            size: isCompact ? 24 : 32,
            color: Colors.orange.shade600,
          ),
          const SizedBox(height: 8),
          // Title
          Text(
            content.title.isNotEmpty ? content.title : 'Flashcard Deck',
            style: TextStyle(
              fontSize: isCompact ? 12 : 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            maxLines: isCompact ? 2 : 3,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
          const Spacer(),
          // Card count (if available in metadata)
          if (content.metaData.containsKey('cardCount'))
            Text(
              '${content.metaData['cardCount']} cards',
              style: TextStyle(
                fontSize: isCompact ? 10 : 12,
                color: Colors.grey.shade600,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildNotebookPreview() {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          // Notebook icon
          Icon(
            Icons.book,
            size: isCompact ? 24 : 32,
            color: Colors.teal.shade600,
          ),
          const SizedBox(height: 8),
          // Title
          Text(
            content.title.isNotEmpty ? content.title : 'Notebook',
            style: TextStyle(
              fontSize: isCompact ? 12 : 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            maxLines: isCompact ? 2 : 3,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
          const Spacer(),
          // Page count (if available in metadata)
          if (content.metaData.containsKey('pageCount'))
            Text(
              '${content.metaData['pageCount']} pages',
              style: TextStyle(
                fontSize: isCompact ? 10 : 12,
                color: Colors.grey.shade600,
              ),
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
          Icon(
            Icons.account_tree,
            size: isCompact ? 20 : 28,
            color: Colors.indigo.shade700,
          ),
          const SizedBox(height: 8),
          Text(
            content.title.isNotEmpty ? content.title : 'Mind Map Node',
            style: TextStyle(
              fontSize: isCompact ? 12 : 16,
              fontWeight: FontWeight.bold,
              color: Colors.indigo.shade800,
            ),
            maxLines: isCompact ? 2 : 3,
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
