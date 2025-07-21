import 'package:navinotes/packages.dart';
import 'package:uuid/uuid.dart';

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

generateGUID(int userId) {
  return "0${userId}0_${Uuid().v4()}";
}

int generateUnixTimestamp() {
  return DateTime.now().millisecondsSinceEpoch ~/ 1000;
}

QuillSimpleToolbarConfig buildCustomToolbarConfig({
  bool showBoldButton = false,
  bool showItalicButton = false,
  bool showLink = false,
  bool showListBullets = false,
  bool showFontFamily = false,
  bool showFontSize = false,
  bool showSmallButton = false,
  bool showUnderLineButton = false,
  bool showLineHeightButton = false,
  bool showStrikeThrough = false,
  bool showInlineCode = false,
  bool showColorButton = false,
  bool showBackgroundColorButton = false,
  bool showClearFormat = false,
  bool showAlignmentButtons = false,
  bool showLeftAlignment = false,
  bool showCenterAlignment = false,
  bool showRightAlignment = false,
  bool showJustifyAlignment = false,
  bool showHeaderStyle = false,
  bool showListNumbers = false,
  bool showListCheck = false,
  bool showCodeBlock = false,
  bool showQuote = false,
  bool showIndent = false,
  bool showUndo = false,
  bool showRedo = false,
  bool showDirection = false,
  bool showSearchButton = false,
  bool showSubscript = false,
  bool showSuperscript = false,
  bool showClipboardCut = false,
  bool showClipboardCopy = false,
  bool showClipboardPaste = false,
}) {
  return QuillSimpleToolbarConfig(
    showBoldButton: showBoldButton,
    showItalicButton: showItalicButton,
    showLink: showLink,
    showListBullets: showListBullets,
    showFontFamily: showFontFamily,
    showFontSize: showFontSize,
    showSmallButton: showSmallButton,
    showUnderLineButton: showUnderLineButton,
    showLineHeightButton: showLineHeightButton,
    showStrikeThrough: showStrikeThrough,
    showInlineCode: showInlineCode,
    showColorButton: showColorButton,
    showBackgroundColorButton: showBackgroundColorButton,
    showClearFormat: showClearFormat,
    showAlignmentButtons: showAlignmentButtons,
    showLeftAlignment: showLeftAlignment,
    showCenterAlignment: showCenterAlignment,
    showRightAlignment: showRightAlignment,
    showJustifyAlignment: showJustifyAlignment,
    showHeaderStyle: showHeaderStyle,
    showListNumbers: showListNumbers,
    showListCheck: showListCheck,
    showCodeBlock: showCodeBlock,
    showQuote: showQuote,
    showIndent: showIndent,
    showUndo: showUndo,
    showRedo: showRedo,
    showDirection: showDirection,
    showSearchButton: showSearchButton,
    showSubscript: showSubscript,
    showSuperscript: showSuperscript,
    showClipboardCut: showClipboardCut,
    showClipboardCopy: showClipboardCopy,
    showClipboardPaste: showClipboardPaste,
  );
}
bool compareStrings(String str1, String str2) {
  return str1.toLowerCase() == str2.toLowerCase();
}

String formatUnixTimestamp(int timestamp) {
  final date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
  return DateFormat('MMM d, yyyy').format(date); 
}