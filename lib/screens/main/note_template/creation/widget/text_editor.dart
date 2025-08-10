import 'package:navinotes/packages.dart';
import 'package:navinotes/screens/main/note_template/creation/vm.dart';

Widget buildEditorToolBar(NoteCreationVm vm) {
  return Positioned(
    top: 0,
    left: 0,
    right: 0,
    child: Container(
      color: Colors.white,
      child: QuillSimpleToolbar(
        controller: vm.richEditorController,
        config: const QuillSimpleToolbarConfig(
          showAlignmentButtons: true,
          multiRowsDisplay: false,
          customButtons: const [],
          showFontFamily: false,
          showFontSize: false,
          showColorButton: false,
          showBackgroundColorButton: false,
          showClearFormat: false,
          showBoldButton: true,
          showItalicButton: true,
          showUnderLineButton: true,
          showStrikeThrough: true,
          showCodeBlock: false,
          showListNumbers: true,
          showListBullets: true,
          showListCheck: false,
          showQuote: true,
          showIndent: false,
          showLink: false,
          showSearchButton: false,
          showDirection: false,
          showHeaderStyle: false,
          showUndo: true,
          showRedo: true,
          showSubscript: false,
          showSuperscript: false,
          showDividers: true,
          showSmallButton: false,
        ),
      ),
    ),
  );
}

Widget buildTextEditor(
  NoteCreationVm vm,
  double inputWidth,
  double inputHeight,
) {
  return Container(
    width: inputWidth,
    height: inputHeight,
    padding: const EdgeInsets.only(top: 55, bottom: 24),
    child: ResponsiveHorizontalPadding(
      child: QuillEditor.basic(
        controller: vm.richEditorController,
        config: const QuillEditorConfig(),
      ),
    ),
  );
}
