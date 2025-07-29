import 'package:navinotes/models/markeplace_item.dart';
import 'package:navinotes/packages.dart';
import 'package:navinotes/screens/main/market_place/vm.dart';

class MarketPlaceAside extends StatelessWidget {
  final MarketPlaceVm vm;

  const MarketPlaceAside({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppTheme.white,
        border: Border(right: BorderSide(color: AppTheme.lightGray)),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Filters',
                  style: AppTheme.text.copyWith(
                    fontSize: 18.0,
                    fontWeight: getFontWeight(500),
                  ),
                ),
                if (vm.activeFilterCount > 0)
                  TextButton(
                    onPressed: vm.clearFilters,
                    child: Text(
                      'Clear All',
                      style: AppTheme.text.copyWith(
                        color: AppTheme.coralRed,
                        fontSize: 14.0,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 20,
                children: [
                  // Category Filter
                  _sections(
                    title: 'Category',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:
                          marketPlaceCategoryMap.keys.map((category) {
                            final isSelected = vm.selectedCategory == category;
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomCheckBoxItem(
                                  title: category,
                                  value: isSelected,
                                  onChanged: (value) {
                                    if (value == true) {
                                      vm.setCategory(category);
                                    } else {
                                      vm.setCategory(null);
                                    }
                                  },
                                ),
                                // Show subcategories if this category is selected
                                if (isSelected && vm.selectedCategory != null)
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children:
                                          marketPlaceCategoryMap[category]!.map(
                                            (subCategory) {
                                              return CustomCheckBoxItem(
                                                title: subCategory,
                                                value:
                                                    vm.selectedSubCategory ==
                                                    subCategory,
                                                onChanged: (value) {
                                                  if (value == true) {
                                                    vm.setSubCategory(
                                                      subCategory,
                                                    );
                                                  } else {
                                                    vm.setSubCategory(null);
                                                  }
                                                },
                                              );
                                            },
                                          ).toList(),
                                    ),
                                  ),
                              ],
                            );
                          }).toList(),
                    ),
                  ),

                  // Price Range Filter
                  _sections(
                    title: 'Price Range',
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            decoration: const InputDecoration(
                              labelText: 'Min',
                              prefixText: '\$',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              final min = double.tryParse(value);
                              vm.setPriceRange(min, vm.maxPrice);
                            },
                            controller: TextEditingController(
                              text: vm.minPrice?.toStringAsFixed(2),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            decoration: const InputDecoration(
                              labelText: 'Max',
                              prefixText: '\$',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              final max = double.tryParse(value);
                              vm.setPriceRange(vm.minPrice, max);
                            },
                            controller: TextEditingController(
                              text: vm.maxPrice?.toStringAsFixed(2),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Discount Filter
                  _sections(
                    title: 'Discount',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                decoration: const InputDecoration(
                                  labelText: 'Min %',
                                  border: OutlineInputBorder(),
                                  suffixText: '%',
                                ),
                                keyboardType: TextInputType.number,
                                onChanged: (value) {
                                  final min = int.tryParse(value);
                                  vm.setDiscountRange(min, vm.maxDiscount);
                                },
                                controller: TextEditingController(
                                  text: vm.minDiscount?.toString(),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: TextField(
                                decoration: const InputDecoration(
                                  labelText: 'Max %',
                                  border: OutlineInputBorder(),
                                  suffixText: '%',
                                ),
                                keyboardType: TextInputType.number,
                                onChanged: (value) {
                                  final max = int.tryParse(value);
                                  vm.setDiscountRange(vm.minDiscount, max);
                                },
                                controller: TextEditingController(
                                  text: vm.maxDiscount?.toString(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Apply Filters Button
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: SizedBox(
                      width: double.infinity,
                      child: AppButton(
                        onTap: () {
                          vm.loadMarketplaceItems(page: 1);
                          Navigator.pop(context); // Close the drawer
                        },
                        text: 'Apply Filters',
                        color: AppTheme.strongBlue,
                        textColor: AppTheme.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sections({required String title, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTheme.text.copyWith(
            fontSize: 16.0,
            fontWeight: getFontWeight(500),
            color: AppTheme.charcoalBlue,
          ),
        ),
        const SizedBox(height: 12),
        child,
        const SizedBox(height: 16),
      ],
    );
  }
}
