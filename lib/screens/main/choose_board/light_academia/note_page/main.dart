import 'package:navinotes/packages.dart';
import 'vm.dart';

class BoardLightAcadNotePageMain extends StatelessWidget {
  const BoardLightAcadNotePageMain({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<BoardLightAcadNotePageVm>(
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
                    child: CustomGrid(
                      wrapWithIntrinsicHeight: false,
                      children: [
                        // _noteCard(
                        //   lastEdited: 'Apr 28, 2025',
                        //   title: 'Wave Properties',
                        //   image: Images.boardLightAcadNoteWave,
                        // ),
                        // _noteCard(
                        //   lastEdited: 'Apr 25, 2025',
                        //   title: 'Newton\'s Laws',
                        //   image: Images.boardLightAcadNoteNewton,
                        // ),
                        // _noteCard(
                        //   lastEdited: 'Apr 22, 2025',
                        //   title: 'Thermodynamics',
                        //   image: Images.boardLightAcadNoteThermodynamics,
                        // ),
                        // _noteCard(
                        //   lastEdited: 'Apr 20, 2025',
                        //   title: 'Electromagnetism',
                        //   image: Images.boardLightAcadNoteElectromagnetism,
                        // ),
                        // _noteCard(
                        //   lastEdited: 'Apr 18, 2025',
                        //   title: 'Quantum Mechanics',
                        //   image: Images.boardLightAcadNoteQuantum,
                        // ),
                        // _noteCard(
                        //   lastEdited: 'Apr 18, 2025',
                        //   title: 'Optics & Light',
                        //   image: Images.boardLightAcadNoteOptics,
                        // ),
                        Column(
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
                                          color: AppTheme.royalGold.withAlpha(
                                            0x19,
                                          ),
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
                        ),
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

  Widget _noteCard({
    required String image,
    required String title,
    required String lastEdited,
  }) {
    return Stack(
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
                  borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
                ),
                clipBehavior: Clip.antiAlias,
                child: AspectRatio(
                  aspectRatio: 5 / 2,
                  child: ImagePlaceHolder(
                    imagePath: image,
                    borderRadius: BorderRadius.zero,
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
                          title,
                          style: TextStyle(
                            color: const Color(0xFF654321),
                            fontSize: 18.0,
                            fontFamily: 'Crimson Text',
                            fontWeight: FontWeight.w400,
                            height: 1.56,
                          ),
                        ),
                        Text(
                          'Last edited: $lastEdited',
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
                    LayoutBuilder(
                      builder: (_, constraints) {
                        return ScrollableController(
                          scrollDirection: Axis.horizontal,
                          child: Container(
                            constraints: BoxConstraints(
                              minWidth: constraints.maxWidth,
                            ),
                            child: Row(
                              spacing: 15,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  spacing: 10,
                                  children:
                                      [Images.share2, Images.star2]
                                          .map(
                                            (icon) => SVGImagePlaceHolder(
                                              imagePath: icon,
                                              size: 16,
                                              color: AppTheme.sepiaBrown,
                                            ),
                                          )
                                          .toList(),
                                ),
                                Icon(
                                  Icons.more_horiz,
                                  size: 25,
                                  color: AppTheme.sepiaBrown,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
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
    );
  }
}
