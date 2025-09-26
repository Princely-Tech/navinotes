import 'package:flutter/material.dart';
import 'package:navinotes/packages.dart';
import 'package:navinotes/screens/main/note_template/creation/vm.dart';
import 'package:navinotes/screens/main/note_template/creation/widget/drawing.dart';

class CenteredToolbar extends StatelessWidget {
  final NoteCreationVm vm;

  const CenteredToolbar({
    Key? key,
    required this.vm,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<NoteCreationVm>(
      builder: (context, vm, child) {
        // Only show toolbar for text and drawing modes
        if (vm.currentMode == NoteMode.read || vm.currentMode == NoteMode.voice) {
          return const SizedBox.shrink();
        }

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              bottom: BorderSide(
                color: Colors.grey[200]!,
                width: 1,
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: _buildToolbarContent(vm),
          ),
        );
      },
    );
  }

  Widget _buildToolbarContent(NoteCreationVm vm) {
    switch (vm.currentMode) {
      case NoteMode.text:
        return _buildTextToolbar(vm);
      case NoteMode.drawing:
        return _buildDrawingToolbar(vm);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildTextToolbar(NoteCreationVm vm) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 600),
      child: QuillSimpleToolbar(
        controller: vm.currentTextController,
        config: buildCustomToolbarConfig(
          showAlignmentButtons: true,
          showFontSize: true,
          showBoldButton: true,
          showItalicButton: true,
          showUnderLineButton: true,
          showStrikeThrough: true,
          showListBullets: true,
          showListNumbers: true,
          showUndo: true,
          showRedo: true,
        ),
      ),
    );
  }

  Widget _buildDrawingToolbar(NoteCreationVm vm) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 800),
      child: buildDrawingToolbar(vm: vm),
    );
  }
}
