import 'package:navinotes/packages.dart';

class ProductDetailAside extends StatelessWidget {
  const ProductDetailAside({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(15),
      child: Column(
        children: [
          VisibleController(
            mobile: true,
            laptop: false,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 25),
              child: _searchField(),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 25,
            children: [_productDetails(), _mayLike(), _recentlyViewed()],
          ),
        ],
      ),
    );
  }

  Widget _searchField() {
    return CustomInputField(
      prefixIcon: Icon(Icons.search, color: AppTheme.blueGray, size: 20),
      hintText: 'Search marketplace',
      hintStyle: AppTheme.text.copyWith(
        color: AppTheme.slateGray,
        height: 1.43,
      ),
    );
  }

  Widget _recentlyViewed() {
    return _sections(
      title: 'Recently Viewed',
      child: Padding(
        padding: const EdgeInsets.only(top: 5),
        child: Column(
          spacing: 15,
          children: [
            _recentItem(Images.marketPlacePreview1),
            _recentItem(Images.marketPlacePreview4, addDivider: false),
          ],
        ),
      ),
    );
  }

  Widget _recentItem(String imagePath, {bool addDivider = true}) {
    return Column(
      spacing: 15,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 15,
          children: [
            Container(
              height: 64,
              width: 64,
              decoration: ShapeDecoration(
                color: AppTheme.lightGray,
                image: DecorationImage(
                  image: AssetImage(imagePath),
                  fit: BoxFit.cover,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            Expanded(
              child: Column(
                spacing: 10,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Organic Chemistry Mechanisms',
                    style: AppTheme.text.copyWith(
                      fontWeight: getFontWeight(500),
                      height: 1.0,
                    ),
                  ),
                  Text(
                    '\$22.99',
                    style: AppTheme.text.copyWith(
                      color: AppTheme.charcoalBlue,
                      fontWeight: getFontWeight(500),
                      height: 1.0,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        if (addDivider) _divider(),
      ],
    );
  }

  Widget _mayLikeItem(String imagePath, {bool addDivider = true}) {
    return Consumer<LayoutProviderVm>(
      builder: (_, layoutVm, _) {
        double imgSize = getDeviceResponsiveValue(
          deviceType: layoutVm.deviceType,
          mobile: 60,
          laptop: 80,
        );
        return Column(
          spacing: 15,
          children: [
            Row(
              spacing: 15,
              children: [
                Container(
                  height: imgSize,
                  width: imgSize,
                  decoration: ShapeDecoration(
                    color: AppTheme.lightGray,
                    image: DecorationImage(
                      image: AssetImage(imagePath),
                      fit: BoxFit.cover,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    spacing: 10,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'MCAT General Chemistry Mind Maps',
                        style: AppTheme.text.copyWith(
                          fontWeight: getFontWeight(500),
                          height: 1.0,
                        ),
                      ),
                      Wrap(
                        children: [
                          StarRows(fullStars: 4, halfStars: 1),
                          Text(
                            '(98)',
                            style: AppTheme.text.copyWith(
                              color: const Color(0xFF6B7280),
                              fontSize: 12.0,
                              height: 1.0,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        '\$24.99',
                        style: AppTheme.text.copyWith(
                          color: AppTheme.charcoalBlue,
                          fontWeight: getFontWeight(500),
                          height: 1.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (addDivider) _divider(),
          ],
        );
      },
    );
  }

  Widget _mayLike() {
    return _sections(
      title: 'You may also like',
      child: Padding(
        padding: const EdgeInsets.only(top: 5),
        child: Column(
          spacing: 15,
          children: [
            _mayLikeItem(Images.marketPlacePreview1),
            _mayLikeItem(Images.marketPlacePreview2),
            _mayLikeItem(Images.marketPlacePreview3),
            _mayLikeItem(Images.marketPlacePreview4, addDivider: false),
          ],
        ),
      ),
    );
  }

  Widget _divider() {
    return Divider(height: 1.0, color: AppTheme.lightAsh);
  }

  Widget _detailItem({
    required String title,
    required String value,
    bool addDivider = true,
  }) {
    return Column(
      spacing: 15,
      children: [
        Row(
          spacing: 10,
          children: [
            Text(
              title,
              style: AppTheme.text.copyWith(
                color: AppTheme.stormGray,
                fontSize: 16.0,
                height: 1.0,
              ),
            ),
            Expanded(
              child: Text(
                value,
                textAlign: TextAlign.right,
                style: AppTheme.text.copyWith(
                  fontSize: 16.0,
                  fontWeight: getFontWeight(500),
                  height: 1.0,
                ),
              ),
            ),
          ],
        ),
        if (addDivider) _divider(),
      ],
    );
  }

  Widget _flagItem({required String title, required String imagePath}) {
    return Row(
      spacing: 10,
      children: [
        SVGImagePlaceHolder(
          imagePath: imagePath,
          size: 14,
          color: AppTheme.vividRose,
        ),
        Expanded(
          child: Text(
            title,
            style: AppTheme.text.copyWith(color: AppTheme.stormGray, height: 1.0),
          ),
        ),
      ],
    );
  }

  Widget _productDetails() {
    return _sections(
      title: 'Product Details',
      child: Padding(
        padding: const EdgeInsets.only(top: 5),
        child: Column(
          spacing: 20,
          children: [
            _detailItem(title: 'Content Type', value: 'Mind Map Bundle'),
            _detailItem(title: 'Number of Maps', value: '15 maps'),
            _detailItem(title: 'Compatible With', value: 'iPad, Apple Pencil'),
            _detailItem(title: 'Last Updated', value: 'April 12, 2025'),
            _detailItem(title: 'File Size', value: '48.7 MB'),
            _detailItem(title: 'Language', value: 'English'),
            _detailItem(
              title: 'Publisher',
              value: 'NueroNote Marketplace',
              addDivider: false,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 5),
              child: _divider(),
            ),
            Column(
              spacing: 15,
              children: [
                _flagItem(
                  title: 'Secure payment processing',
                  imagePath: Images.shield,
                ),
                _flagItem(
                  title: '30-day satisfaction guarantee',
                  imagePath: Images.refresh,
                ),
                _flagItem(
                  title: 'Copyright protected content',
                  imagePath: Images.padlock,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _sections({required Widget child, required String title}) {
    return CustomCard(
      addShadow: true,
      padding: EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 15,
        children: [
          Text(
            title,
            style: AppTheme.text.copyWith(
              fontSize: 18.0,
              fontWeight: FontWeight.w700,
            ),
          ),
          child,
        ],
      ),
    );
  }
}
