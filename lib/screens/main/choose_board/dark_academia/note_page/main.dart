import 'package:navinotes/packages.dart';

class DarkAcademiaCreateNoteMain extends StatelessWidget {
  const DarkAcademiaCreateNoteMain({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<BoardNotePageVm>(
      builder: (_, vm, _) {
        return Column(
          children: [
            BoardPageMainHeader(theme: BoardTheme.darkAcademia),
            Expanded(
              child: ScrollableController(
                mobilePadding: EdgeInsets.symmetric(
                  vertical: defaultHorizontalPadding,
                ),
                child: CustomGrid(
                  children: [
                    ...vm.contents.map(
                      (content) => _noteCard(content: content),
                    ),
                    Column(
                      children: [
                        InkWell(
                          onTap: vm.gotToCreateNotePage,
                          child: ConstrainedBox(
                            constraints: BoxConstraints(minHeight: 288),
                            child: CustomCard(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: AppTheme.burntLeather.withAlpha(0x99),
                                border: Border.all(
                                  color: AppTheme.royalGold.withAlpha(0x4CD),
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                spacing: 15,
                                children: [
                                  CustomCard(
                                    width: 56,
                                    height: 56,
                                    decoration: BoxDecoration(
                                      color: AppTheme.royalGold.withAlpha(0x33),
                                      shape: BoxShape.circle,
                                    ),
                                    padding: EdgeInsets.zero,
                                    child: Icon(
                                      Icons.add,
                                      color: AppTheme.royalGold,
                                      size: 30,
                                    ),
                                  ),
                                  Text(
                                    'Create New Note Page',
                                    style: AppTheme.text.copyWith(
                                      color: AppTheme.royalGold,
                                      fontSize: 18.0,
                                      fontFamily: AppTheme.fontPlayfairDisplay,
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

  Widget _noteCard({required Content content}) {
    BoardNoteTemplate template = getNoteTemplateFromString(
      content.metaData[ContentMetadataKey.template],
    );
    Radius radius = Radius.circular(12);
    return Consumer<BoardNotePageVm>(
      builder: (_, vm, _) {
        return InkWell(
          onTap: () => vm.goToNotePage(content),
          child: CustomCard(
            padding: EdgeInsets.zero,
            decoration: BoxDecoration(
              color: AppTheme.burntLeather.withAlpha(204),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.royalGold.withAlpha(0x4CD),
                width: 1,
              ),
            ),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: AppTheme.royalGold.withAlpha(76),
                    borderRadius: BorderRadius.only(
                      topLeft: radius,
                      topRight: radius,
                    ),
                  ),
                  padding: EdgeInsets.all(20),
                  child: AspectRatio(
                    aspectRatio: 5 / 2,
                    child: ImagePlaceHolder(
                      imagePath: template.image,
                      isCardHeader: true,
                      borderRadius: BorderRadius.circular(0),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    spacing: 10,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        content.title,
                        style: AppTheme.text.copyWith(
                          color: AppTheme.royalGold,
                          fontSize: 18.0,
                          fontFamily: AppTheme.fontPlayfairDisplay,
                          height: 1.56,
                        ),
                      ),
                      //TODO check this
                      // Text(
                      //   body,
                      //   style: AppTheme.text.copyWith(
                      //     color: const Color(0xB2F5F5DC),
                      //     fontFamily: AppTheme.fontCrimsonPro,
                      //     height: 1.43,
                      //   ),
                      // ),
                      Row(
                        spacing: 15,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Text(
                              'Last edited: ${formatUnixTimestamp(content.updatedAt)}',
                              style: AppTheme.text.copyWith(
                                color: AppTheme.vanillaDust.withAlpha(0x99),
                                fontSize: 12.0,
                                fontStyle: FontStyle.italic,
                                fontFamily: AppTheme.fontCrimsonPro,
                                height: 1.33,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Icon(Icons.star, color: AppTheme.royalGold),
                              Icon(Icons.more_vert, color: AppTheme.royalGold),
                            ],
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
}
