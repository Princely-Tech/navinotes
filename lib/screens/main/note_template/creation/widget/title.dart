import 'package:navinotes/packages.dart';
import 'package:navinotes/screens/main/note_template/creation/vm.dart';

Widget title() {
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
