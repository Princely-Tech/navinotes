import 'package:flutter/material.dart';
import 'package:navinotes/packages.dart';
import 'package:navinotes/screens/main/market_place/seller_upload/details/aside.dart';
import 'package:navinotes/screens/main/market_place/seller_upload/details/vm.dart';

import '../widget/widget.dart';

class SellerUploadPrice extends StatelessWidget {
  const SellerUploadPrice({super.key, required this.vm});

  final SellerUploadVm vm;

  @override
  Widget build(BuildContext context) {
    return ScrollableController(
      mobilePadding: const EdgeInsets.only(bottom: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          progressHeader(3),
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
                        child: _pricingForm(),
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

  Widget _pricingForm() {
    return Form(
      key: vm.priceFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 30,
        children: [
          _priceSection(),
          _termsSection(),
        ],
      ),
    );
  }

  Widget _priceSection() {
    return _section(
      title: 'Pricing',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 20,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: CustomInputField(
                  controller: vm.priceController,
                  label: 'Price (\$)', 
                  hintText: 'Enter price',
                  keyboardType: TextInputType.number,
                  prefixIcon: Text(
                    '\$',
                    style: AppTheme.text.copyWith(
                      color: AppTheme.darkSlateGray,
                      fontSize: 16.0,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a price';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 20),
             
            ],
          ),
        
        ],
      ),
    );
  }
  Widget _termsSection() {
    return _section(
      title: 'Terms & Conditions',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 15,
        children: [
          CustomCheckBoxItem(
            title: 'I agree to the NaviNotes Marketplace Terms of Service',
            onChanged: (value) => vm.setAgreeToTerms(value),
          ),
          CustomCheckBoxItem  (
            onChanged: (value) => vm.setAgreeToRefundPolicy(value),
            title: 'I agree to the NaviNotes Refund Policy',
          ),
          CustomCheckBoxItem(
            onChanged: (value) => vm.setAgreeToCopyrightPolicy(value ?? false),
            title: 'I confirm that I have the right to sell this content',
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppButton(
              onTap: () {
                // TODO: Navigate back to previous screen
                //Navigator.pop(context);
              },
              text: 'Back to Details',
              textColor: AppTheme.darkSlateGray,
              color: AppTheme.lightAsh,
              mainAxisSize: MainAxisSize.min,
              prefix: Icon(Icons.arrow_back, color: AppTheme.darkSlateGray),
            ),
            AppButton(
              onTap: () {
                if (vm.validatePriceForm()) {
                  // TODO: Submit the form and navigate to success screen
                  debugPrint('Price form is valid, submitting...');
                }
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