import 'package:navinotes/packages.dart';

bool isNotNull(dynamic value) => value != null;

bool isNull(dynamic value) => value == null;

void logError(String message) {
  debugPrint(message);
}

bool getMenuVisible(DeviceType deviceType) {
  return deviceType == DeviceType.mobile ||
      deviceType == DeviceType.tablet ||
      deviceType == DeviceType.laptop;
}
T getRandomListElement<T>(List<T> items) {
  final random = Random();
  return items[random.nextInt(items.length)];
}
double calculateTextWidth(String text, TextStyle style) {
  final TextPainter textPainter = TextPainter(
    text: TextSpan(text: text, style: style),
    maxLines: 1,
    textDirection: TextDirection.ltr,
  )..layout();

  return textPainter.width;
}
