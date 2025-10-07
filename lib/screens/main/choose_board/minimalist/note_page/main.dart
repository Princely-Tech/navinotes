import 'package:navinotes/packages.dart';

class MinimalistNotePageMain extends StatelessWidget {
  const MinimalistNotePageMain({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<BoardNotePageVm>(
      builder: (_, vm, _) {
        return ResponsivePadding(
          mobile: EdgeInsets.only(top: 5),
          desktop: EdgeInsets.only(top: 20),
          child: Column(
            children: [
              BoardPageMainHeader(theme: BoardTheme.minimalist),
              Expanded(
                child: ScrollableController(
                  mobilePadding: EdgeInsets.only(bottom: 30),
                  child:
                      vm.pageDisplayFormat == PageDisplayFormat.grid
                          ? CustomGrid(
                            children: [
                              ...vm.contents.map(
                                (content) => _noteCard(content: content),
                              ),
                              _createNewCard(),
                            ],
                          )
                          : Column(
                            children: [
                              ...vm.contents.map(
                                (content) => _noteListItem(content: content),
                              ),
                              _createNewCard(),
                            ],
                          ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _createNewCard() {
    return Consumer<BoardNotePageVm>(
      builder: (_, vm, _) {
        return Column(
          children: [
            InkWell(
              onTap: vm.gotToCreateNotePage,
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: 200),
                child: CustomCard(
                  addBorder: true,
                  addCardShadow: true,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 15,
                    children: [
                      OutlinedChild(
                        size: 48,
                        decoration: BoxDecoration(
                          color: AppTheme.steelBlue.withAlpha(0x19),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.add,
                          color: AppTheme.steelBlue,
                          size: 20,
                        ),
                      ),
                      Text(
                        'Create New Note Page',
                        style: AppTheme.text.copyWith(color: AppTheme.asbestos),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _noteCard({required Content content}) {
    IconData contentIcon;
    switch (content.type) {
      case AppContentType.mindmapNode:
        contentIcon = Icons.account_tree;
        break;
      case AppContentType.file:
        contentIcon = Icons.insert_drive_file;
        break;
      default:
        contentIcon = Icons.note;
    }

    return Consumer<BoardNotePageVm>(
      builder: (_, vm, _) {
        return InkWell(
          onTap: () => NavigationHelper.navigateToContent(content),
          child: CustomCard(
            addCardShadow: true,
            addBorder: true,
            padding: EdgeInsets.zero,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: AppTheme.lightGray.withAlpha(0x33),
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(8),
                    ),
                  ),
                  child: AspectRatio(
                    aspectRatio: 5 / 2,
                    child: Center(
                      child: Icon(
                        contentIcon,
                        size: 48,
                        color: AppTheme.asbestos,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    spacing: 5,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        content.title,
                        style: AppTheme.text.copyWith(
                          color: AppTheme.wetAsphalt,
                          fontSize: 16.0,
                          fontWeight: getFontWeight(500),
                          height: 1.50,
                        ),
                      ),
                      Text(
                        'Last edited: ${formatUnixTimestamp(content.updatedAt)}',
                        style: AppTheme.text.copyWith(
                          color: AppTheme.asbestos,
                          fontSize: 12.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _noteListItem({required Content content}) {
    IconData contentIcon;
    switch (content.type) {
      case AppContentType.mindmapNode:
        contentIcon = Icons.account_tree;
        break;
      case AppContentType.file:
        contentIcon = Icons.insert_drive_file;
        break;
      default:
        contentIcon = Icons.note;
    }

    return Consumer<BoardNotePageVm>(
      builder: (_, vm, _) {
        return InkWell(
          onTap: () => NavigationHelper.navigateToContent(content),
          child: Container(
            margin: EdgeInsets.only(bottom: 10),
            child: CustomCard(
              addBorder: true,
              addCardShadow: true,
              padding: EdgeInsets.all(15),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppTheme.lightGray.withAlpha(0x33),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      contentIcon,
                      size: 24,
                      color: AppTheme.asbestos,
                    ),
                  ),
                  SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          content.title,
                          style: AppTheme.text.copyWith(
                            color: AppTheme.wetAsphalt,
                            fontSize: 16.0,
                            fontWeight: getFontWeight(500),
                            height: 1.50,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Last edited: ${formatUnixTimestamp(content.updatedAt)}',
                          style: AppTheme.text.copyWith(
                            color: AppTheme.asbestos,
                            fontSize: 12.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
