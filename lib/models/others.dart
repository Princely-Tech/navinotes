import 'package:navinotes/packages.dart';

class RichTextPropItem {
  final String text;
  final bool highlight;
  RichTextPropItem({required this.text, this.highlight = false});
}

class RichTextProp {
  final List<RichTextPropItem> items;
  RichTextProp(this.items);
}

class NoteCreationProp {
  final int contentId;
  final BoardNoteTemplate template;
  NoteCreationProp({required this.contentId, required this.template});
}
