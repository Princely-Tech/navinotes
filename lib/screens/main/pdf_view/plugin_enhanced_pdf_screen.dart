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
          
          return _buildPdfReaderView(vm);
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
  
  Widget _buildPdfReaderView(SimpleStudentPdfVm vm) {
    if (vm.documentPath == null) {
      return const Center(child: Text('No document path available'));
    }
    
    return Column(
      children: [
        // Header with Annotate button
        _buildHeader(context, vm),
        
        // PDF Viewer
        Expanded(
          child: SfPdfViewer.file(
            File(vm.documentPath!),
            controller: vm.pdfController,
            canShowScrollHead: true,
            canShowScrollStatus: true,
            canShowPaginationDialog: true,
            onDocumentLoaded: (details) {
              debugPrint('PDF loaded: ${details.document.pages.count} pages');
            },
            onDocumentLoadFailed: (details) {
              debugPrint('PDF load failed: ${details.error}');
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
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
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
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
      // Use the enhanced plugin with silent saving
      await FlutterPdfAnnotationsEnhanced.openPDFForNaviNotes(
        filePath: vm.documentPath!,
        onFileSaved: (String? savedPath) async {
          if (savedPath != null) {
            // PDF was saved successfully - no toast needed
            debugPrint('PDF annotations saved to: $savedPath');
            
            // Optionally refresh the PDF viewer to show new annotations
            // The PDF viewer will automatically show the updated file
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

/// Enhanced wrapper for flutter_pdf_annotations with NaviNotes integration
class FlutterPdfAnnotationsEnhanced {
  static Future<void> openPDFForNaviNotes({
    required String filePath,
    required void Function(String?) onFileSaved,
  }) async {
    // Use the original plugin with same-file saving and no toasts
    await FlutterPdfAnnotations.openPDF(
      filePath: filePath,
      savePath: filePath, // Save to same file
      onFileSaved: (String? savedPath) {
        // Silent saving - no toast messages
        onFileSaved(savedPath);
      },
    );
  }
}
