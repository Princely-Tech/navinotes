import 'package:navinotes/packages.dart';

class EnvKeys {
  static String get comPdfKey {
    final key = dotenv.env['ComPdfKey'];
    if (key == null || key.isEmpty) {
      throw Exception('ComPdf license key not found in environment variables. Please add ComPdfKey to your .env file.');
    }
    return key;
  }
}
