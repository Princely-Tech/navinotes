import 'package:navinotes/packages.dart';
import 'vm.dart';

class MyPurchasesMain extends StatelessWidget {
  const MyPurchasesMain({super.key});

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
            ),
          ),
        ],
      ),
    );
  }

  Widget _contentItem(String image) {
    return Consumer<MyPurchasesVm>(
      builder: (_, vm, _) {
        final richTextStyle = AppTheme.text.copyWith(
          color: AppTheme.steelMist,
          height: 1.0,
        );

        final isImported = Random().nextBool();
        String tagText = getRandomListElement([
          'Mind Map',
          'FlashCards',
          'Study Guide',
        ]);
        Color tagColor = AppTheme.vividRose;
        String tagIcon = Images.connection2;
        switch (tagText) {
          case 'FlashCards':
            tagColor = AppTheme.electricPurple;
            tagIcon = Images.stack;
            break;
          case 'Study Guide':
            tagColor = AppTheme.jungleGreen;
            tagIcon = Images.book2;
            break;
        }
        return CustomCard(
          padding: EdgeInsets.zero,
          addBorder: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  AspectRatio(
                    aspectRatio: 3,
                    child: ImagePlaceHolder(
                      imagePath: image,
                      isCardHeader: true,
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: CustomTag(
                      tagText,
                      prefix: SVGImagePlaceHolder(
                        imagePath: tagIcon,
                        color: AppTheme.white,
                        size: 13,
                      ),
                      color: tagColor,
                      textColor: AppTheme.white,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  if (isImported)
                    Positioned(
                      bottom: 10,
                      left: 10,
                      child: CustomTag(
                        'Imported',
                        prefix: Icon(
                          Icons.check_circle,
                          color: AppTheme.deepTealGreen,
                          size: 16,
                        ),
                        color: AppTheme.lightMintGreen,
                        textColor: AppTheme.deepTealGreen,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 15,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 15,
                      children: [
                        Row(
                          spacing: 15,
                          children: [
                            Expanded(
                              child: Text(
                                'Advanced Biology Concepts',
                                style: AppTheme.text.copyWith(
                                  fontSize: 16.0,
                                  fontWeight: getFontWeight(500),
                                  height: 1.0,
                                ),
                              ),
                            ),
                            Icon(Icons.more_vert, color: AppTheme.blueGray),
                          ],
                        ),
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: 'By Dr. Emily Chen',
                                style: richTextStyle,
                              ),
                              TextSpan(
                                text: ' • ',
                                style: AppTheme.text.copyWith(
                                  color: AppTheme.steelMist,

                                  height: 1.0,
                                ),
                              ),
                              TextSpan(
                                text: 'Apr 12, 2025',
                                style: richTextStyle,
                              ),
                            ],
                          ),
                        ),
                        StarRowWithText(
                          text: '4.5',
                          starRows: StarRows(fullStars: 4, halfStars: 1),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      spacing: 10,
                      children: [
                        AppButton(
                          onTap: () {},
                          text: 'Open',
                          wrapWithFlexible: true,
                          minHeight: 38,
                          prefix: SVGImagePlaceHolder(
                            imagePath: Images.folder,
                            size: 17,
                            color: AppTheme.white,
                          ),
                          style: AppTheme.text.copyWith(
                            color: Colors.white,
                            fontWeight: getFontWeight(500),
                          ),
                        ),
                        AppButton(
                          onTap: () {},
                          text: 'Import',
                          wrapWithFlexible: true,
                          borderColor: AppTheme.paleJade,
                          color: AppTheme.honeyDew,
                          minHeight: 38,
                          prefix: SVGImagePlaceHolder(
                            imagePath:
                                Images.uploadFile, //TODO doesnt match design
                            size: 17,
                            color: AppTheme.emeraldGreen,
                          ),
                          style: AppTheme.text.copyWith(
                            color: AppTheme.emeraldGreen,
                            fontWeight: getFontWeight(500),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _header() {
    return CustomCard(
      padding: EdgeInsets.all(10),
      child: IntrinsicHeight(
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
                    WidthLimiter(
                      mobile: 149,
                      child: CustomInputField(
                        fillColor: AppTheme.whiteSmoke,
                        controller: TextEditingController(text: 'All Types'),
                        selectItems: ['All Types'],
                      ),
                    ),
                    WidthLimiter(
                      mobile: 120,
                      child: CustomInputField(
                        fillColor: AppTheme.whiteSmoke,
                        controller: TextEditingController(text: 'Recent'),
                        selectItems: ['Recent', 'Most Popular'],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: AppTheme.lightAsh,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: EdgeInsets.all(10),
                      child: Row(
                        spacing: 15,
                        children: [
                          CustomCard(
                            width: null,
                            addShadow: true,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            padding: EdgeInsets.symmetric(
                              vertical: 5,
                              horizontal: 10,
                            ),
                            child: SVGImagePlaceHolder(
                              imagePath: Images.ques2,
                              size: 18,
                              color: AppTheme.vividRose,
                            ),
                          ),
                          SVGImagePlaceHolder(
                            imagePath: Images.menu,
                            size: 18,
                            color: AppTheme.steelMist,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _searchField() {
    return CustomInputField(
      prefixIcon: Icon(Icons.search, color: AppTheme.slateGray, size: 20),
      hintText: 'Search my purchased content...',
      fillColor: AppTheme.white,
      hintStyle: AppTheme.text.copyWith(
        color: AppTheme.slateGray,
        fontSize: 16.0,
        height: 1.50,
      ),
    );
  }
}
