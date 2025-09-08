import 'package:navinotes/packages.dart';

class ComPdfVm extends ChangeNotifier {
  String? document;

  void initialize(BuildContext context, String documentPath) {
    try {
      debugPrint('ComPdfVm: Initializing ComPDFKit...');
      ComPDFKit.init(EnvKeys.comPdfKey);

      // Add a small delay before processing the document
      Future.delayed(Duration(milliseconds: 200), () {
        _getDocumentPath(context, documentPath)
            .then((value) {
              document = value;
              debugPrint('ComPdfVm: Document loaded at path: $value');
              // Verify the file exists at the final path
              final file = File(value);
              if (file.existsSync()) {
                debugPrint(
                  'ComPdfVm: Final document file verified, size: ${file.lengthSync()} bytes',
                );
              } else {
                debugPrint(
                  'ComPdfVm: ERROR - Final document file does not exist!',
                );
              }
              notifyListeners();
            })
            .catchError((error) {
              debugPrint('ComPdfVm: Error loading document: $error');
            });
      });
    } catch (err) {
      debugPrint('ComPdfVm: Initialization error: $err');
    }
  }

  Future<String> _getDocumentPath(
    BuildContext context,
    String documentPath,
  ) async {
    debugPrint('ComPdfVm: Processing document path: $documentPath');

    // Check if it's an asset path (starts with 'assets/')
    if (documentPath.startsWith('assets/')) {
      return _loadFromAssets(context, documentPath);
    } else {
      // It's a file system path, copy to temp directory for ComPDF
      return _loadFromFileSystem(documentPath);
    }
  }

  Future<String> _loadFromAssets(BuildContext context, String assetPath) async {
    final bytes = await DefaultAssetBundle.of(context).load(assetPath);
    final list = bytes.buffer.asUint8List();
    final tempDir = await ComPDFKit.getTemporaryDirectory();
    var pdfsDir = Directory('${tempDir.path}/pdfs');
    pdfsDir.createSync(recursive: true);

    final filename = assetPath.split('/').last;
    final tempDocumentPath = '${pdfsDir.path}/$filename';

    final file = File(tempDocumentPath);
    if (!file.existsSync()) {
      file.create(recursive: true);
      file.writeAsBytesSync(list);
    }
    return tempDocumentPath;
  }

  Future<String> _loadFromFileSystem(String filePath) async {
    final sourceFile = File(filePath);
    if (!sourceFile.existsSync()) {
      throw Exception('PDF file does not exist at: $filePath');
    }

    // Check file size
    final fileSize = sourceFile.lengthSync();
    debugPrint('ComPdfVm: Source PDF file size: $fileSize bytes');

    if (fileSize == 0) {
      throw Exception('PDF file is empty: $filePath');
    }

    final tempDir = await ComPDFKit.getTemporaryDirectory();
    var pdfsDir = Directory('${tempDir.path}/pdfs');
    pdfsDir.createSync(recursive: true);

    final filename = filePath.split('/').last;
    final tempDocumentPath = '${pdfsDir.path}/$filename';

    final tempFile = File(tempDocumentPath);

    // Copy the file to temp directory if it doesn't exist or is different
    if (!tempFile.existsSync() ||
        tempFile.lengthSync() != sourceFile.lengthSync()) {
      await sourceFile.copy(tempDocumentPath);
      debugPrint('ComPdfVm: Copied PDF to temp path: $tempDocumentPath');
      debugPrint(
        'ComPdfVm: Temp PDF file size: ${tempFile.lengthSync()} bytes',
      );
    }

    // Verify the temp file exists and has content
    if (!tempFile.existsSync()) {
      throw Exception('Failed to copy PDF to temp directory');
    }

    if (tempFile.lengthSync() == 0) {
      throw Exception('Copied PDF file is empty');
    }

    return tempDocumentPath;
  }
}
