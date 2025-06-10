// import 'package:navinotes/packages.dart';

// TODO  delete this

// Future<void> makeTextBolder(
//   PdfViewVm vm,
//   PdfTextSelectionChangedDetails details,
// ) async {
//   String currentPdfPath = 'assets/example.pdf';
//   try {
//     // final File inputFile = File(currentPdfPath);
//     // print(inputFile);
//     // final PdfDocument document = PdfDocument(
//     //   inputBytes: await inputFile.readAsBytes(),
//     // );



//     final ByteData bytes = await rootBundle.load(currentPdfPath);

//     final PdfDocument document = PdfDocument(
//       inputBytes: bytes.buffer.asUint8List(),
//     );

//     // final List<TextLine> lines = extractor.extractTextLines(
//     //   startPageIndex: pageNumber,
//     //   endPageIndex: pageNumber,
//     // );
//     // print(lines);

//     final Rect bounds = details.globalSelectedRegion!;
//     int pageNumber = vm.pdfViewerController.pageNumber;
//     PdfPage page = document.pages[pageNumber];

//     // Cover original text
//     page.graphics.drawRectangle(brush: PdfBrushes.white, bounds: bounds);

//     // Draw bold text
//     page.graphics.drawString(
//       details.selectedText!,
//       PdfStandardFont(
//         PdfFontFamily.helvetica,
//         30,
//         // word.fontSize,
//         style: PdfFontStyle.bold,
//       ),
//       brush: PdfBrushes.black,
//       bounds: bounds,
//       format: PdfStringFormat(
//         lineAlignment: PdfVerticalAlignment.top,
//         alignment: PdfTextAlignment.left,
//       ),
//     );
//     final List<int> updatedBytes = await document.save();
//     vm.updatePdfData(Uint8List.fromList(updatedBytes));
//     print('Updated path in vm');
//   } catch (e) {
//     print("Error making text bolder: $e");

//     // Handle error (e.g., show snackbar)
//   } finally {
//     // vm.setProcessing(false);
//   }
// }
