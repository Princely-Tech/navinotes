import 'package:navinotes/packages.dart';

class NatureNotePageAside extends StatelessWidget {
  const NatureNotePageAside({super.key});
  // final bool isFull;
  @override
  Widget build(BuildContext context) {
    return Consumer<BoardNotePageVm>(
      builder: (_, vm, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ExpandableController(
              child: ScrollableController(
                mobilePadding: EdgeInsets.all(10),
                desktopPadding: EdgeInsets.fromLTRB(10, 30, 10, 20),
                child: Column(
                  spacing: 30,
                  children: [
                    _boardDetails(),
                    _recentlyViewed(),
                    // _mindMaps(),
                    Column(
                      children: [
                        VisibleController(
                          mobile: true,
                          desktop: true,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 15),
                            child: Column(
                              children: [
                                AppButton(
                                  onTap: vm.gotToCreateNotePage,
                                  text: 'New Note Page',
                                  minHeight: 40,
                                  color: AppTheme.deepMoss,
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
                                    fontFamily: AppTheme.fontCrimsonPro,
                                  ),
                                ),
                                ListTile(
                                  leading: const Icon(Icons.book_outlined),
                                  title: const Text('New Notebook'),
                                  onTap: () {
                                    NavigationHelper.createAndNavigateToNewNotebook(vm.board);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        AppButton(
                          onTap:
                              () =>
                                  NavigationHelper.createAndNavigateToNewMindMap(
                                    vm.board,
                                  ),
                          color: AppTheme.burntLeather.withAlpha(0xFF),
                          child: Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(5),
                              child: Row(
                                spacing: 15,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Flexible(
                                    child: Column(
                                      spacing: 5,
                                      children: [
                                        Text(
                                          'Create Mind Map',
                                          textAlign: TextAlign.center,
                                          style: AppTheme.text.copyWith(
                                            color: AppTheme.linen,
                                            fontSize: 16.0,
                                            fontFamily:
                                                AppTheme.fontLibreBaskerville,
                                          ),
                                        ),
                                        Text(
                                          'See connections between notes',
                                          textAlign: TextAlign.center,
                                          style: AppTheme.text.copyWith(
                                            color: AppTheme.linen,
                                            fontSize: 12.0,
                                            fontFamily:
                                                AppTheme.fontCrimsonText,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  OutlinedChild(
                                    size: 40,
                                    decoration: BoxDecoration(
                                      color: AppTheme.linen.withAlpha(0x33),
                                      shape: BoxShape.circle,
                                    ),
                                    child: SVGImagePlaceHolder(
                                      imagePath: Images.share,
                                      color: AppTheme.white,
                                      size: 18,
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

  Widget _viewedItem({required Content content}) {
    String iconImg = getRandomListElement([Images.boardNatureWaveLine]);
    Color iconColor = AppTheme.deepMoss.withAlpha(0x33);
    switch (iconImg) {
      case Images.boardNatureQuantumIcon:
        iconColor = AppTheme.deepPeach.withAlpha(0x33);
        break;
      case Images.boardNatureThermometer:
        iconColor = AppTheme.sageMist.withAlpha(0x33);
        break;
    }
    return Row(
      spacing: 10,
      children: [
        OutlinedChild(
          size: 32,
          decoration: BoxDecoration(
            color: iconColor,
            borderRadius: BorderRadius.circular(6),
          ),
          child: SVGImagePlaceHolder(imagePath: iconImg, size: 14),
        ),

        Expanded(
          child: InkWell(
            onTap: () {
              NavigationHelper.navigateToContent(content);
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  content.title,
                  style: AppTheme.text.copyWith(
                    color: AppTheme.darkMossGreen,
                    fontFamily: AppTheme.fontCrimsonText,
                  ),
                ),
                Text(
                  formatRelativeTime(content.updatedAt),
                  style: AppTheme.text.copyWith(
                    color: AppTheme.coffee,
                    fontSize: 12.0,
                    fontFamily: AppTheme.fontCrimsonText,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _recentlyViewed() {
    return Consumer<BoardNotePageVm>(
      builder: (_, vm, _) {
        return EditHeaderSection(
          theme: BoardTheme.nature,
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
                  for (final note in recentNotes) _viewedItem(content: note),
                ],
              );
            },
          ),
        );
      },
    );
  }
  
  Widget _detailsItem({required String title, required String value}) {
    return Row(
      spacing: 15,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: AppTheme.text.copyWith(
            color: AppTheme.coffee,
            fontSize: 14.0,
            fontFamily: AppTheme.fontCrimsonText,
            height: 1.43,
          ),
        ),
        Flexible(
          child: Text(
            textAlign: TextAlign.right,
            value,
            style: AppTheme.text.copyWith(
              color: AppTheme.darkMossGreen,
              fontSize: 14.0,
              fontFamily: AppTheme.fontCrimsonText,
              height: 1.43,
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
            return EditHeaderSection(
              theme: BoardTheme.nature,
              title: 'Board Details',
              child: Column(
                spacing: 15,
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