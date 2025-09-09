import 'package:navinotes/packages.dart';

class BoardLightAcadNotePageMain extends StatelessWidget {
  const BoardLightAcadNotePageMain({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<BoardNotePageVm>(
      builder: (_, vm, _) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: mobileHorPadding),
          child: ResponsivePadding(
            mobile: EdgeInsets.only(top: 5),
            desktop: EdgeInsets.only(top: 20),
            child: Column(
              children: [
                BoardPageMainHeader(theme: BoardTheme.lightAcademia),
                Expanded(
                  child: ScrollableController(
                    mobilePadding: EdgeInsets.only(bottom: 30, top: 20),
                    child: vm.pageDisplayFormat == PageDisplayFormat.grid
                        ? CustomGrid(
                            wrapWithIntrinsicHeight: false,
                            children: [
                              ...vm.contents.map((content) => _noteCard(content)),
                              _createNewNoteCard(vm),
                            ],
                          )
                        : Column(
                            children: [
                              ...vm.contents.map(
                                (content) => Padding(
                                  padding: EdgeInsets.only(bottom: 15),
                                  child: _noteListItem(content: content),
                                ),
                              ),
                              _createNewNoteCard(vm),
                            ],
                          ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _createNewNoteCard(BoardNotePageVm vm) {
    return Column(
      children: [
        InkWell(
          onTap: vm.gotToCreateNotePage,
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: 200),
            child: CustomCard(
              addBorder: true,
              addCardShadow: true,
              decoration: BoxDecoration(
                color: AppTheme.almondCream,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 15,
                children: [
                  OutlinedChild(
                    size: 48,
                    decoration: BoxDecoration(
                      color: AppTheme.royalGold.withAlpha(0x19),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.add,
                      color: AppTheme.royalGold,
                      size: 20,
                    ),
                  ),
                  Text(
                    'Create New Note Page',
                    style: TextStyle(
                      color: const Color(0xFF654321),
                      fontSize: 16.0,
                      fontFamily: 'Crimson Text',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _noteListItem({required Content content}) {
    return Consumer<BoardNotePageVm>(
      builder: (_, vm, _) {
        return InkWell(
          onTap: () => NavigationHelper.navigateToContent(content),
          child: CustomCard(
            addCardShadow: true,
            addBorder: true,
            decoration: BoxDecoration(
              color: AppTheme.almondCream,
            ),
            padding: EdgeInsets.all(15),
            child: Row(
              spacing: 15,
              children: [
                CustomCard(
                  width: 80,
                  height: 60,
                  addCardShadow: true,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: AppTheme.royalGold.withAlpha(0x33),
                  ),
                  padding: EdgeInsets.zero,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: AppTheme.royalGold.withAlpha(0x80),
                    ),
                    child: Center(
                      child: Icon(
                        content.type == AppContentType.mindmap
                            ? Icons.account_tree
                            : content.type == AppContentType.file
                                ? Icons.insert_drive_file
                                : Icons.note,
                        color: const Color(0xFF654321),
                        size: 24,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 8,
                    children: [
                      Text(
                        content.title,
                        style: TextStyle(
                          color: const Color(0xFF654321),
                          fontSize: 16.0,
                          fontFamily: 'Crimson Text',
                          fontWeight: FontWeight.w400,
                          height: 1.50,
                        ),
                      ),
                      Text(
                        'Last edited: ${formatUnixTimestamp(content.updatedAt)}',
                        style: TextStyle(
                          color: const Color(0xB2654321),
                          fontSize: 12.0,
                          fontFamily: 'Crimson Text',
                          fontWeight: FontWeight.w400,
                          height: 1.33,
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

  Widget _noteCard(Content content) {
    return Consumer<BoardNotePageVm>(
      builder: (_, vm, _) {
        return InkWell(
          onTap: () => NavigationHelper.navigateToContent(content),
          child: Stack(
            children: [
              CustomCard(
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
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.zero,
                            color: AppTheme.royalGold.withAlpha(0x80),
                          ),
                          child: Center(
                            child: Icon(
                              content.type == AppContentType.mindmap
                                  ? Icons.account_tree
                                  : content.type == AppContentType.file
                                      ? Icons.insert_drive_file
                                      : Icons.note,
                              color: const Color(0xFF654321),
                              size: 32,
                            ),
                          ),
                        ),
                      ),
                    ),
                    CustomCard(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: AppTheme.almondCream,
                        borderRadius: BorderRadius.zero,
                      ),
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
                                style: TextStyle(
                                  color: const Color(0xFF654321),
                                  fontSize: 18.0,
                                  fontFamily: 'Crimson Text',
                                  fontWeight: FontWeight.w400,
                                  height: 1.56,
                                ),
                              ),
                              Text(
                                'Last edited: ${formatUnixTimestamp(content.updatedAt)}',
                                style: TextStyle(
                                  color: const Color(0xB2654321),
                                  fontSize: 14.0,
                                  fontFamily: 'Crimson Text',
                                  fontWeight: FontWeight.w400,
                                  height: 1.43,
                                ),
                              ),
                            ],
                          ),
                          //TODO return to this
                          // LayoutBuilder(
                          //   builder: (_, constraints) {
                          //     return ScrollableController(
                          //       scrollDirection: Axis.horizontal,
                          //       child: Container(
                          //         constraints: BoxConstraints(
                          //           minWidth: constraints.maxWidth,
                          //         ),
                          //         child: Row(
                          //           spacing: 15,
                          //           mainAxisAlignment:
                          //               MainAxisAlignment.spaceBetween,
                          //           children: [
                          //             Row(
                          //               spacing: 10,
                          //               children:
                          //                   [Images.share2, Images.star2]
                          //                       .map(
                          //                         (icon) => SVGImagePlaceHolder(
                          //                           imagePath: icon,
                          //                           size: 16,
                          //                           color: AppTheme.sepiaBrown,
                          //                         ),
                          //                       )
                          //                       .toList(),
                          //             ),
                          //             Icon(
                          //               Icons.more_horiz,
                          //               size: 25,
                          //               color: AppTheme.sepiaBrown,
                          //             ),
                          //           ],
                          //         ),
                          //       ),
                          //     );
                          //   },
                          // ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 0,
                bottom: 0,
                left: 0,
                right: 0,
                child: Opacity(
                  opacity: 0.05,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppTheme.yellowishOrange.withAlpha(0xFF),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
