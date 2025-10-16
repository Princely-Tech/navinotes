import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../creation/models/text_box.dart';

/// Callback types for text box interactions
typedef TextBoxUpdateCallback = void Function(TextBox textBox);
typedef TextBoxDeleteCallback = void Function(String textBoxId);
typedef TextBoxSelectCallback = void Function(String? textBoxId);

/// Interactive text box widget that can be edited and moved
class TextBoxWidget extends StatefulWidget {
  final TextBox textBox;

  const TextBoxWidget({Key? key, required this.textBox}) : super(key: key);

  @override
  State<TextBoxWidget> createState() => _TextBoxWidgetState();
}

class _TextBoxWidgetState extends State<TextBoxWidget> {
  late TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.textBox.text);
  }

  @override
  void didUpdateWidget(TextBoxWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.textBox.text != widget.textBox.text) {
      _textController.text = widget.textBox.text;
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentPosition = widget.textBox.position;

    return Positioned(
      left: currentPosition.dx,
      top: currentPosition.dy,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Main text box container with smooth transitions
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            width: widget.textBox.size.width,
            height: widget.textBox.size.height,
            padding: widget.textBox.padding,
            decoration: BoxDecoration(
              color:
                  (widget.textBox.backgroundColor.opacity > 0
                      ? widget.textBox.backgroundColor
                      : Colors.white.withOpacity(0.9)),
              border:
                  (widget.textBox.hasBorder
                      ? Border.all(
                        color: widget.textBox.borderColor,
                        width: widget.textBox.borderWidth,
                      )
                      : Border.all(
                        color: Colors.grey.withOpacity(0.3),
                        width: 1.0,
                      )),
              borderRadius: widget.textBox.borderRadius,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: _buildDisplayText(),
          ),
        ],
      ),
    );
  }

  Widget _buildDisplayText() {
    return Text(
      widget.textBox.text.isEmpty ? 'Text' : widget.textBox.text,
      style:
          widget.textBox.text.isEmpty
              ? widget.textBox.textStyle.copyWith(color: Colors.grey)
              : widget.textBox.textStyle,
      textAlign: widget.textBox.textAlign,
      maxLines: null,
      overflow: TextOverflow.visible,
    );
  }
}

/// Text box overlay that manages multiple text boxes
class TextBoxOverlay extends StatefulWidget {
  final List<TextBox> textBoxes;
  final String? selectedTextBoxId;
  final String? editingTextBoxId;
  final TextBoxUpdateCallback onTextBoxUpdate;
  final TextBoxDeleteCallback onTextBoxDelete;
  final TextBoxSelectCallback onTextBoxSelect;
  final VoidCallback? onStartEdit;
  final VoidCallback? onEndEdit;
  final Size canvasSize;

  const TextBoxOverlay({
    Key? key,
    required this.textBoxes,
    this.selectedTextBoxId,
    this.editingTextBoxId,
    required this.onTextBoxUpdate,
    required this.onTextBoxDelete,
    required this.onTextBoxSelect,
    this.onStartEdit,
    this.onEndEdit,
    required this.canvasSize,
  }) : super(key: key);

  @override
  State<TextBoxOverlay> createState() => _TextBoxOverlayState();
}

class _TextBoxOverlayState extends State<TextBoxOverlay> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.canvasSize.width,
      height: widget.canvasSize.height,
      child: Stack(
        children:
            widget.textBoxes.map((textBox) {
              return TextBoxWidget(
                key: ValueKey(textBox.id),
                textBox: textBox,
              );
            }).toList(),
      ),
    );
  }
}
