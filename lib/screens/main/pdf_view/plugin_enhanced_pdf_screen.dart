import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_pdf_annotations/flutter_pdf_annotations.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'dart:io';
import 'simple_student_pdf_vm.dart';

/// Enhanced Plugin-based PDF viewer for NaviNotes
/// Uses modified flutter_pdf_annotations plugin with silent saving
class PluginEnhancedPdfScreen extends StatelessWidget {
  const PluginEnhancedPdfScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get contentId from route arguments
    final String contentId =
        ModalRoute.of(context)?.settings.arguments as String;

    return ChangeNotifierProvider(
      create: (_) => SimpleStudentPdfVm(contentId: contentId),
      child: const _PluginEnhancedPdfView(),
    );
  }
}

class _PluginEnhancedPdfView extends StatefulWidget {
  const _PluginEnhancedPdfView();

  @override
  State<_PluginEnhancedPdfView> createState() => _PluginEnhancedPdfViewState();
}

class _PluginEnhancedPdfViewState extends State<_PluginEnhancedPdfView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SimpleStudentPdfVm>().initialize(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) async {
        if (didPop) return;

        // Auto-save before leaving
        final vm = context.read<SimpleStudentPdfVm>();
        try {
          await _savePdfWithAnnotations(vm);
        } catch (e) {
          debugPrint('Error auto-saving on exit: $e');
        }

        if (context.mounted) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        body: Consumer<SimpleStudentPdfVm>(
          builder: (context, vm, child) {
            if (vm.isLoading) {
              return _buildLoadingView(vm);
            }

            if (vm.errorMessage != null) {
              return _buildErrorView(vm);
            }

            return _buildPdfReaderView(vm);
          },
        ),
      ),
    );
  }

  Widget _buildLoadingView(SimpleStudentPdfVm vm) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(color: Colors.blue, strokeWidth: 3),
          const SizedBox(height: 24),
          Text(
            '📚 Opening PDF with annotations...',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            vm.content?.title ?? 'PDF Document',
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
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
            Icon(Icons.error_outline, size: 64, color: Colors.red[400]),
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
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
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

  Widget _buildPdfReaderView(SimpleStudentPdfVm vm) {
    if (vm.documentPath == null) {
      return const Center(child: Text('No document path available'));
    }

    return Column(
      children: [
        // Header with Annotate button
        _buildHeader(context, vm),

        // PDF Viewer with text selection and native highlighting
        Expanded(
          child: SfPdfViewer.file(
            File(vm.documentPath!),
            controller: vm.pdfController,
            canShowScrollHead: true,
            canShowScrollStatus: true,
            canShowPaginationDialog: true,
            enableTextSelection: true,
            onDocumentLoaded: (details) {
              debugPrint('PDF loaded: ${details.document.pages.count} pages');
            },
            onDocumentLoadFailed: (details) {
              debugPrint('PDF load failed: ${details.error}');
            },
            onTextSelectionChanged: (PdfTextSelectionChangedDetails details) {
              if (details.selectedText != null &&
                  details.selectedText!.isNotEmpty) {
                _showTextSelectionActions(vm, details);
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context, SimpleStudentPdfVm vm) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
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
                      color: Colors.black87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.school, size: 16, color: Colors.green[600]),
                      const SizedBox(width: 4),
                      Text(
                        'Student PDF Reader',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Annotate button
            ElevatedButton.icon(
              onPressed: () => _openPdfWithAnnotations(vm),
              icon: const Icon(Icons.edit, size: 20),
              label: const Text('Annotate'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[600],
                foregroundColor: Colors.white,
                elevation: 2,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showTextSelectionActions(
    SimpleStudentPdfVm vm,
    PdfTextSelectionChangedDetails details,
  ) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Selected Text Actions'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Selected: "${details.selectedText}"',
                  style: const TextStyle(fontStyle: FontStyle.italic),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 16),
                const Text('Choose an action:'),
              ],
            ),
            actions: [
              TextButton.icon(
                onPressed: () async {
                  Navigator.of(context).pop();
                  await _addHighlightAndSave(vm);
                },
                icon: const Icon(Icons.highlight),
                label: const Text('Highlight & Save'),
              ),
              TextButton.icon(
                onPressed: () async {
                  Navigator.of(context).pop();
                  await _addToMindMap(vm, details);
                },
                icon: const Icon(Icons.hub),
                label: const Text('Add to Mind Map'),
              ),
              TextButton.icon(
                onPressed: () async {
                  Navigator.of(context).pop();
                  await _createNote(vm, details);
                },
                icon: const Icon(Icons.note_add),
                label: const Text('Create Note'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
            ],
          ),
    );
  }

  Future<void> _addHighlightAndSave(SimpleStudentPdfVm vm) async {
    try {
      // Add highlight annotation (this is handled by the PDF viewer automatically when text is selected)
      // The highlight is already applied by Syncfusion when user selects text

      // Save the document with annotations
      await _savePdfWithAnnotations(vm);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Highlight saved successfully!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error saving highlight: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _savePdfWithAnnotations(SimpleStudentPdfVm vm) async {
    try {
      // Save annotations to the PDF document using Syncfusion's saveDocument method
      final List<int> bytes = await vm.pdfController.saveDocument();

      // Write the bytes back to the original file
      final file = File(vm.documentPath!);
      await file.writeAsBytes(bytes, flush: true);

      debugPrint('PDF saved with annotations to: ${vm.documentPath}');
    } catch (e) {
      debugPrint('Error saving PDF with annotations: $e');
      rethrow;
    }
  }

  Future<void> _addToMindMap(
    SimpleStudentPdfVm vm,
    PdfTextSelectionChangedDetails details,
  ) async {
    try {
      // For now, just show a placeholder - you can implement based on your data models
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Add to Mind Map - implement with your data models'),
          backgroundColor: Colors.blue,
          duration: Duration(seconds: 2),
        ),
      );

      // TODO: Implement based on your Content model
      // final content = Content(...);
      // await DatabaseHelper.instance.insertContent(content);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error adding to mind map: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _createNote(
    SimpleStudentPdfVm vm,
    PdfTextSelectionChangedDetails details,
  ) async {
    try {
      // For now, just show a placeholder - you can implement based on your data models
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Create Note - implement with your data models'),
          backgroundColor: Colors.purple,
          duration: Duration(seconds: 2),
        ),
      );

      // TODO: Implement based on your Content model
      // final content = Content(...);
      // await DatabaseHelper.instance.insertContent(content);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error creating note: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _openPdfWithAnnotations(SimpleStudentPdfVm vm) async {
    if (vm.documentPath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No PDF file available'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      // Auto-save any existing highlights before opening annotation mode
      await _savePdfWithAnnotations(vm);

      // Use the original plugin with same-file saving
      await FlutterPdfAnnotations.openPDF(
        filePath: vm.documentPath!,
        savePath: vm.documentPath!, // Save to same file
        onFileSaved: (String? savedPath) async {
          if (savedPath != null) {
            // PDF was saved successfully - no toast needed
            debugPrint('PDF annotations saved to: $savedPath');
          } else {
            // Handle save error silently
            debugPrint('Failed to save PDF annotations');
          }
        },
      );
    } catch (e) {
      debugPrint('Error opening PDF with annotations: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error opening PDF: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
