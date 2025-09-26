import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:navinotes/packages.dart';
import 'package:navinotes/screens/main/note_template/creation/widget/title.dart';
import 'package:navinotes/screens/main/note_template/creation/widget/multi_page_viewer.dart';
import 'package:navinotes/screens/main/note_template/creation/widget/page_settings_dialog.dart';
import 'package:navinotes/screens/main/note_template/creation/widget/centered_toolbar.dart';
import 'vm.dart';

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
            // Centered toolbar above pages
            CenteredToolbar(vm: vm),
            Expanded(
              child: MultiPageViewer(
                vm: vm,
                backgroundColor: color,
                inputWidth: inputWidth,
                inputHeight: inputHeight,
              ),
            ),
          ],
        );
      },
    );
  }

  // Build the header with title and actions
  Widget _header(NoteCreationVm vm) {
    return Consumer<NoteCreationVm>(
      builder: (context, vm, _) {
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
                      VisibleController(
                        mobile: false,
                        tablet: true,
                        child: _modeSelector(vm, context),
                      ),
                      Row(
                        children: [
                          // IconButton(
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
    return Consumer<LayoutProviderVm>(
      builder: (_, layoutVm, _) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            border: Border(
              bottom: getDeviceResponsiveValue(
                deviceType: layoutVm.deviceType,
                tablet: BorderSide.none,
                mobile: BorderSide(color: Colors.grey[200]!),
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildModeButton(
                context,
                icon: Icons.menu_book,
                label: 'Read',
                isActive: vm.currentMode == NoteMode.read,
                onTap: () => vm.setMode(NoteMode.read),
              ),
              _buildModeButton(
                context,
                icon: Icons.brush,
                label: 'Hand',
                isActive: vm.currentMode == NoteMode.drawing,
                onTap: () => vm.setMode(NoteMode.drawing),
              ),
              _buildModeButton(
                context,
                icon: Icons.text_fields,
                label: 'Text',
                isActive: vm.currentMode == NoteMode.text,
                onTap: () => vm.setMode(NoteMode.text),
              ),
              _buildModeButton(
                context,
                icon: Icons.mic,
                label: 'Voice',
                isActive: vm.currentMode == NoteMode.voice,
                onTap: () => vm.setMode(NoteMode.voice),
              ),
              // Divider
              Container(
                height: 30,
                width: 1,
                color: Colors.grey[300],
                margin: const EdgeInsets.symmetric(horizontal: 8),
              ),
              // Page Settings Button
              _buildModeButton(
                context,
                icon: Icons.settings,
                label: 'Settings',
                isActive: false,
                onTap: () => _showPageSettings(context, vm),
              ),
              // Add Page Button
              _buildModeButton(
                context,
                icon: Icons.add,
                label: 'Add Page',
                isActive: false,
                onTap: () => vm.addNewPage(),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildModeButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return Consumer<LayoutProviderVm>(
      builder: (_, layoutVm, _) {
        bool isMobile = layoutVm.deviceType == DeviceType.mobile;
        return InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color:
                  isActive
                      ? Theme.of(context).primaryColor.withOpacity(0.1)
                      : null,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              spacing: 4,
              children: [
                Icon(
                  icon,
                  color:
                      isActive ? Theme.of(context).primaryColor : Colors.grey,
                ),
                if (isActive || isMobile)
                  Text(
                    label,
                    style: TextStyle(
                      color:
                          isActive
                              ? Theme.of(context).primaryColor
                              : Colors.grey,
                      fontWeight:
                          isActive ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
              ],
            ),
          ),
        );
      },
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
        AppButton(
          onTap: () {
            vm.save();
          },
          text: 'Save',
          mainAxisSize: MainAxisSize.min,
        ),
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
          formatTime(pomodorVm.elapsedSeconds),
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

  void _showPageSettings(BuildContext context, NoteCreationVm vm) {
    if (vm.currentPage == null) return;

    showDialog(
      context: context,
      builder: (context) => PageSettingsDialog(
        currentFormat: vm.currentPage!.format,
        onFormatChanged: (newFormat) {
          vm.updateCurrentPageFormat(newFormat);
        },
        currentTemplate: vm.template,
        onTemplateChanged: (newTemplate) {
          vm.updateTemplate(newTemplate);
        },
      ),
    );
  }
}
