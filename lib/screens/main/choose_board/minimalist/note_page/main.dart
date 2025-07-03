import 'package:navinotes/packages.dart';
import 'vm.dart';

class MinimalistNotePageMain extends StatelessWidget {
  const MinimalistNotePageMain({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MinimalistNotePageVm>(
      builder: (_, vm, _) {
        return ResponsivePadding(
          mobile: EdgeInsets.only(top: 10),
          desktop: EdgeInsets.only(top: 30),
          child: Column(
            children: [
              BoardPageMainHeader(theme: BoardTheme.nature),
              Expanded(
                child: ScrollableController(
                  mobilePadding: EdgeInsets.only(bottom: 30),
                  child: CustomGrid(
                    children: [
                      _noteCard(
                        lastEdited: 'Apr 28, 2025',
                        title: 'Wave Properties',
                        image: Images.boardNatureWave,
                      ),
                      _noteCard(
                        lastEdited: 'Apr 25, 2025',
                        title: 'Newton\'s Laws',
                        image: Images.boardNatureNewton,
                      ),
                      _noteCard(
                        lastEdited: 'Apr 22, 2025',
                        title: 'Thermodynamics',
                        image: Images.boardNatureThermodynamics,
                      ),
                      _noteCard(
                        lastEdited: 'Apr 20, 2025',
                        title: 'Electromagnetism',
                        image: Images.boardNatureElectromagnetism,
                      ),
                      _noteCard(
                        lastEdited: 'Apr 18, 2025',
                        title: 'Quantum Mechanics',
                        image: Images.boardNatureQuantum,
                      ),
                      _noteCard(
                        lastEdited: 'Apr 15, 2025',
                        title: 'Optics & Light',
                        image: Images.boardNatureOptics,
                      ),
                      Column(
                        children: [
                          InkWell(
                            onTap: vm.gotToCreateNotePage,
                            child: ConstrainedBox(
                              constraints: BoxConstraints(minHeight: 220),
                              child: Container(
                                width: double.infinity,
                                decoration: DottedDecoration(
                                  color: AppTheme.burntLeather,
                                  shape: Shape.box,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  spacing: 15,
                                  children: [
                                    CustomCard(
                                      width: 56,
                                      height: 56,
                                      decoration: BoxDecoration(
                                        color: AppTheme.lightSage.withAlpha(
                                          0x7F,
                                        ),
                                        shape: BoxShape.circle,
                                      ),
                                      padding: EdgeInsets.zero,
                                      child: Icon(
                                        Icons.add,
                                        color: AppTheme.coffee,
                                        size: 30,
                                      ),
                                    ),
                                    Text(
                                      'Create New Note Page',
                                      style: AppTheme.text.copyWith(
                                        color: AppTheme.coffee,
                                        fontSize: 18.0,
                                        fontFamily:
                                            AppTheme.fontPlayfairDisplay,
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

  Widget _noteCard({
    required String image,
    required String title,
    required String lastEdited,
  }) {
    return CustomCard(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.burntLeather.withAlpha(0x33)),
      ),
      padding: EdgeInsets.all(15),
      child: Column(
        spacing: 15,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomCard(
            addShadow: true,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: AppTheme.sageMist.withAlpha(0x4C),
            ),
            padding: EdgeInsets.zero,
            child: AspectRatio(
              aspectRatio: 5 / 2,
              child: ImagePlaceHolder(
                imagePath: image,
                isCardHeader: true,
                borderRadius: BorderRadius.circular(0),
                fit: BoxFit.fill,
              ),
            ),
          ),
          Row(
            spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  spacing: 5,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTheme.text.copyWith(
                        color: AppTheme.darkMossGreen,
                        fontSize: 16.0,
                        fontFamily: AppTheme.fontLibreBaskerville,
                        height: 1.50,
                      ),
                    ),
                    Text(
                      'Last edited: $lastEdited',
                      style: AppTheme.text.copyWith(
                        color: AppTheme.coffee,
                        fontSize: 12.0,
                        fontFamily: AppTheme.fontCrimsonText,
                        height: 1.33,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  SVGImagePlaceHolder(imagePath: Images.star2, size: 18),
                  Icon(Icons.more_vert, color: AppTheme.deepMoss),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
