import 'package:navinotes/packages.dart';
import 'package:navinotes/screens/main/notebook/notebook_page_vm.dart';

class DraggableTextBox extends StatefulWidget {
  final TextBox textBox;
  final NotebookPageVm vm;
  final bool isInteractive;

  const DraggableTextBox({
    super.key,
    required this.textBox,
    required this.vm,
    required this.isInteractive,
  });

  @override
  State<DraggableTextBox> createState() => _DraggableTextBoxState();
}

class _DraggableTextBoxState extends State<DraggableTextBox> {
  late FocusNode _focusNode;
  bool _isResizing = false;
  Offset? _resizeStartPosition;
  Size? _resizeStartSize;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    
    // Listen to focus changes
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        widget.vm.selectTextBox(widget.textBox.id);
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isSelected = widget.vm.selectedTextBoxId == widget.textBox.id;
    
    return Positioned(
      left: widget.textBox.position.dx,
      top: widget.textBox.position.dy,
      child: GestureDetector(
        onPanStart: widget.isInteractive ? _onPanStart : null,
        onPanUpdate: widget.isInteractive ? _onPanUpdate : null,
        onPanEnd: widget.isInteractive ? _onPanEnd : null,
        onTap: widget.isInteractive ? () => _selectTextBox() : null,
        child: Container(
          width: widget.textBox.size.width,
          height: widget.textBox.size.height,
          decoration: BoxDecoration(
            border: isSelected && widget.isInteractive
                ? Border.all(color: Theme.of(context).primaryColor, width: 2)
                : Border.all(color: Colors.grey.withOpacity(0.3)),
            borderRadius: BorderRadius.circular(4),
            color: Colors.white.withOpacity(0.9),
            boxShadow: isSelected && widget.isInteractive
                ? [
                    BoxShadow(
                      color: Theme.of(context).primaryColor.withOpacity(0.3),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Stack(
            children: [
              // Text editor
              Positioned.fill(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: QuillEditor(
                    controller: widget.textBox.controller,
                    scrollController: ScrollController(),
                    focusNode: _focusNode,
                    config: QuillEditorConfig(
                      placeholder: 'Type here...',
                      showCursor: widget.isInteractive,
                      padding: EdgeInsets.zero,
                      expands: false,
                      scrollable: false,
                    ),
                  ),
                ),
              ),
              
              // Resize handle (bottom-right corner)
              if (isSelected && widget.isInteractive)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onPanStart: _onResizeStart,
                    onPanUpdate: _onResizeUpdate,
                    onPanEnd: _onResizeEnd,
                    child: Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(4),
                          bottomRight: Radius.circular(4),
                        ),
                      ),
                      child: const Icon(
                        Icons.drag_handle,
                        size: 12,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              
              // Delete button (top-right corner)
              if (isSelected && widget.isInteractive)
                Positioned(
                  top: -8,
                  right: -8,
                  child: GestureDetector(
                    onTap: () => widget.vm.deleteTextBox(widget.textBox.id),
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 2,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.close,
                        size: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _selectTextBox() {
    widget.vm.selectTextBox(widget.textBox.id);
    _focusNode.requestFocus();
  }

  void _onPanStart(DragStartDetails details) {
    if (_isResizing) return;
    widget.vm.selectTextBox(widget.textBox.id);
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (_isResizing) return;
    
    final newPosition = widget.textBox.position + details.delta;
    
    // Ensure the text box stays within bounds
    final constrainedPosition = Offset(
      newPosition.dx.clamp(0.0, double.infinity),
      newPosition.dy.clamp(0.0, double.infinity),
    );
    
    widget.vm.updateTextBox(
      widget.textBox.id,
      position: constrainedPosition,
    );
  }

  void _onPanEnd(DragEndDetails details) {
    // Save the final position
    // This is already handled in _onPanUpdate
  }

  void _onResizeStart(DragStartDetails details) {
    _isResizing = true;
    _resizeStartPosition = details.globalPosition;
    _resizeStartSize = widget.textBox.size;
  }

  void _onResizeUpdate(DragUpdateDetails details) {
    if (!_isResizing || _resizeStartPosition == null || _resizeStartSize == null) return;
    
    final delta = details.globalPosition - _resizeStartPosition!;
    final newSize = Size(
      (_resizeStartSize!.width + delta.dx).clamp(100.0, 500.0),
      (_resizeStartSize!.height + delta.dy).clamp(50.0, 300.0),
    );
    
    widget.vm.updateTextBox(
      widget.textBox.id,
      size: newSize,
    );
  }

  void _onResizeEnd(DragEndDetails details) {
    _isResizing = false;
    _resizeStartPosition = null;
    _resizeStartSize = null;
  }
}
