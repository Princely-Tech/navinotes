import 'package:flutter/material.dart';
import 'package:flutter_drawing_board/flutter_drawing_board.dart';
import 'package:navinotes/screens/main/notebook/notebook_page_vm.dart';

class NotebookDrawingBoard extends StatefulWidget {
  final NotebookPageVm vm;
  final bool isInteractive;

  const NotebookDrawingBoard({
    super.key,
    required this.vm,
    required this.isInteractive,
  });

  @override
  State<NotebookDrawingBoard> createState() => _NotebookDrawingBoardState();
}

class _NotebookDrawingBoardState extends State<NotebookDrawingBoard> {
  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: !widget.isInteractive,
      child: DrawingBoard(
        controller: widget.vm.drawingController,
        background: Container(color: Colors.transparent),
        showDefaultActions: false,
        showDefaultTools: false,
      ),
    );
  }
}
