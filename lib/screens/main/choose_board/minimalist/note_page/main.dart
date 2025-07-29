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
                                        color: AppTheme.steelBlue.withAlpha(
                                          0x19,
                                        ),
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
                                      style: AppTheme.text.copyWith(
                                        color: AppTheme.asbestos,
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
          ),
        );
      },
    );
  }

  Widget _noteCard({required Content content}) {
    BoardNoteTemplate template = getNoteTemplateFromString(
      content.metaData[ContentMetadataKey.template],
    );
    return Consumer<BoardNotePageVm>(
      builder: (_, vm, _) {
        return InkWell(
          onTap: () => vm.goToNotePage(content),
          child: CustomCard(
            addCardShadow: true,
            addBorder: true,
            padding: EdgeInsets.zero,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(8),
                    ),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: AspectRatio(
                    aspectRatio: 5 / 2,
                    child: ImagePlaceHolder(
                      imagePath: template.image,
                      borderRadius: BorderRadius.zero,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    spacing: 20,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
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
                      //TODO return to this
                      // ScrollableController(
                      //   scrollDirection: Axis.horizontal,
                      //   child: Row(
                      //     spacing: 10,
                      //     children:
                      //         icons
                      //             .map(
                      //               (icon) => SVGImagePlaceHolder(
                      //                 imagePath: icon,
                      //                 size: 16,
                      //                 color: AppTheme.silver,
                      //               ),
                      //             )
                      //             .toList(),
                      //   ),
                      // ),
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
