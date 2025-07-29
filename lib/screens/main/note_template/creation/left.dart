import 'package:navinotes/packages.dart';
import 'vm.dart';

class NoteCreationLeft extends StatelessWidget {
  const NoteCreationLeft({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(right: BorderSide(color: AppTheme.lightGray)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ScrollableController(
              mobilePadding: EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 25,
                children: [
                  _logo(),
                  Column(children: [_searchField(), _createNoteButton()]),
                  _noteBooks(),
                  _studyTool(),
                  _tags(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tags() {
     //TODO ask about this
    return _section(
      title: 'Tags',
      children: [
        _listTile(
          icon: _tileIcon(icon: Images.tag, color: AppTheme.coralRed),
          title: 'Important',
        ),
        _listTile(
          icon: _tileIcon(icon: Images.tag, color: AppTheme.vividBlue),
          title: 'Exam',
        ),
        _listTile(
          icon: _tileIcon(icon: Images.tag, color: AppTheme.emerald),
          title: 'Research',
        ),
      ],
    );
  }

  Widget _studyTool() {
    return _section(
      title: 'STUDY TOOLS',
      children: [
        _listTile(
          icon: _tileIcon(icon: Images.clock, color: AppTheme.orange),
          title: 'Pomodoro Timer',
          route: Routes.pomodoroTimer,
        ),
        _listTile(
          icon: _tileIcon(icon: Images.stack, color: AppTheme.teal),
          title: 'Flashcards',
          route: Routes.flashCards,
        ),
        //TODO ask about this
        _listTile(
          icon: _tileIcon(icon: Images.chart3, color: Color(0xFF2D3748)),
          title: 'Study Analytics',
        ),
      ],
    );
  }

  Widget _noteBooks() {
    String title = 'NOTEBOOKS';
    return Consumer<NoteCreationVm>(
      builder: (_, vm, _) {
        return FutureBuilder<List<Board>>(
          future: DatabaseHelper.instance.getAllBoards(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return _section(
                title: title,
                children: [Center(child: CircularProgressIndicator())],
              );
            }
            List<Board> boards = snapshot.data ?? [];
            List<Color> iconColors = [
              AppTheme.vividRose,
              AppTheme.vividBlue,
              AppTheme.emerald,
              AppTheme.mediumOrchid,
            ];
            return _section(
              title: title,
              children:
                  boards.map((board) {
                    return FutureBuilder(
                      future: DatabaseHelper.instance.getAllContents(board.id!),
                      builder: (_, snapshot) {
                        bool loading = false;
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          loading = true;
                        }
                        if (snapshot.hasError) {
                          loading = false;
                        }

                        List<Content>? contents = snapshot.data;
                        int? count;
                        if (isNotNull(contents)) {
                          count = contents!.length;
                        }
                        return LoadingIndicator(
                          loading: loading,
                          child: _listTile(
                            icon: _tileIcon(
                              icon: Images.book,
                              color: getRandomListElement(iconColors),
                            ),
                            title: board.name,
                            count: count,
                            isActive: vm.content?.boardId == board.id,
                          ),
                        );
                      },
                    );
                  }).toList(),
            );
          },
        );
      },
    );
  }

  Widget _tileIcon({required String icon, required Color color}) {
    return SVGImagePlaceHolder(imagePath: icon, color: color, size: 16);
  }

  Widget _listTile({
    required String title,
    bool isActive = false,
    required Widget icon,
    int? count,
    String? route,
  }) {
    return Consumer<NoteCreationVm>(
      builder: (_, vm, _) {
        return Material(
          color: Colors.transparent,
          child: ListTile(
            leading: icon,
            selected: isActive,
            selectedTileColor: AppTheme.lightAsh,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            trailing:
                isNotNull(count)
                    ? Text(
                      count.toString(),
                      style: TextStyle(
                        color: const Color(0xFF6B7280),
                        fontSize: 12.0,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                      ),
                    )
                    : null,
            title: Text(
              title,
              style: TextStyle(
                color: const Color(0xFF374151),
                fontSize: 16.0,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
              ),
            ),
            onTap: () {
              if (isNotNull(route)) {
                vm.goToRoute(route!);
              }
            },
          ),
        );
      }
    );
  }

  Widget _section({required String title, required List<Widget> children}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10,
      children: [
        Text(
          title,
          style: TextStyle(
            color: const Color(0xFF6B7280),
            fontSize: 12.0,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w600,
            height: 1.33,
            letterSpacing: 0.60,
          ),
        ),
        Column(children: children),
      ],
    );
  }

  Widget _createNoteButton() {
    return Consumer<NoteCreationVm>(
      builder: (_, vm, _) {
        return VisibleController(
          mobile: isNotNull(vm.content),
          child: Padding(
            padding: const EdgeInsets.only(top: 25),
            child: AppButton(
              loading: vm.isCreatingNote,
              onTap: vm.createNote,
              text: 'New Note',
              prefix: Icon(Icons.add, color: AppTheme.white),
            ),
          ),
        );
      },
    );
  }

  CustomInputField _searchFieldInput() {
    return CustomInputField(
      suffixIcon: Icon(Icons.search, color: Color(0xFFADAEBC), size: 20),
      hintText: 'Search notes',
      hintStyle: TextStyle(
        color: const Color(0xFFADAEBC),
        fontSize: 14.0,
        fontFamily: 'Inter',
        fontWeight: FontWeight.w400,
        height: 1.43,
      ),
    );
  }

  Widget _searchField() {
    return Consumer<NoteCreationVm>(
      builder: (context, vm, _) {
        return FutureBuilder<List<Content>>(
          future: vm.getAllContent(),
          builder: (_, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return LoadingIndicator(
                loading: true,
                child: _searchFieldInput(),
              );
            } else if (snapshot.hasError) {
              return Text(
                'Failed to load notes',
                style: AppTheme.text.copyWith(color: AppTheme.coralRed),
              );
            }
            List<Content> notes = snapshot.data ?? [];
            return SearchDropdownField<Content>(
              suggestionsCallback: (search) {
                return notes
                    .where((item) => checkStringMatch(item.title, search))
                    .toList();
              },
              itemBuilder: (_, item) {
                return CustomListTile(
                  onTap:
                      () => goToNotePageWithContent(
                        content: item,
                        context: context,
                      ),
                  title: item.title,
                  color: AppTheme.steelMist,
                  activeColor: AppTheme.strongBlue,
                );
              },
              input: _searchFieldInput(),
            );
          },
        );
      },
    );
  }

  Widget _logo() {
    return Row(
      spacing: 10,
      children: [
        SVGImagePlaceHolder(imagePath: Images.logo, size: 29),
        Expanded(
          child: Text(
            'NaviNotes',
            style: TextStyle(
              color: const Color(0xFF00555A),
              fontSize: 20,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
              height: 1,
            ),
          ),
        ),
      ],
    );
  }
}
