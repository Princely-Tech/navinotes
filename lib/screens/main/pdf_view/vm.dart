import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfViewVm extends ChangeNotifier {
  GlobalKey<ScaffoldState> scaffoldKey;
  PdfViewVm({required this.scaffoldKey});
  final GlobalKey<SfPdfViewerState> pdfViewerKey = GlobalKey();
  final PdfViewerController pdfViewerController = PdfViewerController();
  void openDrawer() {
    scaffoldKey.currentState?.openEndDrawer();
  }
}

