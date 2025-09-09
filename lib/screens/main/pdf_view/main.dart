import 'package:compdfkit_flutter/configuration/cpdf_options.dart';
import 'package:navinotes/packages.dart';

class PdfViewMain extends StatelessWidget {
  const PdfViewMain({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PdfViewVm>(
      builder: (_, vm, _) {
        return Column(
          children: [PdfViewHeader(), Expanded(child: _buildContent(vm))],
        );
      },
    );
  }

  Widget _buildContent(PdfViewVm vm) {
    // Show loading state
    if (vm.isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text(
              'Loading PDF...',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    // Show error state
    if (vm.errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red[400]),
            SizedBox(height: 16),
            Text(
              'Error Loading PDF',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.red[700],
              ),
            ),
            SizedBox(height: 8),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                vm.errorMessage!,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => NavigationHelper.pop(),
              child: Text('Go Back'),
            ),
          ],
        ),
      );
    }

    // Show PDF viewer if document is loaded
    if (isNotNull(vm.comPdfVm.document)) {
      debugPrint('Rendering PDF viewer with document: ${vm.comPdfVm.document}');

      debugPrint("Rendering: ${vm.comPdfVm.document?.length} ");
      // Try a simple approach first - just the widget with minimal config
      return Scaffold(
        backgroundColor: Colors.white,
        body: CPDFReaderWidget(
          document: vm.comPdfVm.document!,
          configuration: CPDFConfiguration(
            toolbarConfig: CPDFToolbarConfig(mainToolbarVisible: true),
          ),
          onSaveCallback: () {
            debugPrint('PDF Saved');
          },
          onCreated: (controller) {
            debugPrint('PDF Reader Created with controller: $controller');
          },
        ),
      );
    }

    // Fallback loading state
    return const Center(child: CircularProgressIndicator());
  }
}
