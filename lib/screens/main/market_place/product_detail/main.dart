import 'package:navinotes/packages.dart';
import 'widgets.dart';
import 'vm.dart';

class ProductDetailMain extends StatelessWidget {
  const ProductDetailMain({super.key});

  @override
  Widget build(BuildContext context) {
    return ScrollableController(
      mobilePadding: const EdgeInsets.fromLTRB(10, 10, 10, 30),
      tabletPadding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
      child: Column(
        spacing: 30,
        children: [
          _overview(),
          _previewGallery(),
          _description(),
          _aboutCreator(),
          _customerReview(),
        ],
      ),
    );
  }

  Widget _customerReview() {
    return _section(
      title: 'Customer Reviews',
      titleRight: AppButton(
        onTap: () {},
        text: 'Write a Review',
        mainAxisSize: MainAxisSize.min,
        minHeight: 32,
        padding: const EdgeInsets.symmetric(horizontal: 15),
        color: AppTheme.strongBlue,
      ),
      spacing: 25,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            spacing: 15,
            children: [
              Column(
                children: [
                  Text(
                    '4.8',
                    textAlign: TextAlign.center,
                    style: AppTheme.text.copyWith(
                      fontSize: 36.0,
                      fontWeight: getFontWeight(700),
                    ),
                  ),
                  StarRows(fullStars: 5),
                  Text(
                    '124 reviews',
                    textAlign: TextAlign.center,
                    style: AppTheme.text.copyWith(color: AppTheme.steelMist),
                  ),
                ],
              ),
              Expanded(
                child: Column(
                  spacing: 10,
                  children: [
                    _reviewStarItem(starCount: 5, percentage: 85),
                    _reviewStarItem(starCount: 4, percentage: 10),
                    _reviewStarItem(starCount: 3, percentage: 4),
                    _reviewStarItem(starCount: 2, percentage: 1),
                    _reviewStarItem(starCount: 1, percentage: 0),
                  ],
                ),
              ),
            ],
          ),

          _reviewItem(),
          _divider(),
          _reviewItem(),
          _divider(),
          _reviewItem(),
          AppButton.text(
            onTap: () {},
            text: 'See All 124 Reviews',
            color: AppTheme.strongBlue,
          ),
        ],
      ),
    );
  }

  Widget _divider() {
    return Divider(color: AppTheme.lightAsh);
  }

  Widget _reviewItem() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Column(
        spacing: 15,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            spacing: 5,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                spacing: 20,
                children: [
                  Expanded(
                    child: Row(
                      spacing: 5,
                      children: [
                        ImagePlaceHolder.network(
                          size: 32,
                          imagePath:
                              'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTl8fHByb2ZpbGV8ZW58MHx8MHx8fDA%3D',
                        ),
                        Text(
                          'Sarah J.',
                          style: AppTheme.text.copyWith(
                            fontSize: 16.0,
                            fontWeight: getFontWeight(500),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    'March 15, 2025',
                    style: AppTheme.text.copyWith(color: AppTheme.steelMist),
                  ),
                ],
              ),
              StarRows(fullStars: 5),
              Text(
                'Completely transformed my MCAT studying',
                style: AppTheme.text.copyWith(
                  fontSize: 16.0,
                  fontWeight: getFontWeight(500),
                ),
              ),
            ],
          ),
          Text(
            'These mind maps are a game-changer! I was struggling to connect concepts across different biology topics, but these visual guides made everything click. The cell signaling and immune system maps especially helped me understand complex pathways. Worth every penny!',
            style: AppTheme.text.copyWith(color: AppTheme.darkSlateGray),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: ScrollableController(
              scrollDirection: Axis.horizontal,
              child: Row(
                spacing: 15,
                children: [
                  AppButton.text(
                    onTap: () {},
                    text: 'Helpful (24)',
                    color: AppTheme.steelMist,
                    prefix: SVGImagePlaceHolder(
                      imagePath: Images.like,
                      size: 14,
                    ),
                  ),
                  AppButton.text(
                    onTap: () {},
                    text: 'Report',
                    color: AppTheme.steelMist,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _reviewStarItem({required int starCount, required double percentage}) {
    return Row(
      spacing: 5,
      children: [
        Text(
          '$starCount★',
          style: AppTheme.text.copyWith(fontWeight: getFontWeight(500)),
        ),
        Expanded(
          child: LinearProgressIndicator(
            value: percentage / 100,
            backgroundColor: AppTheme.lightGray,
            borderRadius: BorderRadius.circular(100),
            minHeight: 8,
            color: AppTheme.orangeYellow,
          ),
        ),
        Text(
          '$percentage%',
          style: AppTheme.text.copyWith(color: AppTheme.steelMist),
        ),
      ],
    );
  }

  Widget _aboutCreator() {
    return _section(
      title: 'About the Creator',
      titleRight: AppButton(
        onTap: () {},
        text: 'Follow',
        mainAxisSize: MainAxisSize.min,
        minHeight: 32,
        padding: const EdgeInsets.symmetric(horizontal: 15),
        color: AppTheme.paleBlue,
        textColor: AppTheme.electricIndigo,
        prefix: SVGImagePlaceHolder(
          imagePath: Images.personPlus,
          size: 14,
          color: AppTheme.electricIndigo,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Column(
          spacing: 30,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _profile(),
            Column(
              spacing: 15,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'More from this Creator',
                  style: AppTheme.text.copyWith(
                    fontSize: 16.0,
                    fontWeight: getFontWeight(500),
                  ),
                ),
                ScrollableController(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    spacing: 20,
                    children: [
                      _creatorMoreItem(),
                      _creatorMoreItem(),
                      _creatorMoreItem(),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _creatorMoreItem() {
    return CustomCard(
      width: null,
      addBorder: true,
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 237,
            height: 96,
            child: ImagePlaceHolder(
              imagePath: Images.marketPlacePreview1,
              isCardHeader: true,
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              spacing: 5,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'MCAT Biochemistry Mind Maps',
                  style: AppTheme.text.copyWith(fontWeight: getFontWeight(500)),
                ),
                SizedBox(),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    StarRows(fullStars: 5),
                    Text(
                      '(87)',
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
                    color: AppTheme.charcoalBlue,
                    fontWeight: getFontWeight(500),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _profile() {
    return Row(
      spacing: 15,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ImagePlaceHolder.network(
          size: 64,
          imagePath:
              'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTl8fHByb2ZpbGV8ZW58MHx8MHx8fDA%3D',
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 5,
            children: [
              Text(
                'Dr. Michael Chen, Ph.D.',
                style: AppTheme.text.copyWith(
                  fontSize: 16.0,
                  fontWeight: getFontWeight(500),
                ),
              ),
              Text(
                'Biology Professor at Stanford University',
                style: AppTheme.text.copyWith(color: AppTheme.stormGray),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  'Specializing in creating visual learning tools for complex biology concepts. Former MCAT prep instructor with 15+ years of teaching experience. Author of "Visual Biology: Concepts and Connections".',
                  style: AppTheme.text.copyWith(color: AppTheme.darkSlateGray),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _description() {
    return _section(
      title: 'Description',
      child: Column(
        spacing: 20,
        children: [
          Text(
            'Comprehensive MCAT Biology Mind Map Bundle designed to help you visualize and connect key concepts for the MCAT exam. This bundle includes 15 detailed mind maps covering all major biology topics tested on the MCAT, with clear visual connections between related concepts.',
            style: AppTheme.text.copyWith(fontSize: 16.0, height: 1.0),
          ),
          Text(
            'Perfect for visual learners who want to understand the relationships between biological systems and processes. Each mind map is carefully designed to highlight high-yield information and commonly tested concepts.',
            style: AppTheme.text.copyWith(fontSize: 16.0, height: 1.0),
          ),

          ExpandableSection(
            title: 'What\'s Included',
            items: [
              '15 comprehensive mind maps in high resolution',
              'Interactive PDF format compatible with iPad and Apple Pencil',
              'Printable versions for offline study',
              '3 bonus quiz sheets to test your knowledge',
            ],
          ),
          ExpandableSection(
            title: 'Topics Covered',
            items: [
              'Cell Biology & Cell Structure',
              'Cellular Respiration & Photosynthesis',
              'DNA Replication & Protein Synthesis',
            ],
          ),
        ],
      ),
    );
  }

  Widget _previewItem(String image) {
    return Container(
      margin: EdgeInsets.only(right: 10),
      child: Stack(
        children: [
          Container(
            height: 158,
            decoration: ShapeDecoration(
              image: DecorationImage(
                image: AssetImage(image),
                fit: BoxFit.cover,
              ),
              shape: RoundedRectangleBorder(
                side: BorderSide(color: AppTheme.lightGray),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          Positioned(
            bottom: 10,
            left: 10,
            right: 10,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Flexible(
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppTheme.white,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    child: Row(
                      spacing: 5,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SVGImagePlaceHolder(
                          imagePath: Images.padlock,
                          size: 12,
                          color: AppTheme.darkSlateGray,
                        ),
                        Flexible(
                          child: Text(
                            'Preview',
                            style: AppTheme.text.copyWith(
                              color: AppTheme.darkSlateGray,
                              fontSize: 12.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _action({required VoidCallback onTap, required IconData icon}) {
    return InkWell(
      onTap: onTap,
      child: OutlinedChild(
        size: 32,
        decoration: BoxDecoration(
          color: AppTheme.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppTheme.black.withAlpha(0x19),
              blurRadius: 3,
              offset: Offset(0, 1),
              spreadRadius: 0,
            ),
            BoxShadow(
              color: AppTheme.black.withAlpha(0x19),
              blurRadius: 2,
              offset: Offset(0, 1),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Icon(icon, color: AppTheme.darkSlateGray),
      ),
    );
  }

  Widget _previewGallery() {
    return _section(
      title: 'Preview Gallery',
      child: Consumer<LayoutProviderVm>(
        builder: (_, layoutVm, _) {
          return Consumer<ProductDetailVm>(
            builder: (_, vm, _) {
              return Column(
                spacing: 15,
                children: [
                  Stack(
                    children: [
                      ExpandableCarousel(
                        options: ExpandableCarouselOptions(
                          controller: vm.carouselController,
                          viewportFraction: getDeviceResponsiveValue(
                            deviceType: layoutVm.deviceType,
                            mobile: 0.5,
                            tablet: 0.4,
                            laptop: 0.3,
                            largeDesktop: 0.2,
                          ),
                          showIndicator: false,
                          padEnds: false,
                        ),
                        items: [
                          _previewItem(Images.marketPlacePreview1),
                          _previewItem(Images.marketPlacePreview2),
                          _previewItem(Images.marketPlacePreview3),
                          _previewItem(Images.marketPlacePreview4),
                        ],
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        bottom: 0,
                        left: 0,
                        child: Row(
                          spacing: 15,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _action(
                              onTap: vm.goToPrevious,
                              icon: Icons.keyboard_arrow_left,
                            ),
                            _action(
                              onTap: vm.goToNext,
                              icon: Icons.keyboard_arrow_right,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  AppButton.text(
                    onTap: () {},
                    text: 'View Full-Screen Preview',
                    color: AppTheme.strongBlue,
                    prefix: SVGImagePlaceHolder(
                      imagePath: Images.capture,
                      color: AppTheme.strongBlue,
                      size: 14,
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget _section({
    required String title,
    required Widget child,
    Widget? titleRight,
    double spacing = 15,
  }) {
    return CustomCard(
      padding: EdgeInsets.all(20),
      child: Column(
        spacing: spacing,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            spacing: 15,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: AppTheme.text.copyWith(
                    fontSize: 20.0,
                    fontWeight: getFontWeight(700),
                  ),
                ),
              ),
              if (isNotNull(titleRight)) titleRight!,
            ],
          ),

          child,
        ],
      ),
    );
  }

  Widget _overviewImage() {
    return WidthLimiter(
      mobile: 300,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ImagePlaceHolder(
                  imagePath: Images.marketPlaceDetail,
                  borderRadius: BorderRadius.circular(0),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            left: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              spacing: 5,
              children: [
                SVGImagePlaceHolder(
                  imagePath: Images.padlock,
                  size: 12,
                  color: AppTheme.darkSlateGray,
                ),
                Flexible(
                  child: Text(
                    'Protected Content',
                    style: AppTheme.text.copyWith(
                      color: AppTheme.darkSlateGray,
                      fontSize: 12.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _overview() {
    return CustomCard(
      padding: EdgeInsets.all(20),
      addShadow: true,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            VisibleController(
              mobile: false,
              laptop: true,
              child: Padding(
                padding: const EdgeInsets.only(right: 20),
                child: _overviewImage(),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 15,
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      spacing: 10,
                      children: [
                        _tag('Mind Map'),
                        _tag('Biology'),
                        _tag('MCAT'),
                      ],
                    ),
                  ),
                  Text(
                    'MCAT Biology Complete Mind Map Bundle',
                    style: AppTheme.text.copyWith(
                      fontSize: 24.0,
                      fontWeight: getFontWeight(700),
                    ),
                  ),

                  Container(
                    decoration: ShapeDecoration(
                      color: AppTheme.lightMintGreen,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: AppTheme.whisperGrey),
                        borderRadius: BorderRadius.circular(9999),
                      ),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      spacing: 5,
                      children: [
                        Icon(
                          Icons.check_circle,
                          color: AppTheme.emeraldGreen,
                          size: 14,
                        ),
                        Flexible(
                          child: Text(
                            'Verified Content',
                            style: AppTheme.text.copyWith(
                              color: AppTheme.emeraldGreen,
                              fontSize: 12.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Row(
                    spacing: 10,
                    children: [
                      ImagePlaceHolder.network(
                        size: 32,
                        imagePath:
                            'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTl8fHByb2ZpbGV8ZW58MHx8MHx8fDA%3D',
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 5,
                          children: [
                            Text(
                              'Dr. Michael Chen',
                              style: AppTheme.text.copyWith(
                                fontWeight: getFontWeight(500),
                              ),
                            ),
                            Text(
                              'Biology Professor',
                              style: AppTheme.text.copyWith(
                                color: AppTheme.steelMist,
                                fontSize: 12.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  ScrollableController(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      spacing: 20,
                      children: [
                        Row(
                          spacing: 5,
                          children: [
                            StarRows(fullStars: 4, halfStars: 1),
                            Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: '4.8',
                                    style: AppTheme.text.copyWith(
                                      fontWeight: getFontWeight(500),
                                    ),
                                  ),
                                  TextSpan(
                                    text: ' (124 reviews)',
                                    style: AppTheme.text.copyWith(
                                      color: AppTheme.steelMist,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        Row(
                          spacing: 5,
                          children: [
                            SVGImagePlaceHolder(
                              imagePath: Images.upload4,
                              size: 14,
                              color: AppTheme.steelMist,
                            ),
                            Text(
                              '1,245 purchases',
                              style: AppTheme.text.copyWith(
                                color: AppTheme.steelMist,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  ScrollableController(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      spacing: 20,
                      children: [
                        Text(
                          '\$29.99',
                          style: AppTheme.text.copyWith(
                            color: AppTheme.charcoalBlue,
                            fontSize: 30.0,
                            fontWeight: getFontWeight(700),
                          ),
                        ),
                        Text(
                          '\$49.99',
                          style: AppTheme.text.copyWith(
                            color: AppTheme.steelMist,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),

                        CustomTag(
                          '40% OFF',
                          color: AppTheme.lightRed,
                          textColor: AppTheme.bloodFire,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ],
                    ),
                  ),

                  Row(
                    spacing: 15,
                    children: [
                      AppButton.secondary(
                        wrapWithFlexible: true,
                        onTap: () {},
                        text: 'Add to Cart',
                        color: AppTheme.vividRose,
                        prefix: SVGImagePlaceHolder(
                          imagePath: Images.shoppingCart2,
                          color: AppTheme.vividRose,
                          size: 18,
                        ),
                      ),
                      AppButton(
                        wrapWithFlexible: true,
                        onTap: () {},
                        text: 'Buy Now',
                        color: AppTheme.vividRose,
                        prefix: SVGImagePlaceHolder(
                          imagePath: Images.flash,
                          color: AppTheme.white,
                          size: 16,
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
  }

  Widget _tag(String data) {
    return CustomTag(
      data,
      color: AppTheme.paleBlue,
      textColor: AppTheme.electricIndigo,
    );
  }
}
