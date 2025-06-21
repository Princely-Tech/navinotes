import 'package:navinotes/packages.dart';
import 'vm.dart';

class NatureNotePageMain extends StatelessWidget {
  const NatureNotePageMain({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<NatureNotePageVm>(
      builder: (_, vm, _) {
        return Column(
          children: [
            BoardPageMainHeader(theme: BoardTheme.nature),
            Expanded(
              child: ScrollableController(
                mobilePadding: EdgeInsets.symmetric(
                  vertical: defaultHorizontalPadding,
                ),
                child: CustomGrid(
                  children: [
                    _noteCard(
                      lastEdited: 'Apr 28, 2025',
                      title: 'Wave Properties',
                      image: Images.boardDarkAcadNoteWave,
                    ),
                    _noteCard(
                      lastEdited: 'Apr 25, 2025',
                      title: 'Newton\'s Laws',
                      image: Images.boardDarkAcadNoteNewton,
                    ),
                    _noteCard(
                      lastEdited: 'Apr 22, 2025',
                      title: 'Thermodynamics',
                      image: Images.boardDarkAcadNoteThermodynamics,
                    ),
                    _noteCard(
                      lastEdited: 'Apr 20, 2025',
                      title: 'Electromagnetism',
                      image: Images.boardDarkAcadNoteElectromagnetism,
                    ),
                    _noteCard(
                      lastEdited: 'Apr 28, 2025',
                      title: 'Quantum Mechanics',
                      image: Images.boardDarkAcadNoteQuantum,
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
                                color: Apptheme.burntLeather.withAlpha(0x99),
                                border: Border.all(
                                  color: Apptheme.royalGold.withAlpha(0x4CD),
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
                                      color: Apptheme.royalGold.withAlpha(0x33),
                                      shape: BoxShape.circle,
                                    ),
                                    padding: EdgeInsets.zero,
                                    child: Icon(
                                      Icons.add,
                                      color: Apptheme.royalGold,
                                      size: 30,
                                    ),
                                  ),
                                  Text(
                                    'Create New Note Page',
                                    style: Apptheme.text.copyWith(
                                      color: Apptheme.royalGold,
                                      fontSize: 18.0,
                                      fontFamily: Apptheme.fontPlayfairDisplay,
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

  Widget _noteCard({
    required String image,
    required String title,
    required String lastEdited,
  }) {
    return CustomCard(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Apptheme.coffee),
      ),
      padding: EdgeInsets.all(15),
      child: Column(
        spacing: 10,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 5 / 2,
            child: ImagePlaceHolder(
              imagePath: image,
              isCardHeader: true,
              borderRadius: BorderRadius.circular(0),
              fit: BoxFit.fill,
            ),
          ),
          Row(
            spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  spacing: 10,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Apptheme.text.copyWith(
                        color: Apptheme.darkMossGreen,
                        fontSize: 16.0,
                        fontFamily: Apptheme.fontLibreBaskerville,
                        height: 1.50,
                      ),
                    ),
                    Text(
                      'Last edited: $lastEdited',
                      style: Apptheme.text.copyWith(
                        color: Apptheme.coffee,
                        fontSize: 12.0,
                        fontFamily: Apptheme.fontCrimsonText,
                        height: 1.33,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Icon(Icons.star, color: Apptheme.royalGold),
                  Icon(Icons.more_vert, color: Apptheme.royalGold),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
