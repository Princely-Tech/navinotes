import 'package:navinotes/packages.dart';
import 'package:navinotes/screens/main/note_template/read/widget/multi_page_viewer.dart';
import 'vm.dart';

class NoteReadMain extends StatelessWidget {
  const NoteReadMain({super.key});

  @override
  Widget build(BuildContext context) {
    final inputWidth = MediaQuery.of(context).size.width;
    final inputHeight = MediaQuery.of(context).size.height * 3;

    return Consumer<NoteReadVm>(
      builder: (_, vm, _) {
        Color color = AppTheme.transparent;
        switch (vm.template.image) {
          case Images.noteTemplateCornell:
            color = const Color(0xFFD1CDC4);
        }
        return Column(
          children: [
            _modeSelector(vm, context),

            Expanded(
              child: Container(
                color: AppTheme.lightAsh,
                child: MultiPageViewer(
                  vm: vm,
                  backgroundColor: color,
                  inputWidth: inputWidth,
                  inputHeight: inputHeight,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // Build the mode selector (Text, Drawing, Voice)
  Widget _modeSelector(NoteReadVm vm, BuildContext context) {
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
              _buildVoiceModeButton(context, vm),
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

  Widget _buildVoiceModeButton(BuildContext context, NoteReadVm vm) {
    return Consumer<LayoutProviderVm>(
      builder: (_, layoutVm, _) {
        bool isMobile = layoutVm.deviceType == DeviceType.mobile;
        bool isActive = vm.currentMode == NoteMode.voice;

        return InkWell(
          onTap: () => vm.setMode(NoteMode.voice),
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
                  Icons.mic,
                  color:
                      isActive ? Theme.of(context).primaryColor : Colors.grey,
                ),
                if ((isActive || isMobile))
                  Text(
                    'Voice',
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
}
