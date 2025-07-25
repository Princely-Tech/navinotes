import 'package:navinotes/packages.dart';
import 'package:navinotes/screens/main/market_place/seller_upload/details/vm.dart';
import 'package:navinotes/screens/main/market_place/seller_upload/widget/widget.dart';
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
  const SellerUploadMain({super.key, required this.vm});

  final SellerUploadVm vm;

  @override
  Widget build(BuildContext context) {
    return ScrollableController(
      mobilePadding: const EdgeInsets.only(bottom: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          progressHeader(2),
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
                          children: [_productDetails(vm), _preview()],
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
    return Column(
      spacing: 30,
      children: [
        const Divider(),

        // if _validationError is not null, show it
        if (vm.validationError != null)
          Text(
            vm.validationError!,
            style: AppTheme.text.copyWith(
              color: AppTheme.amber,
              fontSize: 12.0,
              height: 1.0,
            ),
          ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppButton(
              onTap: NavigationHelper.pop,
              text: 'Back to Content Selection',
              textColor: AppTheme.darkSlateGray,
              color: AppTheme.lightAsh,
              mainAxisSize: MainAxisSize.min,
              prefix: Icon(Icons.arrow_back, color: AppTheme.darkSlateGray),
            ),
            AppButton(
              onTap: () {
                 if (vm.validateForm()) {
                  // TODO: Navigate to Pricing & Terms screen
                  debugPrint('Form is valid, proceed to next step');
                }
              },
              wrapWithFlexible: true,
              mainAxisSize: MainAxisSize.min,
              text: 'Continue to Pricing & Terms',
              suffix: Icon(Icons.arrow_forward, color: AppTheme.white),
            ),
          ],
        ),
      ],
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
              GestureDetector(
                onTap: () => vm.pickCoverImage(),
                child: _imagePlusContainer(
                  height: 150, 
                  isExpandable: false,
                  image: vm.coverImage,
                ),
              ),
              AppButton(
                onTap: () => vm.pickCoverImage(),
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

  Widget _imagePlusContainer({
    double? height, 
    bool isExpandable = true,
    File? image,
  }) {
    return ExpandableController(
      mobile: isExpandable,
      child: GestureDetector(
        onTap: () {
          if (image != null) {
            vm.pickCoverImage();
          }
        },
        child: Container(
          decoration: BoxDecoration(
            color: AppTheme.lightAsh,
            borderRadius: BorderRadius.circular(8),
            image: image != null
                ? DecorationImage(
                    image: FileImage(image),
                    fit: BoxFit.cover,
                  )
                : null,
          ),
          height: height,
          width: double.infinity,
          child: image == null
              ? Center(
                  child: Icon(Icons.add, color: AppTheme.blueGray, size: 30),
                )
              : null,
        ),
      ),
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
                  for (int i = 0; i < 3; i++)
                    _previewImageItem(
                      index: i,
                      image: i < vm.previewImages.length ? vm.previewImages[i] : null,
                    ),
                ],
              ),
              if (vm.previewImages.length < 3)
                AppButton(
                  onTap: vm.addPreviewImage,
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

  Widget _previewImageItem({required int index, File? image}) {
    return Stack(
      children: [
        Container(
          width: 134,
          height: 134,
          decoration: BoxDecoration(
            color: image == null ? AppTheme.lightAsh : null,
            borderRadius: BorderRadius.circular(8),
            image: image != null
                ? DecorationImage(
                    image: FileImage(image),
                    fit: BoxFit.cover,
                  )
                : null,
          ),
          child: image == null
              ? Center(
                  child: Icon(Icons.add, color: AppTheme.blueGray, size: 30),
                )
              : null,
        ),
        if (image != null)
          Positioned(
            top: 5,
            right: 5,
            child: GestureDetector(
              onTap: () => vm.removePreviewImage(index),
              child: Container(
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ),
          ),
      ],
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
                    image: vm.coverImage != null
                        ? DecorationImage(
                            image: FileImage(vm.coverImage!),
                            fit: BoxFit.cover)
                        : null,
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 10,
                    children: [
                      Text(
                        (vm.titleController.text.isEmpty)
                            ? 'Sample Product Title'
                            : vm.titleController.text,
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
                                  text: ' ${SessionManager().getName()??'Your Name'}',
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

  Widget _productDetails(SellerUploadVm vm) {
    return _section(
      title: 'Product Details',
      child: Column(
        spacing: 25,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _inputWithFooter(
            child: CustomInputField(
              controller: vm.titleController,
              label: 'Product Title',
              hintText: 'Enter a clear, descriptive title',
              required: true,
              labelStyle: labelStyle,
            ),
            footer: '75 characters maximum',
          ),
          CustomInputField(
            onChanged: (value) {
              debugPrint('category changed: $value');
              vm.loadSubCategories(value);
              vm.categoryController.text = value;
            },
            controller: vm.categoryController,
            label: 'Category',
            hintText: 'Select a category',
            required: true,
            selectItems: vm.getCategories(),
            labelStyle: labelStyle,
          ),          
          CustomInputField(
            controller: vm.subCategoryController,
            label: 'Sub-Category',
            hintText: 'Select a sub-category',
            required: true,
            selectItems: vm.subCategories,
            labelStyle: labelStyle,
          ),
          _inputWithFooter(
            child: CustomInputField(
              onSubmitted: (value) {
                vm.addTag(value);
              },
              labelRight: Expanded(child: _alertIWidget(title: 'Tags')),
              hintText: 'Add tags. Enter to add.',
              labelStyle: labelStyle,
            ),
            footerWidget: (vm.tags.isEmpty)? Row(
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
                                  onTap: () {
                                    vm.addTag(str);
                                  },
                                ),
                              )
                              .toList(),
                    ),
                  ),
                ),
              ],
            ) : Row(
                      spacing: 10,
                      children: [
                        Text(
                          'Added:',
                          style: AppTheme.text.copyWith(
                            color: AppTheme.stormGray,
                            fontSize: 14.0,
                            height: 1.0,
                          ),
                        ),
                        Expanded(
                          child: ScrollableController(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              spacing: 12,
                              children:
                                  vm.tags.map(
                                        (str) => CustomTag(
                                          str,
                                          color: AppTheme.abyssTeal,
                                          textColor: AppTheme.lightAsh,
                                          prefix: Icon(Icons.close,
                                          size: 12,
                                          color: AppTheme.lightAsh,
                                          ),
                                          onTap: () {
                                            vm.removeTag(str);
                                          },
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
              required: true,
              controller: vm.descriptionController,
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
                selected: vm.included,
                onChanged: (value, checked) {
                  vm.includedClicked(value, checked);
                },
              ),
              _radioSelectSection(
                title: 'Target Audience',
                items: ['Beginners', 'Intermediate', 'Advanced', 'All Levels'],
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
    List<String>? selected,
    bool isCircle = false,
    Function(String, bool)? onChanged,
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
            value: selected?.contains(str) ?? false,
            onChanged: (value) {
              debugPrint('value: $value');
              onChanged?.call(str, value);
            },
          ),
        ),
      ],
    );
  }

Widget _radioSelectSection({
    required String title,
    required List<String> items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Header6(title: title, required: true, style: labelStyle),
        ...items.map(
          (str) => _radio(
            title: str,
            groupValue: vm.targetAudience,
            onChanged: (value) {
              vm.setTargetAudience(value!);
            },
          ),
        ),
      ],
    );
  }
Widget _radio({
    required String title,
    required String groupValue,
    required Function(String?) onChanged,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Radio<String>(
          value: title,
          groupValue: groupValue,
          onChanged: onChanged,
          activeColor: AppTheme.royalBlue,
        ),
        GestureDetector(
          onTap: () => onChanged(title),
          child: Text(title, style: TextStyle(color: Colors.black)),
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
}
