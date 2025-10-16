import 'package:flutter/material.dart';
import 'package:navinotes/screens/main/note_template/read/vm.dart';
import 'package:navinotes/screens/main/note_template/read/widget/dotted.dart';
import 'package:navinotes/screens/main/note_template/read/widget/drawing.dart';
import 'package:navinotes/screens/main/note_template/read/widget/lined_rule.dart';
import 'package:navinotes/screens/main/note_template/read/widget/squared_rule.dart';
import 'package:navinotes/screens/main/note_template/read/widget/text_editor.dart';

class NoteDrawingWrapper extends StatefulWidget {
  final NoteReadVm vm;
  final Color color;
  final double inputWidth;
  final double inputHeight;

  const NoteDrawingWrapper({
    Key? key,
    required this.vm,
    required this.color,
    required this.inputWidth,
    required this.inputHeight,
  }) : super(key: key);

  @override
  State<NoteDrawingWrapper> createState() => NoteDrawingWrapperState();
}

class NoteDrawingWrapperState extends State<NoteDrawingWrapper> {
  int fingerCount = 0;

  @override
  Widget build(BuildContext context) {
    final vm = widget.vm;

    return Expanded(
      child: Listener(
        onPointerDown: (_) => setState(() => fingerCount++),
        onPointerUp:
            (_) => setState(() => fingerCount = (fingerCount - 1).clamp(0, 10)),
        child: Stack(
          children: [
            // Scrollable background + text
            SingleChildScrollView(
              physics:
                  (vm.currentMode == NoteMode.drawing && fingerCount < 2)
                      ? const NeverScrollableScrollPhysics()
                      : const BouncingScrollPhysics(),
              child: Stack(
                children: [
                  // Background pattern
                  SizedBox(
                    height: widget.inputHeight,
                    width: widget.inputWidth,
                    child: Stack(
                      children: [
                        Container(
                          width: widget.inputWidth,
                          height: widget.inputHeight,
                          color: widget.color,
                        ),
                        const SquaredNoteBackground(),
                        const LinedNoteBackground(),
                        const DottedNoteBackground(),
                      ],
                    ),
                  ),

                  ...getWidget(vm),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> getWidget(NoteReadVm vm) {
    return (vm.currentMode == NoteMode.text)
        ? [
          // Text editor
          IgnorePointer(
            ignoring: true,
            child: buildDrawingBoard(vm, widget.inputWidth, widget.inputHeight),
          ),
          // Drawing overlay
          Positioned.fill(
            child: buildTextEditor(vm, widget.inputWidth, widget.inputHeight),
          ),
        ]
        : [
          // Text editor
          buildTextEditor(vm, widget.inputWidth, widget.inputHeight),
          // Drawing overlay
          Positioned.fill(
            child: IgnorePointer(
              ignoring: false,
              child: buildDrawingBoard(
                vm,
                widget.inputWidth,
                widget.inputHeight,
              ),
            ),
          ),
        ];
  }
}
