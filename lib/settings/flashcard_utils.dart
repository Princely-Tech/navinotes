import 'package:navinotes/packages.dart';

Document safeDocFromJson(List<Map<String, dynamic>> json) {
  try {
    if (json.isEmpty) return Document()..insert(0, '');
    return Document.fromJson(json);
  } catch (_) {
    return Document()..insert(0, ''); // fallback
  }
}
String jsonToPlainText(List<Map<String, dynamic>> delta) {
  return delta.map((e) => e['insert']?.toString() ?? '').join('');
}
