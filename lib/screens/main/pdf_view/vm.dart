import 'package:navinotes/packages.dart';

class PdfViewVm extends ChangeNotifier {
  GlobalKey<ScaffoldState> scaffoldKey;
  ComPdfVm comPdfVm;
  PdfViewVm({required this.scaffoldKey, required this.comPdfVm});

  String currentPdfPath = 'assets/example.pdf';

  // final GlobalKey<SfPdfViewerState> pdfViewerKey = GlobalKey();
  // final PdfViewerController pdfViewerController = PdfViewerController();

  // Uint8List? pdfData;

  // void updatePdfData(Uint8List data) {
  //   pdfData = data;
  //   notifyListeners();
  // }

  Future<void> initialize(BuildContext context) async {
    comPdfVm.initialize(context, currentPdfPath); 
    // final ByteData byteData = await rootBundle.load('assets/example.pdf');
    // updatePdfData(byteData.buffer.asUint8List());
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
