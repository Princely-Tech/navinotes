import 'package:navinotes/packages.dart';

class MarketplaceMain extends StatelessWidget {
  const MarketplaceMain({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsivePadding(
      mobile: const EdgeInsets.fromLTRB(10, 10, 10, 0),
      tablet: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Column(
        children: [
          _header(),
          Expanded(
            child: ScrollableController(
              mobilePadding: EdgeInsets.symmetric(vertical: 20),
              child: Column(
                spacing: 30,
                children: [_featured(), _allContent(), CustomPaination()],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _allContent() {
    return _section(
      title: 'All Content',
      titleRight: Row(
        spacing: 10,
        children: [
          _layoutBtn(PageDisplayFormat.grid),
          _layoutBtn(PageDisplayFormat.list),
        ],
      ),
      child: CustomGrid(
        spacing: 20,
        children: [
          _contentItem(Images.marketPlaceNeuroanatomy),
          _contentItem(Images.marketPlacePhysics),
          _contentItem(Images.marketPlaceLogic),
          _contentItem(Images.marketPlaceBiomedesty),
          _contentItem(Images.marketPlacePmpCertification),
          _contentItem(Images.marketPlaceMandarin),
        ],
      ),
    );
  }

  Widget _contentItem(String image) {
    return CustomCard(
      padding: EdgeInsets.zero,
      addBorder: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 3,
            child: ImagePlaceHolder(imagePath: image, isCardHeader: true),
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 15,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 10,
                  children: [
                    Text(
                      'Neuroanatomy & Function Mind Map',
                      style: AppTheme.text.copyWith(
                        color: AppTheme.charcoalBlue,
                        fontSize: 16.0,
                        fontWeight: getFontWeight(500),
                      ),
                    ),
                    Text(
                      'by Neuroscience Hub',
                      style: AppTheme.text.copyWith(
                        color: AppTheme.stormGray,
                        fontSize: 12.0,
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        StarRows(fullStars: 5, emptyStars: 0),
                        Text(
                          '(87)',
                          style: AppTheme.text.copyWith(
                            color: AppTheme.stormGray,
                            fontSize: 12.0,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  spacing: 10,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      spacing: 5,
                      children: [
                        SVGImagePlaceHolder(
                          imagePath: Images.share,
                          color: AppTheme.steelMist,
                          size: 13,
                        ),
                        Text(
                          'Mind Map',
                          style: AppTheme.text.copyWith(
                            color: AppTheme.steelMist,
                            fontSize: 12.0,
                          ),
                        ),
                      ],
                    ),
                    AppButton(
                      onTap: () {},
                      text: 'Add To Cart',
                      mainAxisSize: MainAxisSize.min,
                      color: AppTheme.strongBlue,
                      minHeight: 28,
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

  Widget _layoutBtn(PageDisplayFormat format) {
    bool isGrid = format == PageDisplayFormat.grid;
    return OutlinedChild(
      size: 30,
      decoration: BoxDecoration(
        border: Border.all(width: 2, color: AppTheme.lightGray),
      ),
      child: SVGImagePlaceHolder(
        imagePath: isGrid ? Images.grid : Images.menu,
        color: isGrid ? AppTheme.darkSlateGray : AppTheme.blueGray,
        size: isGrid ? 14 : 16,
      ),
    );
  }

  Widget _featured() {
    return _section(
      title: 'Featured for You',
      titleRight: Row(
        children: [
          OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              shape: CircleBorder(side: BorderSide(color: AppTheme.lightGray)),
              padding: EdgeInsets.zero,
            ),
            child: Icon(Icons.keyboard_arrow_left, size: 25),
          ),
          OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              shape: CircleBorder(side: BorderSide(color: AppTheme.lightGray)),
              padding: EdgeInsets.zero,
            ),
            child: Icon(Icons.keyboard_arrow_right, size: 25),
          ),
        ],
      ),
      child: ScrollableController(
        scrollDirection: Axis.horizontal,
        child: Row(
          spacing: 15,
          children: [
            _featureItem(Images.marketPlaceBiochemistry),
            _featureItem(Images.marketPlaceFlashcards),
            _featureItem(Images.marketPlaceOrganicChemistry),
            _featureItem(Images.marketPlaceSpanish),
          ],
        ),
      ),
    );
  }

  Widget _featureItem(String image) {
    return CustomCard(
      padding: EdgeInsets.zero,
      addBorder: true,
      width: 254,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: double.infinity,
            height: 144,
            child: ImagePlaceHolder(imagePath: image, isCardHeader: true),
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 15,
              children: [
                Text(
                  'Comprehensive MCAT Biochemistry Mind Map',
                  style: AppTheme.text.copyWith(
                    color: AppTheme.charcoalBlue,
                    fontSize: 16.0,
                    fontWeight: getFontWeight(500),
                  ),
                ),
                Text(
                  'by Dr. Sarah Johnson',
                  style: AppTheme.text.copyWith(
                    color: AppTheme.stormGray,
                    fontSize: 12.0,
                  ),
                ),

                SizedBox(
                  width: double.infinity,
                  child: Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    runSpacing: 10,
                    spacing: 10,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          StarRows(fullStars: 4, emptyStars: 0),
                          Text(
                            '(128)',
                            style: AppTheme.text.copyWith(
                              color: AppTheme.stormGray,
                              fontSize: 12.0,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        '\$24.99',
                        style: AppTheme.text.copyWith(
                          color: AppTheme.jungleGreen,
                          fontSize: 16.0,
                          fontWeight: getFontWeight(500),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _section({
    required String title,
    required Widget child,
    required Widget titleRight,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 15,
      children: [
        Row(
          spacing: 20,
          children: [
            Expanded(
              child: Text(
                title,
                style: AppTheme.text.copyWith(
                  fontSize: 20.0,
                  fontWeight: getFontWeight(500),
                ),
              ),
            ),
            titleRight,
          ],
        ),
        child,
      ],
    );
  }

  Widget _header() {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(child: _searchField()),
          VisibleController(
            mobile: false,
            tablet: true,
            child: Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: Row(
                spacing: 12,
                children: [
                  AppButton(
                    spacing: 10,
                    prefix: SVGImagePlaceHolder(
                      imagePath: Images.filter,
                      size: 16,
                      color: AppTheme.darkSlateGray,
                    ),
                    suffix: Container(
                      decoration: ShapeDecoration(
                        color: const Color(0xFFDBEAFE),
                        shape: CircleBorder(),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 3,
                      ),
                      child: Text(
                        '2',
                        textAlign: TextAlign.center,
                        style: AppTheme.text.copyWith(
                          color: AppTheme.persianBlue,
                          fontSize: 12.0,
                        ),
                      ),
                    ),
                    minHeight: 35,
                    onTap: () {},
                    text: 'Filter',
                    color: AppTheme.white,
                    borderColor: AppTheme.lightGray,
                    mainAxisSize: MainAxisSize.min,
                    textColor: AppTheme.darkSlateGray,
                  ),
                  AppButton(
                    spacing: 10,
                    prefix: SVGImagePlaceHolder(
                      imagePath: Images.filter,
                      size: 16,
                      color: AppTheme.darkSlateGray,
                    ),
                    suffix: Icon(
                      Icons.keyboard_arrow_down,
                      size: 26,
                      color: AppTheme.darkSlateGray,
                    ),
                    minHeight: 35,
                    onTap: () {},
                    text: 'Most Popular',
                    color: AppTheme.white,
                    borderColor: AppTheme.lightGray,
                    mainAxisSize: MainAxisSize.min,
                    textColor: AppTheme.darkSlateGray,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _searchField() {
    return CustomInputField(
      prefixIcon: Icon(Icons.search, color: AppTheme.slateGray, size: 20),
      hintText: 'Search for mind maps, flashcards, study guides...',
      fillColor: AppTheme.white,
      hintStyle: AppTheme.text.copyWith(
        color: AppTheme.slateGray,
        height: 1.43,
      ),
    );
  }
}
