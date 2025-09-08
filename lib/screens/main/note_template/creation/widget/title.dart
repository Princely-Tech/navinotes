import 'package:navinotes/packages.dart';
import 'package:navinotes/screens/main/note_template/creation/vm.dart';

void _showTitleEditDialog(NoteCreationVm vm) {
  final BuildContext? context = NavigationHelper.navigatorKey.currentContext;
  if (context == null) return;

  final TextEditingController dialogController = TextEditingController(
    text: vm.content?.title ?? 'Untitled Note',
  );

  showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        title: Text(
          'Edit Title',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF374151),
          ),
        ),
        content: CustomInputField(
          controller: dialogController,
          hintText: 'Enter note title',
          style: TextStyle(
            fontSize: 16,
            color: const Color(0xFF374151),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: const Color(0xFF6B7280),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              final newTitle = dialogController.text.trim();
              if (newTitle.isNotEmpty) {
                vm.updateTitle(newTitle);
              }
              Navigator.of(dialogContext).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.strongBlue,
              foregroundColor: Colors.white,
            ),
            child: Text('Save'),
          ),
        ],
      );
    },
  );
}

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
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Flexible(
                                child: GestureDetector(
                                  onTap: () => _showTitleEditDialog(vm),
                                  child: Text(
                                    vm.content?.title ?? 'Untitled Note',
                                    style: TextStyle(
                                      color: const Color(0xFF4B5563),
                                      fontSize: 14.0,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w500,
                                      height: 1.43,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                              SizedBox(width: 8),
                              GestureDetector(
                                onTap: () => _showTitleEditDialog(vm),
                                child: Icon(
                                  Icons.edit,
                                  size: 16,
                                  color: const Color(0xFF6B7280),
                                ),
                              ),
                            ],
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
