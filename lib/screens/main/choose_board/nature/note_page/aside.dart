import 'package:navinotes/packages.dart';
import 'vm.dart';

class NatureNotePageAside extends StatelessWidget {
  const NatureNotePageAside({super.key, this.isFull = false});
  final bool isFull;
  @override
  Widget build(BuildContext context) {
    return Consumer<NatureNotePageVm>(
      builder: (_, vm, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ExpandableController(
              isFlexible: !isFull,
              child: CustomCard(
                padding: EdgeInsets.zero,
                decoration: BoxDecoration(
                  color: Apptheme.burntClove.withAlpha(0x7F),
                  border: Border.all(color: Apptheme.royalGold.withAlpha(0x4C)),
                  borderRadius: BorderRadius.circular(isFull ? 4 : 8),
                ),
                child: ScrollableController(
                  mobilePadding: EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 20,
                  ),
                  tabletPadding: EdgeInsets.all(20),
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
                                color: Apptheme.burntLeather.withAlpha(0xFF),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                  side: BorderSide(color: Apptheme.royalGold),
                                ),
                                prefix: Icon(
                                  Icons.add,
                                  color: Apptheme.royalGold,
                                  size: 20,
                                ),
                                style: Apptheme.text.copyWith(
                                  color: Apptheme.royalGold,
                                  fontSize: 16.0,
                                  fontFamily: Apptheme.fontCrimsonPro,
                                ),
                              ),
                            ),
                          ),
                          Column(
                            spacing: 15,
                            children: [
                              AppButton(
                                onTap:
                                    () => NavigationHelper.push(
                                      Routes.boardDarkAcademiaMindMap,
                                    ),
                                text: 'View Mind Map',
                                color: Apptheme.fadedEmber.withAlpha(0xFF),
                                borderColor: Apptheme.royalGold.withAlpha(0x7F),
                                prefix: Padding(
                                  padding: const EdgeInsets.only(right: 5),
                                  child: SVGImagePlaceHolder(
                                    imagePath: Images.share,
                                    size: 16,
                                    color: Apptheme.royalGold,
                                  ),
                                ),
                                style: Apptheme.text.copyWith(
                                  color: Apptheme.royalGold,
                                  fontSize: 16.0,
                                  fontFamily: Apptheme.fontPlayfairDisplay,
                                ),
                              ),
                              Text(
                                'Visualize connections between notes',
                                textAlign: TextAlign.center,
                                style: Apptheme.text.copyWith(
                                  color: Apptheme.vanilaDust.withAlpha(0x99),
                                  fontSize: 12.0,
                                  fontFamily: Apptheme.fontCrimsonPro,
                                  height: 1.33,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _viewedItem({required String title, required String time}) {
    return Row(
      children: [
        Expanded(
          child: Row(
            spacing: 10,
            children: [
              SVGImagePlaceHolder(
                imagePath: Images.file,
                size: 16,
                color: Apptheme.royalGold,
              ),
              Expanded(
                child: Text(
                  title,
                  style: Apptheme.text.copyWith(
                    color: Apptheme.vanilaDust,
                    fontSize: 16.0,
                    fontFamily: Apptheme.fontCrimsonPro,
                    height: 1.50,
                  ),
                ),
              ),
            ],
          ),
        ),
        Text(
          time,
          style: Apptheme.text.copyWith(
            color: Apptheme.vanilaDust.withAlpha(0x99),
            fontSize: 12.0,
            fontFamily: Apptheme.fontCrimsonPro,
            height: 1.33,
          ),
        ),
      ],
    );
  }

  Widget _recentlyViewed() {
    return RoyalGoldHeaderSection(
      title: 'Recently Viewed',
      child: Column(
        spacing: 15,
        children: [
          _viewedItem(title: 'Wave Properties', time: '2h ago'),
          _viewedItem(title: 'Newton\'s Laws', time: '5h ago'),
          _viewedItem(title: 'Thermodynamics', time: '1d ago'),
        ],
      ),
    );
  }

  Widget _tagItem({required String text, required Color color}) {
    return Container(
      decoration: ShapeDecoration(
        color: const Color(0xB22C1810),
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 1, color: const Color(0x4CD4AF37)),
          borderRadius: BorderRadius.circular(9999),
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Text(
        text,
        style: Apptheme.text.copyWith(
          color: color,
          fontFamily: Apptheme.fontCrimsonPro,
        ),
      ),
    );
  }

  Widget _tags() {
    return RoyalGoldHeaderSection(
      title: 'Tags',
      child: Wrap(
        runSpacing: 15,
        spacing: 10,
        children: [
          _tagItem(color: Apptheme.softSkyBlue, text: 'Physics'),
          _tagItem(color: Apptheme.deepMoss, text: 'Science'),
          _tagItem(color: Apptheme.fadedEmber.withAlpha(0xFF), text: 'Study'),
          _tagItem(color: Apptheme.blazingCopper, text: 'Exam Prep'),
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
          style: Apptheme.text.copyWith(
            color: Apptheme.vanilaDust.withAlpha(0xB2),
            fontSize: 16.0,
            fontFamily: Apptheme.fontCrimsonPro,
            height: 1.50,
          ),
        ),
        Expanded(
          child: Text(
            textAlign: TextAlign.right,
            value,
            style: Apptheme.text.copyWith(
              color: Apptheme.vanilaDust,
              fontSize: 16.0,
              fontFamily: Apptheme.fontCrimsonPro,
              height: 1.50,
            ),
          ),
        ),
      ],
    );
  }

  Widget _boardDetails() {
    return RoyalGoldHeaderSection(
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
