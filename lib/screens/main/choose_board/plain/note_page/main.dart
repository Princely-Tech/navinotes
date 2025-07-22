import 'shared.dart';
import 'vm.dart';
import 'package:navinotes/packages.dart';

class BoardPlainNotePageMain extends StatelessWidget {
  const BoardPlainNotePageMain({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<BoardPlainNotePageVm>(
      builder: (_, vm, _) {
        return Column(
          children: [
            _header(vm),
            Expanded(
              child:
                  vm.fetchingContent
                      ? Center(child: CircularProgressIndicator())
                      : ScrollableController(
                        mobilePadding: EdgeInsets.all(defaultHorizontalPadding),
                        child: CustomGrid(
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

                          // children: [

                          //   _noteCard(
                          //     lastEdited: 'Apr 25, 2025',
                          //     title: 'Newton\'s Laws',
                          //     image: Images.noteNewton,
                          //     outLines: _outlineRow(
                          //       outline1: _outline(),
                          //       outline2: _outline(
                          //         image: Images.video,
                          //         color: AppTheme.pastelPurple,
                          //       ),
                          //     ),
                          //   ),
                          //   _noteCard(
                          //     lastEdited: 'Apr 22, 2025',
                          //     title: 'Thermodynamics',
                          //     image: Images.noteThermodynamics,
                          //     outLines: _outlineRow(
                          //       outline1: _outline(),
                          //       outline2: _outline(
                          //         image: Images.copy2,
                          //         color: AppTheme.softGold,
                          //       ),
                          //     ),
                          //   ),
                          //   _noteCard(
                          //     lastEdited: 'Apr 20, 2025',
                          //     title: 'Electromagnetism',
                          //     image: Images.noteElectromagnetism,
                          //     outLines: _outlineRow(
                          //       outline1: _outline(),
                          //       outline2: _outline(
                          //         image: Images.chart,
                          //         color: AppTheme.blushPink,
                          //       ),
                          //     ),
                          //   ),
                          //   _noteCard(
                          //     lastEdited: 'Apr 18, 2025',
                          //     title: 'Quantum Mechanics',
                          //     image: Images.noteMechanics,
                          //     outLines: _outlineRow(
                          //       outline1: _outline(),
                          //       outline2: _outline(
                          //         image: Images.calculator,
                          //         color: AppTheme.periwinkle,
                          //       ),
                          //     ),
                          //   ),
                          //   _noteCard(
                          //     lastEdited: 'Apr 28, 2025',
                          //     title: 'Optics & Light',
                          //     image: Images.noteOptics,
                          //     outLines: _outlineRow(
                          //       outline1: _outline(),
                          //       outline2: _outline(
                          //         image: Images.img,
                          //         color: AppTheme.paleJade,
                          //       ),
                          //     ),
                          //   ),
                          //   if (isNotNull(board))
                          //     CreateCard(
                          //       width: double.infinity,
                          //       onTap: () => vm.gotToCreateNotePage(board!),
                          //       text: 'Create New Note Page',
                          //     ),
                          // ],
                        ),
                      ),
            ),
          ],
        );
      },
    );
  }

  Widget _outline({
    String image = Images.hook,
    Color color = AppTheme.pastelBlue,
  }) {
    return OutlinedChild(
      size: 20,
      decoration: BoxDecoration(
        color: color,
        border: Border(),
        shape: BoxShape.circle,
      ),
      child: SVGImagePlaceHolder(imagePath: image, size: 12),
    );
  }

  Widget _outlineRow({required Widget outline1, required Widget outline2}) {
    return Stack(
      children: [
        SizedBox(width: 35, height: 20),
        Positioned(left: 0, bottom: 0, child: outline1),
        Positioned(right: 0, bottom: 0, child: outline2),
      ],
    );
  }

  Widget _noteCard({required Content content}) {
    BoardNoteTemplate template = getNoteTemplateFromString(
      content.metaData[ContentMetadataKey.template],
    );
    return Consumer<BoardPlainNotePageVm>(
      builder: (_, vm, _) {
        Radius radius = Radius.circular(12);
        return InkWell(
          onTap: () => vm.goToNotePage(content),
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
                    child: ImagePlaceHolder(
                      imagePath: template.image,
                      isCardHeader: true,
                      borderRadius: BorderRadius.circular(0),
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
                          _outlineRow(
                            outline1: _outline(),
                            outline2: _outline(
                              image: Images.img,
                              color: AppTheme.paleJade,
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

  Widget _header(BoardPlainNotePageVm vm) {
    String title = '${vm.contents.length} Note Page';
    if (vm.contents.length > 1) {
      title = '${title}s';
    }
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
          Text(title, style: AppTheme.text.copyWith(fontSize: 16.0)),
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
                    Container(
                      decoration: BoxDecoration(
                        color: AppTheme.lightAsh,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(5),
                        child: Row(
                          spacing: 5,
                          children: [
                            OutlinedChild(
                              size: 32,
                              decoration: BoxDecoration(color: AppTheme.white),
                              child: SVGImagePlaceHolder(
                                imagePath: Images.ques2,
                                size: 16,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 5,
                              ),
                              child: SVGImagePlaceHolder(
                                imagePath: Images.menu,
                                size: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
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
    return Consumer<BoardPlainNotePageVm>(
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
