import 'package:flutter/material.dart';
import 'package:flutter_drawing_board/flutter_drawing_board.dart';
import '../vm.dart';

/// Enhanced drawing widget with pressure sensitivity and stylus support
class PressureDrawingWidget extends StatefulWidget {
  final DrawingController controller;
  final double width;
  final double height;
  final NoteReadVm vm;

  const PressureDrawingWidget({
    Key? key,
    required this.controller,
    required this.width,
    required this.height,
    required this.vm,
  }) : super(key: key);

  @override
  State<PressureDrawingWidget> createState() => _PressureDrawingWidgetState();
}

class _PressureDrawingWidgetState extends State<PressureDrawingWidget>
    with TickerProviderStateMixin {
  late AnimationController _cursorAnimationController;

  @override
  void initState() {
    super.initState();
    _cursorAnimationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
  }

  @override
  void dispose() {
    // Stop any running animations before disposing
    try {
      _cursorAnimationController.stop();
      _cursorAnimationController.reset();
      _cursorAnimationController.dispose();
    } catch (e) {
      debugPrint('Error disposing cursor animation controller: $e');
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Validate dimensions
    final validWidth =
        widget.width.isFinite && widget.width > 10 ? widget.width : 595.0;
    final validHeight =
        widget.height.isFinite && widget.height > 10 ? widget.height : 842.0;

    if (validWidth < 10 || validHeight < 10) {
      return Container(
        width: 100,
        height: 100,
        color: Colors.transparent,
        child: const Center(child: Text('Drawing unavailable')),
      );
    }

    return IgnorePointer(
      ignoring: widget.vm.currentMode != NoteMode.drawing,
      child: Container(
        width: validWidth,
        height: validHeight,
        child: _buildDrawingBoard(validWidth, validHeight),
      ),
    );
  }

  Widget _buildDrawingBoard(double width, double height) {
    return RepaintBoundary(
      child: Container(
        width: width,
        height: height,
        child: DrawingBoard(
          controller: widget.controller,
          background: Container(
            width: width,
            height: height,
            color: Colors.transparent,
          ),
          showDefaultActions: false,
          showDefaultTools: false,
        ),
      ),
    );
  }
}
