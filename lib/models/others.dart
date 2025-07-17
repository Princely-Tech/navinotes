class RichTextPropItem {
  final String text;
  final bool highlight;
  RichTextPropItem({required this.text, this.highlight = false});
}

class RichTextProp {
  final List<RichTextPropItem> items;
  RichTextProp(this.items);
}
