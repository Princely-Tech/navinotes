import 'package:flutter/material.dart';
import 'package:navinotes/screens/main/pdf_view/footer.dart';
import 'package:navinotes/screens/main/pdf_view/header.dart';
import 'package:navinotes/screens/main/pdf_view/vm.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfViewMain extends StatelessWidget {
  const PdfViewMain({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PdfViewVm>(
      builder: (_, vm, _) {
        return Column(
          children: [
            PdfViewHeader(),
            Expanded(
              child: SfPdfViewer.asset(
                key: vm.pdfViewerKey,
                'assets/example.pdf',
                controller: vm.pdfViewerController,
              ),
            ),
            PdfViewFooter(),
          ],
        );
      },
    );
  }
}
