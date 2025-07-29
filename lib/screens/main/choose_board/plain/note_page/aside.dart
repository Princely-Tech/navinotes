import 'shared.dart';
import 'package:navinotes/packages.dart';

class BoardPlainNotePageAside extends StatelessWidget {
  const BoardPlainNotePageAside({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LayoutProviderVm>(
      builder: (_, layoutVm, _) {
        return Consumer<BoardNotePageVm>(
          builder: (_, vm, _) {
            return Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppTheme.white,
                border: Border(
                  left: BorderSide(width: 2, color: AppTheme.lightGray),
                ),
              ),
              child: Column(
                children: [
                  Expanded(
                    child: ScrollableController(
                      mobilePadding: EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          VisibleController(
                            mobile: getMenuVisible(layoutVm.deviceType),
                            child: Column(
                              children: [_actionRow(vm.board), _divider()],
                            ),
                          ),
                          _boardDetails(),
                          _divider(),
                          _tags(),
                          _divider(),
                          _recentlyViewed(),
                        ],
                      ),
                    ),
                  ),
                  Padding(padding: EdgeInsets.all(20), child: _footer()),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _actionRow(Board board) {
    return Row(
      spacing: 10,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [NewNotesButton(isAside: true), NotesAppBarActions()],
    );
  }

  Widget _footer() {
    return Column(
      spacing: 10,
      children: [
        AppButton(
          onTap: () => NavigationHelper.push(Routes.boardPlainMindMap),
          text: 'View Mind Map',
          minHeight: 40,
          prefix: SVGImagePlaceHolder(
            imagePath: Images.logo,
            size: 16,
            color: AppTheme.white,
          ),
        ),
        Text(
          'See how your notes are connected',
          textAlign: TextAlign.center,
          style: AppTheme.text.copyWith(
            color: AppTheme.steelMist,
            fontSize: 12.0,
          ),
        ),
      ],
    );
  }

  Widget _recentItem({required String title, required String lastEdited}) {
    return Row(
      spacing: 15,
      children: [
        OutlinedChild(
          size: 32,
          decoration: BoxDecoration(color: AppTheme.paleBlue),
          child: SVGImagePlaceHolder(imagePath: Images.file, size: 16),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 4,
            children: [
              Text(title, style: AppTheme.text),
              Text(
                lastEdited,
                style: AppTheme.text.copyWith(
                  color: AppTheme.steelMist,
                  fontSize: 12.0,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _recentlyViewed() {
    return Consumer<BoardNotePageVm>(
      builder: (_, vm, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 15,
          children: [
            Text('Recently Viewed', style: AppTheme.text),
            FutureBuilder(
              future: vm.getRecentContents(3),
              builder: (_, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text(
                    'Failed to load recent notes',
                    style: AppTheme.text.copyWith(color: AppTheme.coralRed),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Text('No recent notes found', style: AppTheme.text);
                }
                final recentNotes = snapshot.data!;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 15,
                  children: [
                    for (final note in recentNotes)
                      _recentItem(
                        title: note.title,
                        lastEdited: formatRelativeTime(note.updatedAt),
                      ),
                  ],
                );
              },
            ),
          ],
        );
      },
    );
  }

  Widget _tags() {
    //TODO return to this
    return Column(
      spacing: 15,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          spacing: 20,
          children: [
            Flexible(child: Text('Tags', style: AppTheme.text)),
            AppButton.text(
              onTap: () {},
              text: 'Edit',
              color: AppTheme.strongBlue,
            ),
          ],
        ),
        Wrap(
          runSpacing: 15,
          spacing: 10,
          children: [
            CustomTag(
              'Physics',
              color: AppTheme.paleBlue,
              textColor: AppTheme.electricIndigo,
            ),
            CustomTag(
              'Science',
              color: AppTheme.lightMintGreen,
              textColor: AppTheme.emeraldGreen,
            ),
            CustomTag(
              'Study',
              color: AppTheme.purple,
              textColor: AppTheme.royalViolet,
            ),
            CustomTag(
              'Exam Prep',
              color: AppTheme.yellow,
              textColor: AppTheme.burntSienna,
            ),
          ],
        ),
      ],
    );
  }

  Widget _divider() {
    return Divider(color: AppTheme.lightGray, height: 40);
  }

  Widget _detailItem({
    required String title,
    required String value,
    required String icon,
  }) {
    return Row(
      spacing: 8,
      children: [
        SVGImagePlaceHolder(imagePath: icon, size: 14),
        Expanded(
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: '$title:  ',
                  style: AppTheme.text.copyWith(color: AppTheme.steelMist),
                ),
                TextSpan(
                  text: value,
                  style: AppTheme.text.copyWith(color: AppTheme.darkSlateGray),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _boardDetails() {
    return Consumer<SessionManager>(
      builder: (_, sessionVm, _) {
        return Consumer<BoardNotePageVm>(
          builder: (_, vm, _) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 15,
              children: [
                Text(
                  'Board Details',
                  style: AppTheme.text.copyWith(fontSize: 18.0),
                ),
                _detailItem(
                  title: 'Created',
                  value: formatUnixTimestamp(vm.board.createdAt),
                  icon: Images.calender,
                ),
                _detailItem(
                  title: 'Pages',
                  value: '${vm.contents.length} note pages',
                  icon: Images.file,
                ),
                _detailItem(
                  title: 'Owner',
                  value: sessionVm.getName() ?? '',
                  icon: Images.person,
                ),
              ],
            );
          },
        );
      },
    );
  }
}
