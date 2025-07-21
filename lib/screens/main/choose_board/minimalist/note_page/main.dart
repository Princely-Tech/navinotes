import 'package:navinotes/packages.dart';
import 'vm.dart';

class MinimalistNotePageMain extends StatelessWidget {
  const MinimalistNotePageMain({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MinimalistNotePageVm>(
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
                      _noteCard(
                        lastEdited: 'Apr 28, 2025',
                        title: 'Wave Properties',
                        image: Images.boardMinimalistWave,
                        icons: [Images.file2, Images.img, Images.hook],
                      ),
                      _noteCard(
                        lastEdited: 'Apr 25, 2025',
                        title: 'Newton\'s Laws',
                        image: Images.boardMinimalistNewton,
                        icons: [Images.file2, Images.calculator],
                      ),
                      _noteCard(
                        lastEdited: 'Apr 22, 2025',
                        title: 'Thermodynamics',
                        image: Images.boardMinimalistThermodynamics,
                        icons: [Images.file2, Images.chart3],
                      ),
                      _noteCard(
                        lastEdited: 'Apr 20, 2025',
                        title: 'Electromagnetism',
                        image: Images.boardMinimalistElectromagnetism,
                        icons: [Images.file2, Images.img],
                      ),
                      _noteCard(
                        lastEdited: 'Apr 18, 2025',
                        title: 'Quantum Mechanics',
                        image: Images.boardMinimalistQuantum,
                        icons: [Images.file2, Images.calculator],
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

  Widget _noteCard({
    required String image,
    required String title,
    required String lastEdited,
    required List<String> icons,
  }) {
    return CustomCard(
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
              child: SVGImagePlaceHolder(imagePath: image),
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
                      title,
                      style: AppTheme.text.copyWith(
                        color: AppTheme.wetAsphalt,
                        fontSize: 16.0,
                        fontWeight: getFontWeight(500),
                        height: 1.50,
                      ),
                    ),
                    Text(
                      'Last edited: $lastEdited',
                      style: AppTheme.text.copyWith(
                        color: AppTheme.asbestos,
                        fontSize: 12.0,
                      ),
                    ),
                  ],
                ),
                ScrollableController(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    spacing: 10,
                    children:
                        icons
                            .map(
                              (icon) => SVGImagePlaceHolder(
                                imagePath: icon,
                                size: 16,
                                color: AppTheme.silver,
                              ),
                            )
                            .toList(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
