import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_pdf_annotations/flutter_pdf_annotations.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'dart:io';
import 'simple_student_pdf_vm.dart';
import 'package:navinotes/packages.dart';

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
  PdfTextSelectionChangedDetails? _selectedTextDetails;

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

            return _buildPdfReaderWithPanel(vm);
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

  Widget _buildPdfReaderWithPanel(SimpleStudentPdfVm vm) {
    if (vm.documentPath == null) {
      return const Center(child: Text('No document path available'));
    }

    return Column(
      children: [
        // Header with Annotate button
        _buildHeader(context, vm),

        // Main content area with PDF viewer and right panel
        Expanded(
          child: Row(
            children: [
              // PDF Viewer (left side)
              Expanded(
                flex: _selectedTextDetails != null ? 3 : 1,
                child: SfPdfViewer.file(
                  File(vm.documentPath!),
                  controller: vm.pdfController,
                  canShowScrollHead: true,
                  canShowScrollStatus: true,
                  canShowPaginationDialog: true,
                  enableTextSelection: true,
                  onDocumentLoaded: (details) {
                    debugPrint(
                      'PDF loaded: ${details.document.pages.count} pages',
                    );
                  },
                  onDocumentLoadFailed: (details) {
                    debugPrint('PDF load failed: ${details.error}');
                  },
                  onTextSelectionChanged: (
                    PdfTextSelectionChangedDetails details,
                  ) {
                    setState(() {
                      if (details.selectedText != null &&
                          details.selectedText!.isNotEmpty) {
                        _selectedTextDetails = details;
                      } else {
                        _selectedTextDetails = null;
                      }
                    });
                  },
                ),
              ),

              // Right panel (shows when text is selected)
              if (_selectedTextDetails != null) ...[
                Container(width: 1, color: Colors.grey[300]),
                _buildRightPanel(vm),
              ],
            ],
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

  Widget _buildRightPanel(SimpleStudentPdfVm vm) {
    return Container(
      width: 320,
      color: Colors.grey[50],
      child: Column(
        children: [
          // Panel header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 2,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(Icons.text_fields, color: Colors.blue[600], size: 20),
                const SizedBox(width: 8),
                const Text(
                  'Selected Text',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {
                    setState(() {
                      _selectedTextDetails = null;
                    });
                  },
                  icon: const Icon(Icons.close, size: 20),
                  tooltip: 'Close panel',
                ),
              ],
            ),
          ),

          // Selected text display
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Selected text content
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.yellow[50],
                      border: Border.all(color: Colors.yellow[200]!),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _selectedTextDetails?.selectedText ?? '',
                      style: const TextStyle(fontSize: 14, height: 1.4),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Action buttons
                  const Text(
                    'Actions',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Copy Text button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => _copySelectedText(),
                      icon: const Icon(Icons.copy, size: 18),
                      label: const Text('Copy Text'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[600],
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Add to Mind Map button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => _addToMindMap(vm, _selectedTextDetails!),
                      icon: const Icon(Icons.hub, size: 18),
                      label: const Text('Add to Mind Map'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[600],
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Create Note button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => _createNote(vm, _selectedTextDetails!),
                      icon: const Icon(Icons.note_add, size: 18),
                      label: const Text('Create Note'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple[600],
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _copySelectedText() {
    if (_selectedTextDetails?.selectedText != null) {
      Clipboard.setData(
        ClipboardData(text: _selectedTextDetails!.selectedText!),
      );

      // Show success feedback
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Text copied to clipboard!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );

      // Optionally close the panel after copying
      setState(() {
        _selectedTextDetails = null;
      });
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
      // Create mind map node using the selected text
      await createNodeInMindMap(
        boardId: vm.content!.boardId,
        text: details.selectedText ?? 'Selected Text',
        connectedContentId: vm.content!.id,
      );

      // Close the panel
      setState(() {
        _selectedTextDetails = null;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Added to Mind Map successfully!'),
          backgroundColor: Colors.blue,
          duration: Duration(seconds: 2),
        ),
      );
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
    bool isLoading = false;

    void setLoading(bool loading) {
      setState(() {
        isLoading = loading;
      });
    }

    try {
      // Create note using the selected text
      await createContentInDb(
        template: noteTemplateBlank,
        context: context,
        boardId: vm.content!.boardId,
        setLoading: setLoading,
        title: 'Note from PDF - ${vm.content?.title ?? "Document"}',
        contentBody: details.selectedText ?? '',
        connectedContentId: vm.content!.id,
      );

      // Close the panel
      setState(() {
        _selectedTextDetails = null;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Note created successfully!'),
          backgroundColor: Colors.purple,
          duration: Duration(seconds: 2),
        ),
      );
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

      // Reload the PDF viewer to show updated annotations
      await _reloadPdfViewer(vm);
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

  Future<void> _reloadPdfViewer(SimpleStudentPdfVm vm) async {
    try {
      // Force refresh by creating a new controller and triggering a rebuild
      await vm.createNewPdfController();
      
      // Trigger a rebuild to show the updated PDF with new annotations
      if (mounted) {
        setState(() {
          // This will force the SfPdfViewer to rebuild with the new controller
        });
      }
      
      debugPrint('PDF viewer reloaded to show updated annotations');
    } catch (e) {
      debugPrint('Error reloading PDF viewer: $e');
    }
  }
}
