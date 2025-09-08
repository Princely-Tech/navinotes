import 'package:navinotes/packages.dart';

class PdfViewVm extends ChangeNotifier {
  GlobalKey<ScaffoldState> scaffoldKey;
  ComPdfVm comPdfVm;
  int contentId;
  Content? content;
  bool isLoading = true;
  String? errorMessage;
  
  PdfViewVm({
    required this.scaffoldKey, 
    required this.comPdfVm,
    required this.contentId,
  });

  String currentPdfPath = 'assets/example.pdf';

  // final GlobalKey<SfPdfViewerState> pdfViewerKey = GlobalKey();
  // final PdfViewerController pdfViewerController = PdfViewerController();

  // Uint8List? pdfData;

  // void updatePdfData(Uint8List data) {
  //   pdfData = data;
  //   notifyListeners();
  // }

  Future<void> initialize(BuildContext context) async {
    try {
      isLoading = true;
      notifyListeners();
      
      // Load content from database
      content = await DatabaseHelper.instance.getContentById(contentId);
      
      if (content == null) {
        errorMessage = 'Content not found';
        isLoading = false;
        notifyListeners();
        return;
      }
      
      // Check if content has a file path
      if (content!.file == null || content!.file!.isEmpty) {
        errorMessage = 'PDF file not found for this content';
        isLoading = false;
        notifyListeners();
        return;
      }
      
      // Verify file exists
      final file = File(content!.file!);
      if (!await file.exists()) {
        errorMessage = 'PDF file does not exist at: ${content!.file}';
        isLoading = false;
        notifyListeners();
        return;
      }
      
      // Update current PDF path and initialize ComPdfVm
      currentPdfPath = content!.file!;
      comPdfVm.initialize(context, currentPdfPath);
      
      isLoading = false;
      notifyListeners();
      
    } catch (e) {
      debugPrint('Error initializing PDF view: $e');
      errorMessage = 'Error loading PDF: $e';
      isLoading = false;
      notifyListeners();
    }
  }

  // // String currentPdfPath = 'assets/example.pdf';

  // // void updatePdfPath(String newPath) {
  // //   currentPdfPath = newPath;
  // //   notifyListeners();
  // // }

  void openDrawer() {
    scaffoldKey.currentState?.openEndDrawer();
  }
}
