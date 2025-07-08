import 'package:navinotes/packages.dart';
import 'vm.dart';

class BoardLightAcadNotePageAside extends StatelessWidget {
  const BoardLightAcadNotePageAside({super.key});
  // final bool isFull;
  @override
  Widget build(BuildContext context) {
    return Consumer<BoardLightAcadNotePageVm>(
      builder: (_, vm, _) {
        return Container(
          decoration: BoxDecoration(
            color: AppTheme.eggShell.withAlpha(0xFF),
            border: Border(
              left: BorderSide(color: AppTheme.royalGold.withAlpha(0x33)),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ExpandableController(
                child: ScrollableController(
                  mobilePadding: EdgeInsets.all(10),
                  desktopPadding: EdgeInsets.fromLTRB(20, 30, 20, 20),
                  child: Column(
                    spacing: 30,
                    children: [
                      _boardDetails(),
                      _tags(),
                      _recentlyViewed(),
                      Column(
                        children: [
                          VisibleController(
                            mobile: true,
                            desktop: false,
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 15),
                              child: AppButton(
                                onTap: vm.gotToCreateNotePage,
                                text: 'New Note Page',
                                minHeight: 40,
                                color: AppTheme.royalGold.withAlpha(0xE5),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                prefix: Icon(
                                  Icons.add,
                                  color: AppTheme.white,
                                  size: 20,
                                ),
                                style: AppTheme.text.copyWith(
                                  color: AppTheme.eggShell.withAlpha(0xFF),
                                  fontSize: 16.0,
                                  fontFamily: AppTheme.fontCrimsonText,
                                ),
                              ),
                            ),
                          ),
                          AppButton(
                            onTap:
                                () => NavigationHelper.push(
                                  Routes.boardLightAcademiaMindMap,
                                ),
                            color: AppTheme.almondCream,
                            borderColor: AppTheme.royalGold.withAlpha(0x4C),
                            child: Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(5),
                                child: Row(
                                  spacing: 15,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SVGImagePlaceHolder(
                                      imagePath: Images.share,
                                      color: AppTheme.royalGold,
                                      size: 18,
                                    ),
                                    Flexible(
                                      child: Column(
                                        spacing: 5,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'View Mind Map',
                                            textAlign: TextAlign.center,
                                            style: AppTheme.text.copyWith(
                                              color: AppTheme.sepiaBrown,
                                              fontSize: 16.0,
                                              fontFamily:
                                                  AppTheme.fontCrimsonText,
                                              height: 1.50,
                                            ),
                                          ),
                                          Text(
                                            'See connections between notes',
                                            textAlign: TextAlign.center,
                                            style: AppTheme.text.copyWith(
                                              color: AppTheme.sepiaBrown
                                                  .withAlpha(0x99),
                                              fontSize: 12.0,
                                              fontFamily:
                                                  AppTheme.fontCrimsonText,
                                              height: 1.33,
                                            ),
                                          ),
                                        ],
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

  Widget _viewedItem({
    required String title,
    required String time,
    required String icon,
  }) {
    return Row(
      spacing: 10,
      children: [
        OutlinedChild(
          size: 32,
          decoration: BoxDecoration(
            color: AppTheme.royalGold.withAlpha(0x19),
            borderRadius: BorderRadius.circular(4),
          ),
          child: SVGImagePlaceHolder(
            imagePath: icon,
            size: 16,
            color: AppTheme.royalGold,
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTheme.text.copyWith(
                  color: AppTheme.sepiaBrown,
                  fontSize: 16.0,
                  fontFamily: AppTheme.fontCrimsonText,
                  height: 1.50,
                ),
              ),
              Text(
                time,
                style: AppTheme.text.copyWith(
                  color: AppTheme.sepiaBrown.withAlpha(0x99),
                  fontSize: 12.0,
                  fontFamily: AppTheme.fontCrimsonText,
                  height: 1.33,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _recentlyViewed() {
    return EditHeaderSection(
      theme: BoardTheme.lightAcademia,
      title: 'Recently Viewed',
      child: Column(
        spacing: 15,
        children: [
          _viewedItem(
            title: 'Wave Properties',
            time: '2 hours ago',
            icon: Images.boardNatureWaveLine,
          ),
          _viewedItem(
            title: 'Quantum Mechanics',
            time: 'yesterday',
            icon: Images.boardNatureQuantumIcon,
          ),
          _viewedItem(
            title: 'Thermodynamics',
            time: '2 days ago',
            icon: Images.flash,
          ),
        ],
      ),
    );
  }

  Widget _tagItem({
    required String text,
    required Color color,
    required Color borderColor,
  }) {
    return Container(
      decoration: ShapeDecoration(
        color: color,
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 1, color: borderColor),
          borderRadius: BorderRadius.circular(9999),
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Text(
        text,
        style: AppTheme.text.copyWith(
          color: AppTheme.sepiaBrown,
          fontFamily: AppTheme.fontCrimsonText,
        ),
      ),
    );
  }

  Widget _tags() {
    return EditHeaderSection(
      theme: BoardTheme.lightAcademia,
      title: 'Tags',
      child: Wrap(
        runSpacing: 15,
        spacing: 10,
        children: [
          _tagItem(
            color: AppTheme.royalGold.withAlpha(0x19),
            borderColor: AppTheme.royalGold.withAlpha(0x4C),
            text: 'Physics',
          ),
          _tagItem(
            color: AppTheme.asparagus,
            borderColor: AppTheme.asparagus.withAlpha(0x4C),
            text: 'Science',
          ),
          _tagItem(
            color: AppTheme.almondCream,
            borderColor: AppTheme.royalGold.withAlpha(0x4C),
            text: 'Study',
          ),
          _tagItem(
            color: AppTheme.yellowishOrange.withAlpha(0x19),
            borderColor: AppTheme.yellowishOrange.withAlpha(0x4C),
            text: 'Exam Prep',
          ),
        ],
      ),
    );
  }

  Widget _detailsItem({required String title, required String value}) {
    return Row(
      spacing: 15,
      children: [
        Text(
          title,
          style: AppTheme.text.copyWith(
            color: AppTheme.sepiaBrown.withAlpha(0xB2),
            fontSize: 16.0,
            fontFamily: AppTheme.fontCrimsonText,
            height: 1.50,
          ),
        ),
        Expanded(
          child: Text(
            textAlign: TextAlign.right,
            value,
            style: AppTheme.text.copyWith(
              color: AppTheme.sepiaBrown,
              fontSize: 16.0,
              fontFamily: AppTheme.fontCrimsonText,
              height: 1.50,
            ),
          ),
        ),
      ],
    );
  }

  Widget _boardDetails() {
    return EditHeaderSection(
      theme: BoardTheme.lightAcademia,
      title: 'Board Details',
      child: Column(
        spacing: 15,
        children: [
          _detailsItem(title: 'Created', value: 'Mar 15, 2025'),
          _detailsItem(title: 'Pages', value: '8'),
          _detailsItem(title: 'Owner', value: 'Professor Hawking'),
        ],
      ),
    );
  }
}
