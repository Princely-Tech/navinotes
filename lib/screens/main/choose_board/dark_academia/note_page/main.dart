import 'package:navinotes/packages.dart';
import 'vm.dart';

class DarkAcademiaCreateNoteMain extends StatelessWidget {
  const DarkAcademiaCreateNoteMain({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DarkAcademiaCreateNoteVm>(
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
                    _noteCard(
                      lastEdited: 'Apr 28, 2025',
                      title: 'Wave Properties',
                      body:
                          'Amplitude, frequency, wavelength, and phase relationships...',
                      image: Images.boardDarkAcadNoteWave,
                    ),
                    _noteCard(
                      lastEdited: 'Apr 25, 2025',
                      title: 'Newton\'s Laws',
                      body:
                          'The three fundamental laws of motion and their applications...',
                      image: Images.boardDarkAcadNoteNewton,
                    ),
                    _noteCard(
                      lastEdited: 'Apr 22, 2025',
                      title: 'Thermodynamics',
                      body:
                          'Laws of thermodynamics, entropy, and energy transfer...',
                      image: Images.boardDarkAcadNoteThermodynamics,
                    ),
                    _noteCard(
                      lastEdited: 'Apr 20, 2025',
                      title: 'Electromagnetism',
                      body:
                          'Maxwell\'s equations, electric and magnetic fields...',
                      image: Images.boardDarkAcadNoteElectromagnetism,
                    ),
                    _noteCard(
                      lastEdited: 'Apr 28, 2025',
                      title: 'Quantum Mechanics',
                      body: 'Wave-particle duality, uncertainty principle...',
                      image: Images.boardDarkAcadNoteQuantum,
                    ),
                    Column(
                      children: [
                        InkWell(
                          onTap: NavigationHelper.gotToNoteTemplate,
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

  Widget _noteCard({
    required String image,
    required String title,
    required String body,
    required String lastEdited,
  }) {
    Radius radius = Radius.circular(12);
    return CustomCard(
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
                imagePath: image,
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
                  title,
                  style: AppTheme.text.copyWith(
                    color: AppTheme.royalGold,
                    fontSize: 18.0,
                    fontFamily: AppTheme.fontPlayfairDisplay,
                    height: 1.56,
                  ),
                ),
                Text(
                  body,
                  style: AppTheme.text.copyWith(
                    color: const Color(0xB2F5F5DC),
                    fontFamily: AppTheme.fontCrimsonPro,
                    height: 1.43,
                  ),
                ),
                Row(
                  spacing: 15,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Text(
                        'Last edited: $lastEdited',
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
    );
  }
}
