import 'package:navinotes/packages.dart';

class ComPdfVm extends ChangeNotifier {
  String? document;

  void initialize(BuildContext context, String documentPath) {
    try {
      ComPDFKit.init(EnvKeys.comPdfKey);
      _getDocumentPath(context, documentPath).then((value) {
        document = value;
        notifyListeners();
      });
    } catch (err) {
      // print(err);
    }
  }

  Future<String> _getDocumentPath(
    BuildContext context,
    String documentPath,
  ) async {
    final bytes = await DefaultAssetBundle.of(context).load(documentPath);
    final list = bytes.buffer.asUint8List();
    final tempDir = await ComPDFKit.getTemporaryDirectory();
    var pdfsDir = Directory('${tempDir.path}/pdfs');
    pdfsDir.createSync(recursive: true);

    // final tempDocumentPath = '${tempDir.path}/$documentPath';

    final filename = documentPath.split('/').last; // example.pdf
    final tempDocumentPath = '${pdfsDir.path}/$filename';

    final file = File(tempDocumentPath);
    if (!file.existsSync()) {
      file.create(recursive: true);
      file.writeAsBytesSync(list);
    }
    return tempDocumentPath;
  }
}
