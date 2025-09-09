import 'shared.dart';
import 'package:navinotes/packages.dart';

class BoardPlainNotePageMain extends StatelessWidget {
  const BoardPlainNotePageMain({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<BoardNotePageVm>(
      builder: (_, vm, _) {
        return Column(
          children: [
            _header(vm),
            Expanded(
              child: vm.fetchingContent
                  ? Center(child: CircularProgressIndicator())
                  : ScrollableController(
                      mobilePadding: EdgeInsets.all(defaultHorizontalPadding),
                      child: vm.pageDisplayFormat == PageDisplayFormat.grid
                          ? CustomGrid(
                              children: [
                                ...vm.contents.map(
                                  (content) => _noteCard(content: content),
                                ),
                                CreateCard(
                                  width: double.infinity,
                                  onTap: () => vm.gotToCreateNotePage(),
                                  text: 'Create New Note Page',
                                ),
                              ],
                            )
                          : Column(
                              children: [
                                ...vm.contents.map(
                                  (content) => _noteListItem(content: content),
                                ),
                                CreateCard(
                                  width: double.infinity,
                                  onTap: () => vm.gotToCreateNotePage(),
                                  text: 'Create New Note Page',
                                ),
                              ],
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
      case AppContentType.mindmap:
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
        Radius radius = Radius.circular(12);
        return InkWell(
          onTap: () => NavigationHelper.navigateToContent(content),
          child: CustomCard(
            addBorder: true,
            addCardShadow: true,
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: AppTheme.iceBlue,
                    borderRadius: BorderRadius.only(
                      topLeft: radius,
                      topRight: radius,
                    ),
                  ),
                  padding: EdgeInsets.all(20),
                  child: AspectRatio(
                    aspectRatio: 5 / 2,
                    child: Center(
                      child: Icon(
                        contentIcon,
                        size: 48,
                        color: AppTheme.charcoalBlue,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    spacing: 15,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        content.title,
                        style: AppTheme.text.copyWith(
                          color: AppTheme.charcoalBlue,
                          fontSize: 16.0,
                        ),
                      ),
                      Row(
                        spacing: 15,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Text(
                              'Last edited: ${formatUnixTimestamp(content.updatedAt)}',
                              style: AppTheme.text.copyWith(
                                color: AppTheme.steelMist,
                                fontSize: 12.0,
                              ),
                            ),
                          ),
                        ],
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
      case AppContentType.mindmap:
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
              padding: EdgeInsets.all(20),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppTheme.iceBlue,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      contentIcon,
                      size: 24,
                      color: AppTheme.charcoalBlue,
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
                            color: AppTheme.charcoalBlue,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Last edited: ${formatUnixTimestamp(content.updatedAt)}',
                          style: AppTheme.text.copyWith(
                            color: AppTheme.steelMist,
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

  Widget _header(BoardNotePageVm vm) {
    return Container(
      constraints: BoxConstraints(minHeight: 60),
      decoration: ShapeDecoration(
        color: AppTheme.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 1, color: AppTheme.lightGray),
        ),
      ),
      padding: EdgeInsets.all(10),
      child: Row(
        spacing: 20,
        children: [
          Text(
            getNoteCountText(vm.contents),
            style: AppTheme.text.copyWith(fontSize: 16.0),
          ),
          VisibleController(
            mobile: false,
            tablet: true,
            child: Expanded(
              child: ResponsiveSection(
                mobile: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  spacing: 10,
                  children: [_sortBy()],
                ),
                desktop: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  spacing: 10,
                  children: [
                    DisplayFormatSelect(theme: BoardTheme.plain),
                    _sortBy(),
                    NewNotesButton(isAside: false),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sortBy() {
    return Consumer<BoardNotePageVm>( 
      builder: (_, vm, _) {
        return ValueListenableBuilder(
          valueListenable: vm.sortByController,
          builder: (_, value, _) {
            final sortByTxt = 'Sort by:';
            final sortByStyle = AppTheme.text.copyWith(
              color: AppTheme.darkSlateGray,
            );
            final style = AppTheme.text.copyWith(color: AppTheme.strongBlue);
            final textWidth = calculateTextWidth(value.text, style) + 45;
            final sortByTextWidth =
                calculateTextWidth(sortByTxt, sortByStyle) + 30;

            return WidthLimiter(
              mobile: sortByTextWidth + textWidth,
              child: CustomInputField(
                fillColor: AppTheme.lightAsh,
                side: BorderSide.none,
                controller: vm.sortByController,
                selectItems:
                    NoteSortType.values
                        .map((type) => noteSortTypeToString(type))
                        .toList(),
                style: style,
                prefixIcon: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      sortByTxt,
                      textAlign: TextAlign.center,
                      style: sortByStyle,
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
