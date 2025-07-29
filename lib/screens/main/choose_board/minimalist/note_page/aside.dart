import 'package:navinotes/packages.dart';

class MinimalistNotePageAside extends StatelessWidget {
  const MinimalistNotePageAside({super.key});
  @override
  Widget build(BuildContext context) {
    return Consumer<BoardNotePageVm>(
      builder: (_, vm, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ExpandableController(
              child: ScrollableController(
                mobilePadding: EdgeInsets.all(20),
                child: Column(
                  spacing: 30,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _boardDetails(),
                    _tags(),
                    _recentlyViewed(),
                    Column(
                      children: [
                        VisibleController(
                          mobile: true,
                          desktop: false,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 15),
                            child: AppButton(
                              onTap: vm.gotToCreateNotePage,
                              text: 'New Note Page',
                              minHeight: 40,
                              color: AppTheme.steelBlue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                              prefix: Icon(
                                Icons.add,
                                color: AppTheme.white,
                                size: 20,
                              ),
                              style: AppTheme.text.copyWith(
                                color: AppTheme.white,
                                fontSize: 16.0,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ),
                        ),
                        AppButton(
                          onTap:
                              () => NavigationHelper.push(
                                Routes.boardMinimalistMindMap,
                              ),
                          color: AppTheme.steelBlue.withAlpha(0x19),
                          child: Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(5),
                              child: Row(
                                spacing: 15,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SVGImagePlaceHolder(
                                    imagePath: Images.share,
                                    color: AppTheme.steelBlue,
                                    size: 18,
                                  ),
                                  Flexible(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'View Mind Map',
                                          textAlign: TextAlign.center,
                                          style: AppTheme.text.copyWith(
                                            color: AppTheme.steelBlue,
                                            fontWeight: getFontWeight(500),
                                          ),
                                        ),
                                        Text(
                                          'See connections',
                                          textAlign: TextAlign.center,
                                          style: AppTheme.text.copyWith(
                                            color: AppTheme.steelBlue,
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
                        ),
                      ],
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

  Widget _viewedItem({required String title, required String time}) {
    return Row(
      spacing: 10,
      children: [
        OutlinedChild(
          size: 32,
          decoration: BoxDecoration(
            color: AppTheme.steelBlue.withAlpha(0x19),
            borderRadius: BorderRadius.circular(6),
          ),
          child: SVGImagePlaceHolder(
            imagePath: Images.file2,
            size: 16,
            color: AppTheme.steelBlue,
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTheme.text.copyWith(
                  color: AppTheme.wetAsphalt,
                  fontSize: 12.0,
                  fontWeight: getFontWeight(500),
                ),
              ),
              Text(
                time,
                style: AppTheme.text.copyWith(
                  color: AppTheme.asbestos,
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
        return _section(
          title: 'Recently Viewed',
          child: FutureBuilder(
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
                    _viewedItem(
                      title: note.title,
                      time: formatRelativeTime(note.updatedAt),
                    ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  Widget _tagItem({
    required String text,
    required Color color,
    required Color textColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(6),
      ),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Text(
        text,
        style: AppTheme.text.copyWith(fontSize: 12.0, color: textColor),
      ),
    );
  }

  Widget _tags() {
    //TODO Return to this
    return _section(
      title: 'Tags',
      child: Wrap(
        runSpacing: 10,
        spacing: 10,
        children: [
          _tagItem(
            color: AppTheme.steelBlue.withAlpha(0x19),
            textColor: AppTheme.steelBlue,
            text: 'Physics',
          ),
          _tagItem(
            color: AppTheme.mintWhisper,
            textColor: AppTheme.vitalGreen,
            text: 'Science',
          ),
          _tagItem(
            color: AppTheme.lavenderBlush,
            textColor: AppTheme.electricViolet,
            text: 'Study',
          ),
          _tagItem(
            color: AppTheme.papayaWhip,
            textColor: AppTheme.burntOrange,
            text: 'Exam Prep',
          ),
        ],
      ),
    );
  }

  Widget _detailsItem({required String title, required String value}) {
    return Row(
      spacing: 10,
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 50),
          child: Text(
            '$title:',
            style: AppTheme.text.copyWith(
              color: AppTheme.asbestos,
              fontSize: 12.0,
              height: 1.33,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: AppTheme.text.copyWith(
              color: AppTheme.wetAsphalt,
              fontSize: 12.0,
              height: 1.33,
            ),
          ),
        ),
      ],
    );
  }

  Widget _section({required String title, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10,
      children: [
        Text(
          title,
          style: AppTheme.text.copyWith(
            color: AppTheme.wetAsphalt,
            fontWeight: getFontWeight(500),
            height: 1.43,
          ),
        ),
        child,
      ],
    );
  }

  Widget _boardDetails() {
    return Consumer<SessionManager>(
      builder: (_, sessionVm, _) {
        return Consumer<BoardNotePageVm>(
          builder: (_, vm, _) {
            return _section(
              title: 'Board Details',
              child: Column(
                spacing: 10,
                children: [
                  _detailsItem(
                    title: 'Created',
                    value: formatUnixTimestamp(vm.board.createdAt),
                  ),
                  _detailsItem(
                    title: 'Pages',
                    value: vm.contents.length.toString(),
                  ),
                  _detailsItem(
                    title: 'Owner',
                    value: sessionVm.getName() ?? '',
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
