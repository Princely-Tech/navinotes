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

T stringToEnum<T extends Enum>(String value, List<T> values) {
  return values.firstWhere(
    (type) => type.toString() == value,
    orElse: () => throw 'Invalid type: $value',
  );
}

generateGUID(int userId) {
  return "0${userId}0_${Uuid().v4()}";
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

bool checkStringMatch(String str1, String str2) {
  return str1.toLowerCase().contains(str2.toLowerCase());
}

bool getBoolFromInt(value) {
  if (value == null) {
    return false;
  }
  return value == 1;
}

int getIntFromBool(bool value) {
  return value ? 1 : 0;
}

String getSlicedBoardName(Board board) {
  return board.name.length > 13
      ? '${board.name.substring(0, 13)}...'
      : board.name;
}

String getNoteCountText(List<Content> contents) {
  String text = '${contents.length} Note Page';
  if (contents.length > 1) {
    text = '${text}s';
  }
  return text;
}

String stringOrNotSpecified(String? data) {
  return data ?? 'Not specified';
}

Future<void> callPhoneNumber(String number) async {
  final Uri callUri = Uri(scheme: 'tel', path: number);
  if (await canLaunchUrl(callUri)) {
    await launchUrl(callUri);
  } else {
    throw 'Could not launch $number';
  }
}