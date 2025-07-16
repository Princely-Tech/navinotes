import 'package:navinotes/packages.dart';
import 'package:navinotes/screens/main/note_template/creation/lined_rule.dart';
import 'vm.dart';

class NoteCreationMain extends StatelessWidget {
  const NoteCreationMain({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<NoteCreationVm>(
      builder: (_, vm, _) {
        Color color = AppTheme.transparent;
        switch (vm.template.image) {
          case Images.noteTemplateCornell:
            color = Color(0xFFD1CDC4);
        }
        return Column(
          children: [
            _header(),
            QuillSimpleToolbar(
              controller: vm.richEditorController,
              config: const QuillSimpleToolbarConfig(),
            ),
            Expanded(
              child: Stack(
                children: [
                  LinedNoteBackground(),
                  Container(
                    height: double.infinity,
                    color: color,
                    padding: const EdgeInsets.symmetric(
                      vertical: 15,
                    ),
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
          ],
        );
      },
    );
  }

  Widget _header() {
    return Consumer<NoteCreationVm>(
      builder: (_, vm, _) {
        return Consumer<LayoutProviderVm>(
          builder: (_, layoutVm, _) {
            return Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: AppTheme.lightGray)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                spacing: 10,
                children: [
                  _title(),
                  _timer(),
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

  Widget _timer() {
    return Row(
      spacing: 5,
      children: [
        SVGImagePlaceHolder(
          imagePath: Images.clock,
          size: 16,
          color: AppTheme.stormGray,
        ),
        Text(
          '25:00',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: const Color(0xFF4B5563),
            fontSize: 14,
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
                child: AppButton.text(
                  onTap: NavigationHelper.pop,
                  prefix: Icon(
                    Icons.arrow_back,
                    color: const Color(0xFF4B5563),
                  ),
                  child: Flexible(
                    child: Text.rich(
                      overflow: TextOverflow.ellipsis,
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'Cell Structure & Function',
                            style: TextStyle(
                              color: const Color(0xFF4B5563),
                              fontSize: 14,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w500,
                              height: 1.43,
                            ),
                          ),
                          TextSpan(
                            text: ' • ',
                            style: TextStyle(
                              color: const Color(0xFF9CA3AF),
                              fontSize: 14,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                              height: 1.43,
                            ),
                          ),
                          TextSpan(
                            text: 'Biology 101',
                            style: TextStyle(
                              color: const Color(0xFF4B5563),
                              fontSize: 14,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                              height: 1.43,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
