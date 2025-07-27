import 'package:navinotes/packages.dart';

class SearchOneItem {
  final String title;
  final IconData icon;
  final Future<dynamic> Function() onTap;
  SearchOneItem({required this.title, required this.icon, required this.onTap});
}

class SearchBarOne extends StatefulWidget {
  const SearchBarOne({super.key});

  @override
  State<SearchBarOne> createState() => _SearchBarOneState();
}

class _SearchBarOneState extends State<SearchBarOne> {
  List<SearchOneItem> items = [];

  void _initItems() async {
    final dbHelper = DatabaseHelper.instance;
    try {
      final boards = await dbHelper.getAllBoards();
      setState(() {
        items = boards.map(boardToItem).toList();
      });
      for (var board in boards) {
        final contents = await dbHelper.getAllContents(board.id!);
        setState(() {
          items.addAll(contents.map(contentToItem).toList());
        });
      }
    } catch (e) {
      debugPrint('Error getting searchItems $e');
    }
  }

  SearchOneItem contentToItem(Content content) {
    final bool isFile = content.type == AppContentType.file;
    final IconData icon = isFile ? getFileIcon(content.file) : Icons.note_alt;

    return SearchOneItem(
      title: content.title,
      icon: icon,
      onTap: () async {
        await (isFile
            ? handleOpenFile(content, context)
            : goToNotePageWithContent(content: content, context: context));
        _initItems();
      },
    );
  }

  SearchOneItem boardToItem(Board board) {
    return SearchOneItem(
      title: board.name,
      icon: Icons.folder_open,
      onTap: () async {
        await NavigationHelper.navigateToBoard(board);
        _initItems();
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _initItems();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Align(
        alignment: Alignment.centerLeft,
        child: WidthLimiter(
          mobile: 512,
          child: SearchDropdownField<SearchOneItem>(
            suggestionsCallback: (search) {
              return items
                  .where((item) => checkStringMatch(item.title, search))
                  .toList();
            },
            itemBuilder: (_, item) {
              return CustomListTile(
                onTap: item.onTap,
                leading: Icon(item.icon, color: AppTheme.vividRose),
                title: item.title,
                color: AppTheme.steelMist,
                activeColor: AppTheme.strongBlue,
              );
            },
            input: CustomInputField(
              prefixIcon: Icon(
                Icons.search,
                color: AppTheme.slateGray,
                size: 20,
              ),
              hintText: 'Search your notes, boards, and more...',
              hintStyle: AppTheme.text.copyWith(
                color: AppTheme.slateGray,
                fontSize: 16.0,
                height: 1.50,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
