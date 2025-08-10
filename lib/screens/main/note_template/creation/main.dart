import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:navinotes/packages.dart';
import 'package:navinotes/screens/main/note_template/creation/widget/title.dart';
import 'package:navinotes/screens/main/note_template/creation/widget/voice.dart';
import 'vm.dart';
import 'widget/note_page.dart';

class NoteCreationMain extends StatelessWidget {
  const NoteCreationMain({super.key});

  @override
  Widget build(BuildContext context) {
    final inputWidth = MediaQuery.of(context).size.width;
    final inputHeight = MediaQuery.of(context).size.height * 3;

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
            if (vm.currentMode != NoteMode.voice)
              NoteDrawingWrapper(
                vm: vm,
                color: color,
                inputWidth: inputWidth,
                inputHeight: inputHeight,
              ),
            if (vm.currentMode == NoteMode.voice)
              buildVoiceRecorder(vm, color, context),
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
                      title(),
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
          color:
              isActive ? Theme.of(context).primaryColor.withOpacity(0.1) : null,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isActive ? Theme.of(context).primaryColor : Colors.grey,
            ),
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
}
