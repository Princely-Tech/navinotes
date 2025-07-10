import 'package:navinotes/packages.dart';
import 'aside.dart';

class FooterText {
  final String text;
  final bool isViviRose;
  FooterText({required this.text, this.isViviRose = false});
}

final labelStyle = AppTheme.text.copyWith(
  color: AppTheme.darkSlateGray,
  fontWeight: getFontWeight(500),
);

class SellerUploadMain extends StatelessWidget {
  const SellerUploadMain({super.key});

  @override
  Widget build(BuildContext context) {
    return ScrollableController(
      mobilePadding: const EdgeInsets.only(bottom: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _header(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 30,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ResponsivePadding(
                      mobile: EdgeInsets.symmetric(
                        horizontal: mobileHorPadding,
                      ),
                      laptop: EdgeInsets.symmetric(
                        horizontal: laptopHorPadding,
                      ),
                      desktop: EdgeInsets.symmetric(
                        horizontal: desktopHorPadding,
                      ),
                      largeDesktop: EdgeInsets.only(left: desktopHorPadding),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: CustomGrid(
                          largeDesktop: 2,
                          mobileSpacing: 40,
                          children: [_productDetails(), _preview()],
                        ),
                      ),
                    ),
                  ),
                  VisibleController(
                    mobile: false,
                    largeDesktop: true,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 30),
                      child: WidthLimiter(
                        mobile: 256,
                        largeDesktop: 300,
                        child: SellerUploadAside(isExpandable: false),
                      ),
                    ),
                  ),
                ],
              ),
              ResponsiveHorizontalPadding(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 30,
                  children: [_submitSection(), _footer()],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _footerItem({
    required String image,
    required String title,
    required List<FooterText> texts,
  }) {
    final style = AppTheme.text.copyWith(
      color: AppTheme.stormGray,

      height: 1.0,
    );
    final richStyle = style.copyWith(color: AppTheme.vividRose);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10,
      children: [
        SVGImagePlaceHolder(imagePath: image, color: AppTheme.vividRose),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 10,
            children: [
              Text(
                'Intellectual Property Rights',
                style: AppTheme.text.copyWith(
                  fontSize: 16.0,
                  fontWeight: getFontWeight(500),
                  height: 1.0,
                ),
              ),
              Text.rich(
                TextSpan(
                  children:
                      texts
                          .map(
                            (item) => TextSpan(
                              text: item.text,
                              style: item.isViviRose ? richStyle : style,
                            ),
                          )
                          .toList(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _footer() {
    return CustomCard(
      addBorder: true,
      decoration: BoxDecoration(color: AppTheme.whiteSmoke),
      child: CustomGrid(
        children: [
          _footerItem(
            image: Images.shield,
            texts: [
              FooterText(
                text:
                    'Your content is protected with watermarks and download restrictions to prevent unauthorized sharing.',
              ),
            ],
            title: 'Content Protection',
          ),
          _footerItem(
            image: Images.cIcon,
            texts: [
              FooterText(
                text: 'You retain all rights to your content. Review our ',
              ),
              FooterText(text: 'terms and conditions .', isViviRose: true),
            ],
            title: 'Intellectual Property Rights',
          ),
          _footerItem(
            image: Images.ribbon,
            texts: [
              FooterText(
                text:
                    'All content is reviewed for quality before being published.',
              ),
              FooterText(text: ' Learn more ', isViviRose: true),
              FooterText(text: 'about our standards.'),
            ],
            title: 'Quality Standards',
          ),
        ],
      ),
    );
  }

  Widget _submitSection() {
    return Container(
      padding: EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: AppTheme.lightGray)),
      ),
      child: Row(
        spacing: 10,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AppButton(
            onTap: NavigationHelper.pop,
            text: 'Back to Content Selection',
            textColor: AppTheme.darkSlateGray,
            color: AppTheme.lightAsh,
            mainAxisSize: MainAxisSize.min,
            wrapWithFlexible: true,
            prefix: Icon(Icons.arrow_back, color: AppTheme.darkSlateGray),
          ),
          AppButton(
            onTap: () {},
            wrapWithFlexible: true,
            mainAxisSize: MainAxisSize.min,
            text: 'Continue to Pricing & Terms',
            suffix: Icon(Icons.arrow_forward, color: AppTheme.white),
          ),
        ],
      ),
    );
  }

  Widget _preview() {
    return _section(
      title: 'Preview',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 30,
        children: [_coverImage(), _previewImages(), _previewSample()],
      ),
    );
  }

  Widget _previewSample() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 5,
      children: [
        Header6(title: 'How previews will appear to buyers'),
        CustomCard(
          addBorder: true,
          decoration: BoxDecoration(color: AppTheme.whiteSmoke),
          child: IntrinsicHeight(
            child: Row(
              spacing: 10,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  width: 96,
                  decoration: BoxDecoration(
                    color: AppTheme.lightAsh,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 10,
                    children: [
                      Text(
                        'Sample Product Title',
                        style: AppTheme.text.copyWith(
                          fontSize: 16.0,
                          fontWeight: getFontWeight(500),
                          height: 1.0,
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 5,
                        children: [
                          StarRowWithText(
                            text: '4.5 (0 reviews)',
                            starRows: StarRows(fullStars: 4, halfStars: 1),
                          ),
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: 'By',
                                  style: AppTheme.text.copyWith(
                                    color: AppTheme.darkSlateGray,
                                    height: 1.0,
                                  ),
                                ),
                                TextSpan(
                                  text: ' Your Name',
                                  style: AppTheme.text.copyWith(
                                    color: AppTheme.vividRose,
                                    height: 1.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.only(top: 5),
                        child: Wrap(
                          spacing: 20,
                          runSpacing: 5,
                          alignment: WrapAlignment.spaceBetween,
                          children: [
                            Text(
                              '\$0.00',
                              style: AppTheme.text.copyWith(
                                color: AppTheme.charcoalBlue,
                                fontWeight: getFontWeight(500),
                                height: 1.0,
                              ),
                            ),
                            Text(
                              'Preview Only',
                              style: AppTheme.text.copyWith(
                                color: AppTheme.steelMist,
                                fontSize: 12.0,
                                height: 1.0,
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
          ),
        ),
      ],
    );
  }

  Widget _previewImages() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 5,
      children: [
        _alertIWidget(title: 'Preview Images'),
        CustomCard(
          padding: EdgeInsets.all(15),
          dottedDecoration: DottedDecoration(),
          child: Column(
            spacing: 10,
            children: [
              Row(
                spacing: 10,
                children: [
                  _imagePlusContainer(height: 134),
                  _imagePlusContainer(height: 134),
                  _imagePlusContainer(height: 134),
                ],
              ),
              AppButton(
                onTap: () {},
                text: 'Upload Preview Image',
                mainAxisSize: MainAxisSize.min,
                prefix: SVGImagePlaceHolder(
                  imagePath: Images.upload,
                  size: 16,
                  color: AppTheme.white,
                ),
                style: AppTheme.text.copyWith(
                  color: Colors.white,
                  fontSize: 16.0,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _coverImage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 5,
      children: [
        Header6(title: 'Cover Image', required: true, style: labelStyle),
        CustomCard(
          padding: EdgeInsets.all(15),
          dottedDecoration: DottedDecoration(),
          child: Column(
            spacing: 10,
            children: [
              _imagePlusContainer(height: 150, isExpandable: false),
              AppButton(
                onTap: () {},
                text: 'Upload Cover Image',
                mainAxisSize: MainAxisSize.min,
                prefix: SVGImagePlaceHolder(
                  imagePath: Images.upload,
                  size: 16,
                  color: AppTheme.white,
                ),
                style: AppTheme.text.copyWith(
                  color: Colors.white,
                  fontSize: 16.0,
                ),
              ),
              Text(
                'Recommended size: 1200 x 800px, PNG or JPG',
                textAlign: TextAlign.center,
                style: AppTheme.text.copyWith(
                  color: AppTheme.steelMist,
                  fontSize: 12.0,
                  height: 1.0,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _imagePlusContainer({double? height, bool isExpandable = true}) {
    return ExpandableController(
      mobile: isExpandable,
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.lightAsh,
          borderRadius: BorderRadius.circular(8),
        ),
        height: height,
        width: double.infinity,
        child: Center(
          child: Icon(Icons.add, color: AppTheme.blueGray, size: 30),
        ),
      ),
    );
  }

  Widget _inputWithFooter({
    required Widget child,
    String? footer,
    Widget? footerWidget,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 5,
      children: [
        child,
        if (isNotNull(footerWidget)) footerWidget!,
        if (isNotNull(footer))
          Text(
            footer!,
            style: AppTheme.text.copyWith(
              color: AppTheme.steelMist,
              fontSize: 12.0,
              height: 1.0,
            ),
          ),
      ],
    );
  }

  Widget _productDetails() {
    return _section(
      title: 'Product Details',
      child: Column(
        spacing: 25,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _inputWithFooter(
            child: CustomInputField(
              label: 'Product Title',
              hintText: 'Enter a clear, descriptive title',
              required: true,
              labelStyle: labelStyle,
            ),
            footer: '75 characters maximum',
          ),
          CustomInputField(
            label: 'Category',
            hintText: 'Select a category',
            required: true,
            selectItems: [],
            labelStyle: labelStyle,
          ),
          CustomInputField(
            label: 'Sub-Category',
            hintText: 'Select a sub-category',
            required: true,
            selectItems: [],
            labelStyle: labelStyle,
          ),
          _inputWithFooter(
            child: CustomInputField(
              labelRight: Expanded(child: _alertIWidget(title: 'Tags')),
              hintText: 'Add tags separated by commas',
              labelStyle: labelStyle,
            ),
            footerWidget: Row(
              spacing: 10,
              children: [
                Text(
                  'Suggested:',
                  style: AppTheme.text.copyWith(
                    color: AppTheme.stormGray,
                    fontSize: 12.0,
                    height: 1.0,
                  ),
                ),
                Expanded(
                  child: ScrollableController(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      spacing: 12,
                      children:
                          ['mind map', 'visual learning', 'exam prep']
                              .map(
                                (str) => CustomTag(
                                  str,
                                  color: AppTheme.lightAsh,
                                  textColor: AppTheme.darkSlateGray,
                                ),
                              )
                              .toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
          _inputWithFooter(
            child: CustomInputField(
              label: 'Detailed Description',
              hintText:
                  'Describe your product in detail. What makes it valuable? How will it help users?',
              maxLines: 4,
            ),
            footer:
                'Be specific and detailed about what makes your content valuable',
          ),
          CustomGrid(
            mobile: 2,
            children: [
              _checkSelectSection(
                title: 'What\'s Included',
                items: [
                  'Mind Maps',
                  'Flashcards',
                  'Practice Questions',
                  'Study Guides',
                  'Other',
                ],
              ),
              _checkSelectSection(
                title: 'Target Audience',
                items: ['Beginners', 'Intermediate', 'Advanced', 'All Levels'],
                isCircle: true,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _checkSelectSection({
    required String title,
    required List<String> items,
    bool isCircle = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 5,
      children: [
        Header6(title: title, required: true, style: labelStyle),
        ...items.map(
          (str) => CustomCheckBoxItem(
            title: str,
            shape: isCircle ? CircleBorder() : null,
          ),
        ),
      ],
    );
  }

  Widget _alertIWidget({
    required String title,
    // required String content,
  }) {
    return Row(
      spacing: 5,
      children: [
        Text(title, style: labelStyle),
        SVGImagePlaceHolder(imagePath: Images.alertI, size: 12),
      ],
    );
  }

  Widget _section({required String title, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 15,
      children: [
        Text(
          title,
          style: AppTheme.text.copyWith(
            fontSize: 20.0,
            fontWeight: FontWeight.w700,
          ),
        ),
        child,
      ],
    );
  }

  Widget _header() {
    return Container(
      color: AppTheme.whiteSmoke,
      padding: EdgeInsets.symmetric(vertical: 15),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: ResponsiveHorizontalPadding(
          child: Stack(
            children: [
              Positioned(
                top: 15,
                left: 0,
                right: 0,
                child: Container(color: AppTheme.vividRose, height: 4),
              ),
              Row(
                spacing: 5,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _headerItem(
                    title: 'Content Selection',
                    count: 1,
                    check: true,
                  ),
                  _headerItem(title: 'Details & Preview', count: 2),
                  _headerItem(count: 3, title: 'Pricing & Terms'),
                  _headerItem(count: 4, title: 'Review & Submit'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _headerItem({
    required String title,
    bool check = false,
    required int count,
  }) {
    return Flexible(
      child: Column(
        spacing: 5,
        children: [
          OutlinedChild(
            size: 32,
            decoration: BoxDecoration(
              color: AppTheme.vividRose,
              shape: BoxShape.circle,
            ),
            child:
                check
                    ? Icon(Icons.check, color: AppTheme.white)
                    : Text(
                      '2',
                      style: AppTheme.text.copyWith(
                        color: Colors.white,
                        fontSize: 16.0,
                        fontWeight: getFontWeight(500),
                      ),
                    ),
          ),

          Text(
            title,
            textAlign: TextAlign.center,
            style: AppTheme.text.copyWith(
              color: AppTheme.vividRose,
              fontWeight: getFontWeight(500),
              height: 1.0,
            ),
          ),
        ],
      ),
    );
  }
}
