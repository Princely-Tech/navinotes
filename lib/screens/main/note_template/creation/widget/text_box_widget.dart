import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/text_box.dart';

/// Callback types for text box interactions
typedef TextBoxUpdateCallback = void Function(TextBox textBox);
typedef TextBoxDeleteCallback = void Function(String textBoxId);
typedef TextBoxSelectCallback = void Function(String? textBoxId);

/// Interactive text box widget that can be edited and moved
class TextBoxWidget extends StatefulWidget {
  final TextBox textBox;
  final bool isSelected;
  final bool isEditing;
  final TextBoxUpdateCallback onUpdate;
  final TextBoxDeleteCallback onDelete;
  final TextBoxSelectCallback onSelect;
  final VoidCallback? onStartEdit;
  final VoidCallback? onEndEdit;

  const TextBoxWidget({
    Key? key,
    required this.textBox,
    required this.isSelected,
    required this.isEditing,
    required this.onUpdate,
    required this.onDelete,
    required this.onSelect,
    this.onStartEdit,
    this.onEndEdit,
  }) : super(key: key);

  @override
  State<TextBoxWidget> createState() => _TextBoxWidgetState();
}

class _TextBoxWidgetState extends State<TextBoxWidget> {
  late TextEditingController _textController;
  late FocusNode _focusNode;
  Offset? _dragStart;
  Offset? _dragOffset;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.textBox.text);
    _focusNode = FocusNode();
    
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus && widget.isEditing) {
        _finishEditing();
      }
    });
  }

  @override
  void didUpdateWidget(TextBoxWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    if (oldWidget.textBox.text != widget.textBox.text) {
      _textController.text = widget.textBox.text;
    }
    
    if (widget.isEditing && !oldWidget.isEditing) {
      _startEditing();
    } else if (!widget.isEditing && oldWidget.isEditing) {
      _focusNode.unfocus();
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _startEditing() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _focusNode.requestFocus();
        _textController.selection = TextSelection(
          baseOffset: 0,
          extentOffset: _textController.text.length,
        );
      }
    });
  }

  void _finishEditing() {
    if (_textController.text != widget.textBox.text) {
      final updatedTextBox = widget.textBox.copyWith(
        text: _textController.text,
        updatedAt: DateTime.now(),
      );
      widget.onUpdate(updatedTextBox);
    }
    widget.onEndEdit?.call();
  }

  void _handleTap() {
    widget.onSelect(widget.textBox.id);
  }

  void _handleDoubleTap() {
    widget.onSelect(widget.textBox.id);
    widget.onStartEdit?.call();
  }

  void _handlePanStart(DragStartDetails details) {
    _dragStart = details.localPosition;
    _dragOffset = Offset.zero;
    widget.onSelect(widget.textBox.id);
  }

  void _handlePanUpdate(DragUpdateDetails details) {
    if (_dragStart == null) return;
    
    setState(() {
      _dragOffset = details.localPosition - _dragStart!;
    });
  }

  void _handlePanEnd(DragEndDetails details) {
    if (_dragOffset != null && _dragOffset != Offset.zero) {
      final newPosition = widget.textBox.position + _dragOffset!;
      final updatedTextBox = widget.textBox.copyWith(
        position: newPosition,
        updatedAt: DateTime.now(),
      );
      widget.onUpdate(updatedTextBox);
    }
    
    _dragStart = null;
    _dragOffset = null;
  }

  void _handleDelete() {
    widget.onDelete(widget.textBox.id);
  }

  Widget _buildSelectionBorder() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.blue,
          width: 2.0,
        ),
        borderRadius: widget.textBox.borderRadius,
      ),
      child: Stack(
        children: [
          // Resize handles
          Positioned(
            top: -4,
            right: -4,
            child: _buildResizeHandle(),
          ),
          // Delete button
          Positioned(
            top: -12,
            right: -12,
            child: _buildDeleteButton(),
          ),
        ],
      ),
    );
  }

  Widget _buildResizeHandle() {
    return GestureDetector(
      onPanStart: (details) {
        // TODO: Implement resize functionality
      },
      child: Container(
        width: 16,
        height: 16,
        decoration: BoxDecoration(
          color: Colors.blue,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 1),
        ),
        child: const Icon(
          Icons.drag_indicator,
          size: 10,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildDeleteButton() {
    return GestureDetector(
      onTap: _handleDelete,
      child: Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          color: Colors.red,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 1),
        ),
        child: const Icon(
          Icons.close,
          size: 12,
          color: Colors.white,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentPosition = widget.textBox.position + (_dragOffset ?? Offset.zero);
    
    return Positioned(
      left: currentPosition.dx,
      top: currentPosition.dy,
      child: GestureDetector(
        onTap: widget.isEditing ? null : _handleTap,
        onDoubleTap: widget.isEditing ? null : _handleDoubleTap,
        onPanStart: widget.isEditing ? null : _handlePanStart,
        onPanUpdate: widget.isEditing ? null : _handlePanUpdate,
        onPanEnd: widget.isEditing ? null : _handlePanEnd,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Main text box container
            Container(
              width: widget.textBox.size.width,
              height: widget.textBox.size.height,
              padding: widget.textBox.padding,
              decoration: BoxDecoration(
                color: widget.textBox.backgroundColor,
                border: widget.textBox.hasBorder
                  ? Border.all(
                      color: widget.textBox.borderColor,
                      width: widget.textBox.borderWidth,
                    )
                  : null,
                borderRadius: widget.textBox.borderRadius,
              ),
              child: widget.isEditing
                ? _buildEditingField()
                : _buildDisplayText(),
            ),
            
            // Selection border and controls
            if (widget.isSelected && !widget.isEditing)
              _buildSelectionBorder(),
          ],
        ),
      ),
    );
  }

  Widget _buildEditingField() {
    return TextField(
      controller: _textController,
      focusNode: _focusNode,
      style: widget.textBox.textStyle,
      textAlign: widget.textBox.textAlign,
      maxLines: null,
      expands: true,
      decoration: const InputDecoration(
        border: InputBorder.none,
        contentPadding: EdgeInsets.zero,
        isDense: true,
      ),
      onSubmitted: (_) => _finishEditing(),
      onTapOutside: (_) => _finishEditing(),
    );
  }

  Widget _buildDisplayText() {
    return Text(
      widget.textBox.text.isEmpty ? 'Text' : widget.textBox.text,
      style: widget.textBox.text.isEmpty 
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
        children: widget.textBoxes.map((textBox) {
          return TextBoxWidget(
            key: ValueKey(textBox.id),
            textBox: textBox,
            isSelected: widget.selectedTextBoxId == textBox.id,
            isEditing: widget.editingTextBoxId == textBox.id,
            onUpdate: widget.onTextBoxUpdate,
            onDelete: widget.onTextBoxDelete,
            onSelect: widget.onTextBoxSelect,
            onStartEdit: widget.onStartEdit,
            onEndEdit: widget.onEndEdit,
          );
        }).toList(),
      ),
    );
  }
}
