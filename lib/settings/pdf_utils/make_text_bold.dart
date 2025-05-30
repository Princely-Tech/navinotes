import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:navinotes/packages.dart';



Future<void> boldTextInPdf(String textToBold) async {
  // Load PDF from assets
  final data = await rootBundle.load('assets/example.pdf');
  final bytes = data.buffer.asUint8List();

  // Load the PDF document
  final document = PdfDocument(inputBytes: bytes);

  // Search for text in the document
  final finder = PdfTextFinder(document);
  final results = finder.find(textToBold);

  for (final result in results) {
    for (final textElement in result.textElements) {
      textElement.font = PdfStandardFont(PdfFontFamily.helvetica, textElement.fontSize, style: PdfFontStyle.bold);
    }
  }

  // Save updated document
  final outputBytes = document.save();
  document.dispose();

  // Save to file system (temporary path)
  final dir = await getApplicationDocumentsDirectory();
  final filePath = '${dir.path}/updated_example.pdf';
  final file = File(filePath);
  await file.writeAsBytes(outputBytes, flush: true);

  print('Saved bolded PDF at: $filePath');
}