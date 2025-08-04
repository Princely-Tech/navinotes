import 'package:navinotes/packages.dart';
import 'widgets.dart';
import 'vm.dart';

class ProductDetailMain extends StatelessWidget {
  const ProductDetailMain({super.key, required this.vm});

  final ProductDetailVm vm;

  @override
  Widget build(BuildContext context) {
    return ScrollableController(
      mobilePadding: const EdgeInsets.fromLTRB(10, 10, 10, 30),
      tabletPadding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
      child: Column(
        spacing: 30,
        children: [
          _overview(),
          _previewGallery(context),
          _description(),
          _aboutCreator(),
          _customerReviewNone(),
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

Widget _customerReviewNone() {
    return _section(
      title: 'Customer Reviews',
      // titleRight: AppButton(
      //   onTap: () {},
      //   text: 'Write a Review',
      //   mainAxisSize: MainAxisSize.min,
      //   minHeight: 32,
      //   padding: const EdgeInsets.symmetric(horizontal: 15),
      //   color: AppTheme.strongBlue,
      // ),
      spacing: 25,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
         Text('No reviews yet'),
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
      // titleRight: AppButton(
      //   onTap: () {},
      //   text: 'Follow',
      //   mainAxisSize: MainAxisSize.min,
      //   minHeight: 32,
      //   padding: const EdgeInsets.symmetric(horizontal: 15),
      //   color: AppTheme.paleBlue,
      //   textColor: AppTheme.electricIndigo,
      //   prefix: SVGImagePlaceHolder(
      //     imagePath: Images.personPlus,
      //     size: 14,
      //     color: AppTheme.electricIndigo,
      //   ),
      // ),
      child: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Column(
          spacing: 30,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _profile(),
            // TODO: Get from backend
            // Column(
            //   spacing: 15,
            //   crossAxisAlignment: CrossAxisAlignment.start,
            //   children: [
            //     Text(
            //       'More from this Creator',
            //       style: AppTheme.text.copyWith(
            //         fontSize: 16.0,
            //         fontWeight: getFontWeight(500),
            //       ),
            //     ),
            //     ScrollableController(
            //       scrollDirection: Axis.horizontal,
            //       child: Row(
            //         spacing: 20,
            //         children: [
            //           _creatorMoreItem(),
            //           _creatorMoreItem(),
            //           _creatorMoreItem(),
            //         ],
            //       ),
            //     ),
            //   ],
            // ),
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

  Widget _authorImage(double size) {
    return (vm.product.authorImage != null)
        ? ImagePlaceHolder.network(
          size: size,
          imagePath: vm.product.authorImage ?? '',
        )
        : Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppTheme.whisperGrey, width: 2),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: SVGImagePlaceHolder(imagePath: Images.avatar, size: size),
          ),
        );
  }

  Widget _profile() {
    return Row(
      spacing: 15,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _authorImage(64),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 5,
            children: [
              Text(
                vm.product.author,
                style: AppTheme.text.copyWith(
                  fontSize: 16.0,
                  fontWeight: getFontWeight(500),
                ),
              ),
              Text(
                vm.product.getAuthorTitle(),
                style: AppTheme.text.copyWith(color: AppTheme.stormGray),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  vm.product.authorAbout??'',
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
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 20,
        children: [
          Text(
            textAlign: TextAlign.justify,
            vm.product.description,
            style: AppTheme.text.copyWith(fontSize: 16.0, height: 1.0),
          ),
          ExpandableSection(
            title: 'What\'s Included',
            items: vm.product.whatsIncluded,
          ),
        ],
      ),
    );
  }

  Widget _previewItem(String image, BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return Dialog.fullscreen(
              child: Stack(
                children: [
                  Center(
                    child: InteractiveViewer(
                      panEnabled: true,
                      minScale: 0.5,
                      maxScale: 4.0,
                      child: Image.network(
                        EnvironmentConfig.fileUrl + "/$image",
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 20,
                    right: 20,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.3),
                            spreadRadius: 2,
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: IconButton(
                        icon: Icon(Icons.close, color: Colors.white, size: 30),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.black54,
                          padding: EdgeInsets.all(8),
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
      child: Container(
        margin: EdgeInsets.only(right: 10),
        child: Stack(
          children: [
            Container(
              height: 158,
              decoration: ShapeDecoration(
                image: DecorationImage(
                  image: NetworkImage("${EnvironmentConfig.fileUrl}/$image"),
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
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Icon(Icons.zoom_in, color: Colors.white, size: 16),
                  ),
                ],
              ),
            ),
          ],
        ),
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

  Widget _previewGallery(BuildContext context) {
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
                        items:
                            vm.product.previewImagesPaths
                                .map((image) => _previewItem(image, context))
                                .toList(),
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
                  type: ImagePlaceHolderTypes.network,
                  imagePath: vm.product.coverImagePath,
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
                      children:
                          vm.product.tags.map((tag) => _tag(tag)).toList(),
                    ),
                  ),
                  Text(
                    vm.product.title,
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
                      _authorImage(32),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 5,
                          children: [
                            Text(
                              vm.product.author,
                              style: AppTheme.text.copyWith(
                                fontWeight: getFontWeight(500),
                              ),
                            ),
                            Text(
                              vm.product.authorIam??'',
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
                                    text: vm.product.rating.toStringAsFixed(1),
                                    style: AppTheme.text.copyWith(
                                      fontWeight: getFontWeight(500),
                                    ),
                                  ),
                                  TextSpan(
                                    text:
                                        ' (${vm.product.ratingCount} reviews)',
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
                              '${vm.product.ratingCount} purchases',
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
                          '\$${vm.product.getAmount()}',
                          style: AppTheme.text.copyWith(
                            color: AppTheme.charcoalBlue,
                            fontSize: 30.0,
                            fontWeight: getFontWeight(700),
                          ),
                        ),

                        if (vm.product.discountPercent != null &&
                            vm.product.discountPercent! > 0)
                          Text(
                            '\$${vm.product.getOriginalAmount().toStringAsFixed(2)}',
                            style: AppTheme.text.copyWith(
                              color: AppTheme.steelMist,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),

                        if (vm.product.discountPercent != null &&
                            vm.product.discountPercent! > 0)
                          CustomTag(
                            '${vm.product.discountPercent!.toStringAsFixed(0)}% OFF',
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
                        onTap: () {
                          vm.addToCart();
                        },
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
