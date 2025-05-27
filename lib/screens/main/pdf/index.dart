import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PDFAnnotationScreen extends StatelessWidget {
  const PDFAnnotationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("PDF Viewer")),
      body: SfPdfViewer.asset('assets/example.pdf'),
    );
  }
}
