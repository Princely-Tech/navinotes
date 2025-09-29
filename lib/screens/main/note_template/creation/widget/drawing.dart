import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_drawing_board/flutter_drawing_board.dart';
import 'package:navinotes/screens/main/note_template/creation/vm.dart';
import 'package:flutter_drawing_board/helpers.dart';
import 'package:flutter_drawing_board/paint_contents.dart';

Widget buildDrawingBoard(
  NoteCreationVm vm,
  double inputWidth,
  double inputHeight,
) {
  // Validate dimensions to prevent "Invalid image dimensions" error
  final validWidth =
      inputWidth.isFinite && inputWidth > 10 ? inputWidth : 595.0;
  final validHeight =
      inputHeight.isFinite && inputHeight > 10 ? inputHeight : 842.0;

  // Additional safety check - if dimensions are still invalid, return empty container
  if (validWidth < 10 || validHeight < 10) {
    return Container(
      width: validWidth,
      height: validHeight,
      color: Colors.transparent,
    );
  }

  return IgnorePointer(
    ignoring: vm.currentMode != NoteMode.drawing,
    child: Container(
      width: validWidth,
      height: validHeight,
      child: DrawingBoardWithCursor(
        key: ValueKey(
          'drawing_${vm.currentPageIndex}_${vm.drawingController.hashCode}',
        ),
        controller: vm.drawingController,
        width: validWidth,
        height: validHeight,
        vm: vm,
      ),
    ),
  );
}

Widget buildDrawingToolbar({required NoteCreationVm vm}) {
  // Define default tool items
  List<DefToolItem> defaultTools(Type currType, DrawingController controller) {
    return <DefToolItem>[
      DefToolItem(
        isActive: currType == SimpleLine,
        icon: Icons.edit,
        onTap: () => controller.setPaintContent(SimpleLine()),
      ),
      DefToolItem(
        isActive: currType == SmoothLine,
        icon: Icons.brush,
        onTap: () => controller.setPaintContent(SmoothLine()),
      ),
      DefToolItem(
        isActive: currType == StraightLine,
        icon: Icons.show_chart,
        onTap: () => controller.setPaintContent(StraightLine()),
      ),
      DefToolItem(
        isActive: currType == Rectangle,
        icon: CupertinoIcons.stop,
        onTap: () => controller.setPaintContent(Rectangle()),
      ),
      DefToolItem(
        isActive: currType == Circle,
        icon: CupertinoIcons.circle,
        onTap: () => controller.setPaintContent(Circle()),
      ),
      DefToolItem(
        isActive: currType == Eraser,
        icon: CupertinoIcons.bandage,
        onTap: () => controller.setPaintContent(Eraser()),
      ),
    ];
  }

  return Positioned(
    top: 0,
    left: 0,
    right: 0,
    child: Container(
      color: Colors.white,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.zero,
        child: ExValueBuilder<DrawConfig>(
          valueListenable: vm.drawingController.drawConfig,
          shouldRebuild:
              (DrawConfig p, DrawConfig n) => p.contentType != n.contentType,
          builder: (_, DrawConfig dc, ___) {
            final Type currType = dc.contentType;

            final List<Widget> children =
                defaultTools(currType, vm.drawingController)
                    .map(
                      (DefToolItem item) => IconButton(
                        onPressed: item.onTap,
                        icon: Icon(
                          item.icon,
                          color: item.isActive ? item.activeColor : item.color,
                          size: item.iconSize,
                        ),
                      ),
                    )
                    .toList();

            return ExValueBuilder<DrawConfig>(
              valueListenable: vm.drawingController.drawConfig,
              builder: (_, DrawConfig dc, ___) {
                return Row(
                  children: [
                    SizedBox(
                      height: 24,
                      width: 160,
                      child: Slider(
                        value: dc.strokeWidth,
                        max: 50,
                        min: 1,
                        onChanged:
                            (double v) =>
                                vm.drawingController.setStyle(strokeWidth: v),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        CupertinoIcons.arrow_turn_up_left,
                        color:
                            vm.drawingController.canUndo() ? null : Colors.grey,
                      ),
                      onPressed: () => vm.drawingController.undo(),
                    ),
                    IconButton(
                      icon: Icon(
                        CupertinoIcons.arrow_turn_up_right,
                        color:
                            vm.drawingController.canRedo() ? null : Colors.grey,
                      ),
                      onPressed: () => vm.drawingController.redo(),
                    ),
                    ...children,
                  ],
                );
              },
            );
          },
        ),
      ),
    ),
  );
}

class DrawingBoardWithCursor extends StatefulWidget {
  final DrawingController controller;
  final double width;
  final double height;
  final NoteCreationVm vm;

  const DrawingBoardWithCursor({
    required this.controller,
    required this.width,
    required this.height,
    required this.vm,
    Key? key,
  }) : super(key: key);

  @override
  State<DrawingBoardWithCursor> createState() => _DrawingBoardWithCursorState();
}

class _DrawingBoardWithCursorState extends State<DrawingBoardWithCursor> {
  Offset? _cursorPos;

  @override
  void initState() {
    super.initState();
    // Listen to drawing controller changes to trigger rebuilds
    widget.controller.addListener(_onDrawingChanged);
  }

  @override
  void didUpdateWidget(DrawingBoardWithCursor oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      // Remove listener from old controller
      oldWidget.controller.removeListener(_onDrawingChanged);
      // Add listener to new controller
      widget.controller.addListener(_onDrawingChanged);
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onDrawingChanged);
    super.dispose();
  }

  void _onDrawingChanged() {
    if (mounted) {
      setState(() {
        // Trigger rebuild when drawing content changes
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Validate dimensions to prevent rendering issues
    final validWidth =
        widget.width.isFinite && widget.width > 10 ? widget.width : 595.0;
    final validHeight =
        widget.height.isFinite && widget.height > 10 ? widget.height : 842.0;

    // Additional safety check for very small dimensions that could cause rendering issues
    if (validWidth < 10 || validHeight < 10) {
      return Container(
        width: validWidth,
        height: validHeight,
        color: Colors.transparent,
      );
    }

    return Listener(
      onPointerHover: (e) {
        if (mounted) {
          setState(() => _cursorPos = e.localPosition);
        }
      },
      onPointerMove: (e) {
        if (mounted) {
          setState(() => _cursorPos = e.localPosition);
        }
      },
      onPointerDown: (e) {
        if (mounted) {
          setState(() => _cursorPos = e.localPosition);
          // Notify VM that drawing has started
          widget.vm.setDrawingState(true);
        }
      },
      onPointerUp: (e) {
        if (mounted) {
          setState(() => _cursorPos = null);
          // Notify VM that drawing has ended
          widget.vm.setDrawingState(false);
        }
      },
      child: RepaintBoundary(
        child: Stack(
          children: [
            DrawingBoard(
              controller: widget.controller,
              background: Container(
                width: validWidth,
                height: validHeight,
                color: Colors.transparent,
              ),
              showDefaultActions: false,
              showDefaultTools: false,
            ),
            if (_cursorPos != null)
              ValueListenableBuilder<DrawConfig>(
                valueListenable: widget.controller.drawConfig,
                builder: (_, drawConfig, __) {
                  return Positioned(
                    left: _cursorPos!.dx - drawConfig.strokeWidth / 2,
                    top: _cursorPos!.dy - drawConfig.strokeWidth / 2,
                    child: IgnorePointer(
                      child: Container(
                        width: drawConfig.strokeWidth,
                        height: drawConfig.strokeWidth,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.black26, width: 1),
                        ),
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
