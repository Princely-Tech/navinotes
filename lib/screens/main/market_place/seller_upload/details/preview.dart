import 'package:flutter/material.dart';
import 'package:navinotes/packages.dart';
import 'package:navinotes/screens/main/market_place/seller_upload/details/aside.dart';
import 'package:navinotes/screens/main/market_place/seller_upload/details/vm.dart';
import '../widget/widget.dart';

class SellerUploadPreview extends StatelessWidget {
  const SellerUploadPreview({super.key, required this.vm});

  final SellerUploadVm vm;

  @override
  Widget build(BuildContext context) {
    return ScrollableController(
      mobilePadding: const EdgeInsets.only(bottom: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          progressHeader(4),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 30,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ResponsivePadding(
                      mobile: EdgeInsets.symmetric(horizontal: mobileHorPadding),
                      laptop: EdgeInsets.symmetric(horizontal: laptopHorPadding),
                      desktop: EdgeInsets.symmetric(horizontal: desktopHorPadding),
                      largeDesktop: EdgeInsets.only(left: desktopHorPadding),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: _previewContent(),
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
                child: _submitSection(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _previewContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _section(
          title: 'Preview',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: 8,
                            children: [
                              Text(
                                vm.titleController.text.isNotEmpty
                                    ? vm.titleController.text
                                    : 'Your title here',
                                style: AppTheme.text.copyWith(
                                  color: AppTheme.darkSlateGray,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16.0,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                'By ${vm.board.name}',
                                style: AppTheme.text.copyWith(
                                  color: AppTheme.stormGray,
                                  fontSize: 12.0,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                vm.descriptionController.text.isNotEmpty
                                    ? vm.descriptionController.text
                                    : 'A brief description of your content will appear here',
                                style: AppTheme.text.copyWith(
                                  color: AppTheme.stormGray,
                                  fontSize: 12.0,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const Spacer(),
                              if (vm.priceController.text.isNotEmpty)
                                Text(
                                  '\$${vm.priceController.text} USD',
                                  style: AppTheme.text.copyWith(
                                    color: AppTheme.vividRose,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16.0,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (vm.tags.isNotEmpty) ...[
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: vm.tags
                      .map((tag) => Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.lightAsh,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              '#$tag',
                              style: AppTheme.text.copyWith(
                                color: AppTheme.darkSlateGray,
                                fontSize: 12.0,
                              ),
                            ),
                          ))
                      .toList(),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 30),
        _section(
          title: 'Pricing',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomCard(
                addBorder: true,
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Price Details',
                      style: AppTheme.text.copyWith(
                        color: AppTheme.darkSlateGray,
                        fontWeight: FontWeight.w600,
                        fontSize: 16.0,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Content Price',
                          style: AppTheme.text.copyWith(
                            color: AppTheme.stormGray,
                            fontSize: 14.0,
                          ),
                        ),
                        Text(
                          '\$${vm.priceController.text} USD',
                          style: AppTheme.text.copyWith(
                            color: AppTheme.darkSlateGray,
                            fontWeight: FontWeight.w600,
                            fontSize: 14.0,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Divider(height: 1, color: AppTheme.lightGray),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Platform Fee (10%)',
                          style: AppTheme.text.copyWith(
                            color: AppTheme.stormGray,
                            fontSize: 14.0,
                          ),
                        ),
                        Text(
                          '\$${((double.tryParse(vm.priceController.text) ?? 0) * 0.1).toStringAsFixed(2)} USD',
                          style: AppTheme.text.copyWith(
                            color: AppTheme.darkSlateGray,
                            fontSize: 14.0,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Divider(height: 1, color: AppTheme.lightGray),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'You Will Receive',
                          style: AppTheme.text.copyWith(
                            color: AppTheme.darkSlateGray,
                            fontWeight: FontWeight.w600,
                            fontSize: 14.0,
                          ),
                        ),
                        Text(
                          '\$${((double.tryParse(vm.priceController.text) ?? 0) * 0.9).toStringAsFixed(2)} USD',
                          style: AppTheme.text.copyWith(
                            color: AppTheme.vividRose,
                            fontWeight: FontWeight.w600,
                            fontSize: 16.0,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'The platform fee covers payment processing and marketplace maintenance.',
                style: AppTheme.text.copyWith(
                  color: AppTheme.stormGray,
                  fontSize: 12.0,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _submitSection() {
    return Column(
      spacing: 30,
      children: [
        const Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppButton(
              onTap: () {
               vm.setScreen(Screen.price);
              },
              text: 'Back to Pricing',
              textColor: AppTheme.darkSlateGray,
              color: AppTheme.lightAsh,
              mainAxisSize: MainAxisSize.min,
              prefix: Icon(Icons.arrow_back, color: AppTheme.darkSlateGray),
            ),
            vm.isPublishing
                ? Center(
                    child: Column(
                      children: [
                        const CircularProgressIndicator(),
                        const SizedBox(height: 8),
                        Text(
                         vm.publishingStatus,
                          style: AppTheme.text.copyWith(
                            color: AppTheme.darkSlateGray,
                            fontSize: 12.0,
                          ),
                        ),
                      ],
                    ),
                  )
                : AppButton(
                  onTap: () {
                    debugPrint('Publishing content...');
                    vm.publish();
                  },
                  text: 'Publish Now',
                  mainAxisSize: MainAxisSize.min,
                  suffix: Icon(Icons.cloud_upload, color: AppTheme.white),
                ),
          ],
        ),

      ],
    );
  }

  Widget _section({
    required String title,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Header6(title: title),
        const SizedBox(height: 15),
        child,
      ],
    );
  }
}
