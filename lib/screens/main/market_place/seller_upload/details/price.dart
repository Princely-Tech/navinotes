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
          Text(
            'Enter the price buyers will pay. You can optionally set a discount percentage to show the original price.',
            style: AppTheme.text.copyWith(
              color: AppTheme.darkSlateGray.withOpacity(0.7),
              fontSize: 14.0,
            ),
          ),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: CustomInputField(
                  controller: vm.priceController,
                  label: 'Price (\$)', 
                  hintText: 'Enter price',
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  onChanged: (value){
                    vm.notifyChange();
                  },
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
                    if (double.parse(value) <= 0) {
                      return 'Price must be greater than 0';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 20),
              SizedBox(
                width: 120,
                child: CustomInputField(
                  controller: vm.discountController,
                  label: 'Discount %',
                  hintText: '0',
                  keyboardType: TextInputType.number,
                  onChanged: (value) => vm.notifyListeners(),
                  suffixIcon: Text(
                    '%',
                    style: AppTheme.text.copyWith(
                      color: AppTheme.darkSlateGray,
                      fontSize: 16.0,
                    ),
                  ),
                  validator: (value) {
                    if (value != null && value.isNotEmpty) {
                      final discount = int.tryParse(value) ?? 0;
                      if (discount < 0 || discount > 100) {
                        return '0-100';
                      }
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
          if (vm.price > 0)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (vm.discount > 0) ...[
                  const SizedBox(height: 8),
                  Text(
                    'Original Price: \$${vm.originalPrice}',
                    style: AppTheme.text.copyWith(
                      decoration: TextDecoration.lineThrough,
                      color: AppTheme.darkSlateGray.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${vm.discount}% OFF',
                    style: AppTheme.text.copyWith(
                      color: AppTheme.asbestos,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
                const SizedBox(height: 4),
                Text(
                  'Buyers will pay: \$${vm.price.toStringAsFixed(2)}',
                  style: AppTheme.text.copyWith(
                    color: AppTheme.darkSlateGray,
                    fontWeight: FontWeight.bold,
                  ),
                ),
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
            value: vm.agreeToTerms,
            title: 'I agree to the NaviNotes Marketplace Terms of Service',
            onChanged: (value) => vm.setAgreeToTerms(value),
          ),
          CustomCheckBoxItem  (
            value: vm.agreeToRefundPolicy,
            onChanged: (value) => vm.setAgreeToRefundPolicy(value),
            title: 'I agree to the NaviNotes Refund Policy',
          ),
          CustomCheckBoxItem(
            value: vm.agreeToCopyrightPolicy,
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
              onTap: () {
                vm.setScreen(Screen.details);
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
                  debugPrint('Price form is valid, submitting...');
                  vm.setScreen(Screen.preview);
                }
              },
              text: 'Continue to Preview',
              mainAxisSize: MainAxisSize.min,
              suffix: Icon(Icons.arrow_forward, color: AppTheme.white),
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