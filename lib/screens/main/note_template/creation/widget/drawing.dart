import 'package:flutter/material.dart';
import 'package:navinotes/screens/main/note_template/creation/vm.dart';
import 'package:flutter_drawing_board/flutter_drawing_board.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_drawing_board/helpers.dart';
import 'package:flutter_drawing_board/paint_contents.dart';

Widget buildDrawingBoard(
  NoteCreationVm vm,
  double inputWidth,
  double inputHeight,
) {
  return IgnorePointer(
    ignoring: vm.currentMode != NoteMode.drawing,
    child: Container(
      width: inputWidth,
      height: inputHeight,
      child: DrawingBoard(
        controller: vm.drawingController,
        background: Container(
          color: Colors.transparent,
          width: inputWidth,
          height: inputHeight,
        ),
        showDefaultActions: false,
        showDefaultTools: false,
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
