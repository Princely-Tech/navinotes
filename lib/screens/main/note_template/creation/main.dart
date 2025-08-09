import 'package:flutter/material.dart';
import 'package:flutter_drawing_board/flutter_drawing_board.dart';
import 'package:navinotes/packages.dart';
import 'lined_rule.dart';
import 'squared_rule.dart';
import 'vm.dart';
import 'dotted.dart';

class NoteCreationMain extends StatelessWidget {
  const NoteCreationMain({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<NoteCreationVm>(
      builder: (_, vm, _) {
        Color color = AppTheme.transparent;
        switch (vm.template.image) {
          case Images.noteTemplateCornell:
            color = const Color(0xFFD1CDC4);
        }
        
        return Column(
          children: [
            _header(vm),
            _modeSelector(vm, context),
            if (vm.currentMode == NoteMode.text) ..._buildTextEditor(vm, color),
            if (vm.currentMode == NoteMode.drawing) _buildDrawingBoard(vm, color),
            if (vm.currentMode == NoteMode.voice) _buildVoiceRecorder(vm, color, context),
          ],
        );
      },
    );
  }

  // Build the header with title and actions
  Widget _header(NoteCreationVm vm) {
    return Consumer<NoteCreationVm>(
      builder: (_, vm, _) {
        return Consumer<PomodoroTimer>(
          builder: (_, pomodorVm, _) {
            return Consumer<LayoutProviderVm>(
              builder: (_, layoutVm, _) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 15,
                  ),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: AppTheme.lightGray),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    spacing: 10,
                    children: [
                      _title(),
                      if (pomodorVm.isRunning) _timer(pomodorVm),
                      Row(
                        children: [
                          if (layoutVm.deviceType != DeviceType.mobile)
                            _shareAndAI(vm),
                          VisibleController(
                            mobile: true,
                            desktop: false,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: MenuButton(onPressed: vm.openEndDrawer),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  // Build the mode selector (Text, Drawing, Voice)
  Widget _modeSelector(NoteCreationVm vm, BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildModeButton(
            context,
            icon: Icons.text_fields,
            label: 'Text',
            isActive: vm.currentMode == NoteMode.text,
            onTap: () => vm.setMode(NoteMode.text),
          ),
          _buildModeButton(
            context,
            icon: Icons.brush,
            label: 'Draw',
            isActive: vm.currentMode == NoteMode.drawing,
            onTap: () => vm.setMode(NoteMode.drawing),
          ),
          _buildModeButton(
            context,
            icon: Icons.mic,
            label: 'Voice',
            isActive: vm.currentMode == NoteMode.voice,
            onTap: () => vm.setMode(NoteMode.voice),
          ),
        ],
      ),
    );
  }

  Widget _buildModeButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? Theme.of(context).primaryColor.withOpacity(0.1) : null,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Icon(icon, color: isActive ? Theme.of(context).primaryColor : Colors.grey),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                color: isActive ? Theme.of(context).primaryColor : Colors.grey,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Build text editor components
  List<Widget> _buildTextEditor(NoteCreationVm vm, Color color) {
   

    return [
      // Simple toolbar for text formatting
      QuillSimpleToolbar(
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
      // The editor itself
      Expanded(
        child: Stack(
          children: [
            // Background patterns
            const SquaredNoteBackground(),
            const LinedNoteBackground(),
            const DottedNoteBackground(),
            // Editor content
            Container(
              color: color,
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: ResponsiveHorizontalPadding(
                child: QuillEditor.basic(
                  controller: vm.richEditorController,
                  config: const QuillEditorConfig(),
                ),
              ),
            ),
          ],
        ),
      ),
    ];
  }

  // Build drawing board
  Widget _buildDrawingBoard(NoteCreationVm vm, Color color) {
    return Expanded(
      child: Stack(
        children: [
          // Background patterns
          const SquaredNoteBackground(),
          const LinedNoteBackground(),
          const DottedNoteBackground(),
          // Drawing board
          Container(
            color: color,
            child: DrawingBoard(
              

              controller: vm.drawingController,
              background: Container(
                color: color,
              ),
              showDefaultActions: true,
              showDefaultTools: true,
            ),
          ),
          // Drawing tools overlay
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FloatingActionButton.small(
                  heroTag: 'clear_drawing',
                  onPressed: vm.clearDrawing,
                  child: const Icon(Icons.delete_outline),
                ),
                const SizedBox(width: 16),
                FloatingActionButton.small(
                  heroTag: 'save_drawing',
                  onPressed: vm.saveDrawing,
                  child: const Icon(Icons.save),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Build voice recorder
  Widget _buildVoiceRecorder(NoteCreationVm vm, Color color, BuildContext context) {
    return Expanded(
      child: Container(
        color: color,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Visualizer or instructions
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey[200],
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  if (vm.isRecording)
                    const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                      strokeWidth: 4,
                    ),
                  Icon(
                    Icons.mic,
                    size: 64,
                    color: vm.isRecording ? Colors.red : Colors.grey[600],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            // Recording status
            Text(
              vm.isRecording
                  ? 'Recording...'
                  : vm.hasRecording
                      ? 'Tap to play/pause'
                      : 'Tap to record',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 24),
            // Control buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Clear button (only shown when there's a recording)
                if (vm.hasRecording)
                  FloatingActionButton(
                    heroTag: 'clear_recording',
                    onPressed: vm.clearRecording,
                    backgroundColor: Colors.grey[300],
                    child: Icon(Icons.delete, color: Colors.grey[800]),
                  ),
                const SizedBox(width: 24),
                // Record/Stop button
                FloatingActionButton.large(
                  heroTag: 'record_button',
                  onPressed: vm.toggleRecording,
                  backgroundColor: vm.isRecording ? Colors.red : Theme.of(context).primaryColor,
                  child: Icon(
                    vm.isRecording ? Icons.stop : Icons.mic,
                    size: 32,
                  ),
                ),
                const SizedBox(width: 24),
                // Play/Pause button (only shown when there's a recording)
                if (vm.hasRecording)
                  FloatingActionButton(
                    heroTag: 'play_button',
                    onPressed: vm.togglePlayback,
                    backgroundColor: Theme.of(context).primaryColor,
                    child: Icon(
                      vm.isPlaying ? Icons.pause : Icons.play_arrow,
                      size: 32,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _shareAndAI(NoteCreationVm vm) {
    return Row(
      spacing: 15,
      children: [
        AppButton.text(
          onTap: vm.openAiSection,
          child: SVGImagePlaceHolder(
            imagePath: Images.aiIcon,
            size: 35,
            color: AppTheme.stormGray,
          ),
        ),
        AppButton(onTap: () {}, text: 'Share', mainAxisSize: MainAxisSize.min),
      ],
    );
  }

  Widget _timer(PomodoroTimer pomodorVm) {
    return Row(
      spacing: 5,
      children: [
        SVGImagePlaceHolder(
          imagePath: Images.clock,
          size: 16,
          color: AppTheme.stormGray,
        ),
        Text(
          formatPomodoroTime(pomodorVm.elapsedSeconds),
          textAlign: TextAlign.center,
          style: TextStyle(
            color: const Color(0xFF4B5563),
            fontSize: 14.0,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w400,
            height: 1.43,
          ),
        ),
      ],
    );
  }

  Widget _title() {
    return Consumer<NoteCreationVm>(
      builder: (_, vm, _) {
        return Flexible(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              VisibleController(
                mobile: true,
                largeDesktop: false,
                child: Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: MenuButton(onPressed: vm.openDrawer),
                ),
              ),
              Flexible(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: NavigationHelper.pop,
                      icon: Icon(
                        Icons.arrow_back,
                        color: const Color(0xFF4B5563),
                      ),
                    ),
                    Flexible(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            child: ValueListenableBuilder(
                              valueListenable: vm.titleController,
                              builder: (_, controller, __) {
                                final style = TextStyle(
                                  color: const Color(0xFF4B5563),
                                  fontSize: 14.0,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w500,
                                  height: 1.43,
                                );
                                final textWidth =
                                    calculateTextWidth(controller.text, style) +
                                    30;
                                return WidthLimiter(
                                  mobile: textWidth,
                                  child: CustomInputField(
                                    focusNode: vm.titleFocusNode,
                                    controller: vm.titleController,
                                    contentPadding: EdgeInsets.zero,
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                    ),
                                    style: style,
                                  ),
                                );
                              },
                            ),
                          ),
                          VisibleController(
                            mobile: isNotNull(vm.content),
                            child: FutureBuilder(
                              future: DatabaseHelper.instance.getBoard(
                                vm.content!.boardId,
                              ),
                              builder: (context, snapshot) {
                                final board = snapshot.data;
                                if (isNotNull(board)) {
                                  return Text.rich(
                                    overflow: TextOverflow.ellipsis,
                                    TextSpan(
                                      children: [
                                        TextSpan(
                                          text: '• ',
                                          style: TextStyle(
                                            color: const Color(0xFF9CA3AF),
                                            fontSize: 14.0,
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w400,
                                            height: 1.43,
                                          ),
                                        ),
                                        TextSpan(
                                          text: board!.name,
                                          style: TextStyle(
                                            color: const Color(0xFF4B5563),
                                            fontSize: 14.0,
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w400,
                                            height: 1.43,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }
                                return const SizedBox.shrink();
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
