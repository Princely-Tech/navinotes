import 'package:flutter/material.dart';
import 'package:navinotes/models/content.dart';
import 'package:navinotes/screens/main/note_template/read/index.dart';
import 'package:navinotes/screens/main/flashcards/study/vm.dart';
import 'package:navinotes/widgets/flashcard_study_widget.dart';
import 'package:navinotes/settings/enums.dart';
import 'package:navinotes/settings/packages.dart';
import 'package:provider/provider.dart';

/// Reusable widget for previewing different content types
/// Used in mind map nodes and right panel previews
class ContentFullPreviewWidget extends StatelessWidget {
  final Content content;
  final double? width;
  final double? height;

  const ContentFullPreviewWidget({
    super.key,
    required this.content,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final containerWidth = width ?? 300.0;
    final containerHeight = height ?? 200;

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
        boxShadow: [
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
            size: 48,
            color: _getFileColor(fileExtension),
          ),
          const SizedBox(height: 8),
          // File name
          Text(
            fileName,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),

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
      ),
    );
  }

  Widget _buildFlashcardPreview() {
    return ChangeNotifierProvider(
      create: (context) {
        final vm = FlashCardStudyVm(
          scaffoldKey: GlobalKey<ScaffoldState>(),
          context: context,
          deck: content,
        );
        vm.initialize();
        return vm;
      },
      child: Consumer<FlashCardStudyVm>(
        builder: (context, vm, child) {
          return FlashcardStudyWidget(
            vm: vm,
            showProgressIndicator: true, // Hide progress in preview
            showActions: true, // Hide actions in preview
            maxWidth: width,
          );
        },
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
          Icon(Icons.account_tree, size: 28, color: Colors.indigo.shade700),
          const SizedBox(height: 8),
          Text(
            content.title.isNotEmpty ? content.title : 'Mind Map Node',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.indigo.shade800,
            ),
            maxLines: 3,
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
