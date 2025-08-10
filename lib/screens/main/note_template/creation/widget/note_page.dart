import 'package:flutter/material.dart';
import 'package:navinotes/screens/main/note_template/creation/vm.dart';
import 'package:navinotes/screens/main/note_template/creation/widget/dotted.dart';
import 'package:navinotes/screens/main/note_template/creation/widget/drawing.dart';
import 'package:navinotes/screens/main/note_template/creation/widget/lined_rule.dart';
import 'package:navinotes/screens/main/note_template/creation/widget/squared_rule.dart';
import 'package:navinotes/screens/main/note_template/creation/widget/text_editor.dart';

class NoteDrawingWrapper extends StatefulWidget {
  final NoteCreationVm vm;
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
                  // Background patterns
                  Column(
                    children: [
                      SizedBox(
                        height: widget.inputHeight,
                        child: const SquaredNoteBackground(),
                      ),
                      SizedBox(
                        height: widget.inputHeight,
                        child: const LinedNoteBackground(),
                      ),
                      SizedBox(
                        height: widget.inputHeight,
                        child: const DottedNoteBackground(),
                      ),
                      Container(
                        width: widget.inputWidth,
                        height: widget.inputHeight,
                        color: widget.color,
                      ),
                    ],
                  ),

                  // Text editor
                  buildTextEditor(vm, widget.inputWidth, widget.inputHeight),

                  // Drawing overlay
                  Positioned.fill(
                    child: IgnorePointer(
                      ignoring: vm.currentMode != NoteMode.drawing,
                      child: buildDrawingBoard(
                        vm,
                        widget.inputWidth,
                        widget.inputHeight,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Toolbar
            if (vm.currentMode == NoteMode.text) buildEditorToolBar(vm),
            if (vm.currentMode == NoteMode.drawing) buildDrawingToolbar(vm: vm),
          ],
        ),
      ),
    );
  }
}
