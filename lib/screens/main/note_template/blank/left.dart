import 'package:navinotes/packages.dart';

class BlankNoteLeft extends StatelessWidget {
  const BlankNoteLeft({super.key});

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
                  _searchField(),
                  createNote(),
                  _noteBooks(),
                  _studyTool(),
                  _tags(),
                  //
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tags() {
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
        ),
        _listTile(
          icon: _tileIcon(icon: Images.stack, color: AppTheme.teal),
          title: 'Flashcards',
        ),
        _listTile(
          icon: _tileIcon(icon: Images.chart3, color: Color(0xFF2D3748)),
          title: 'Study Analytics',
        ),
      ],
    );
  }

  Widget _noteBooks() {
    return _section(
      title: 'NOTEBOOKS',
      children: [
        _listTile(
          icon: _tileIcon(icon: Images.book, color: AppTheme.vividRose),
          title: 'Biology 101',
          count: 12,
          isActive: true,
        ),
        _listTile(
          icon: _tileIcon(icon: Images.book, color: AppTheme.vividBlue),
          title: 'Psychology',
          count: 8,
        ),
        _listTile(
          icon: _tileIcon(icon: Images.book, color: AppTheme.emerald),
          title: 'Chemistry',
          count: 5,
        ),
        _listTile(
          icon: _tileIcon(icon: Images.book, color: AppTheme.mediumOrchid),
          title: 'Literature',
          count: 3,
        ),
      ],
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
  }) {
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
                    fontSize: 12,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                  ),
                )
                : null,
        title: Text(
          title,
          style: TextStyle(
            color: const Color(0xFF374151),
            fontSize: 16,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w400,
          ),
        ),
        onTap: () {},
      ),
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
            fontSize: 12,
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

  Widget createNote() {
    return AppButton(
      onTap: () {},
      text: 'New Cornell Note',
      prefix: Icon(Icons.add, color: AppTheme.white),
    );
  }

  Widget _searchField() {
    return CustomInputField(
      suffixIcon: Icon(Icons.search, color: Color(0xFFADAEBC), size: 20),
      hintText: 'Search notes',

      hintStyle: TextStyle(
        color: const Color(0xFFADAEBC),
        fontSize: 14,
        fontFamily: 'Inter',
        fontWeight: FontWeight.w400,
        height: 1.43,
      ),
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
