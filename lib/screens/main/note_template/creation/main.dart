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
                  SquaredNoteBackground(),
                  LinedNoteBackground(),
                  DottedNoteBackground(),

                  Container(
                    height: double.infinity,
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
          ],
        );
      },
    );
  }

  Widget _header() {
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
