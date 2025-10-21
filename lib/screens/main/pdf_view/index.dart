import 'package:navinotes/packages.dart';
import 'plugin_enhanced_pdf_screen.dart';

class PdfViewScreen extends StatelessWidget {
  const PdfViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Use plugin-enhanced PDF screen with silent auto-saving
    return const PluginEnhancedPdfScreen();
  }
}
