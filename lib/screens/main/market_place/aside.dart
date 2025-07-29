import 'package:navinotes/models/markeplace_item.dart';
import 'package:navinotes/packages.dart';
import 'package:navinotes/screens/main/market_place/vm.dart';

class MarketPlaceAside extends StatefulWidget {
  final MarketPlaceVm vm;

  const MarketPlaceAside({super.key, required this.vm});

  @override
  State<MarketPlaceAside> createState() => _MarketPlaceAsideState();
}

class _MarketPlaceAsideState extends State<MarketPlaceAside> {


  late final TextEditingController _minPriceController;
  late final TextEditingController _maxPriceController;
  late final TextEditingController _minDiscountController;
  late final TextEditingController _maxDiscountController;

  @override
  void initState() {
    super.initState();
    _minPriceController = TextEditingController(text: widget.vm.minPrice?.toStringAsFixed(2));
    _maxPriceController = TextEditingController(text: widget.vm.maxPrice?.toStringAsFixed(2));
    _minDiscountController = TextEditingController(text: widget.vm.minDiscount?.toString());
    _maxDiscountController = TextEditingController(text: widget.vm.maxDiscount?.toString());
  }

  @override
  void dispose() {
    _minPriceController.dispose();
    _maxPriceController.dispose();
    _minDiscountController.dispose();
    _maxDiscountController.dispose();
    super.dispose();
  }


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
                if (widget.vm.activeFilterCount > 0)
                  TextButton(
                    onPressed: widget.vm.clearFilters,
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
                            final isSelected = widget.vm.selectedCategory == category;
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomCheckBoxItem(
                                  title: category,
                                  value: isSelected,
                                  onChanged: (value) {
                                    if (value == true) {
                                      widget.vm.setCategory(category);
                                    } else {
                                      widget.vm.setCategory(null);
                                    }
                                  },
                                ),
                                // Show subcategories if this category is selected
                                if (isSelected && widget.vm.selectedCategory != null)
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
                                                    widget.vm.selectedSubCategory ==
                                                    subCategory,
                                                onChanged: (value) {
                                                  if (value == true) {
                                                    widget.vm.setSubCategory(
                                                      subCategory,
                                                    );
                                                  } else {
                                                    widget.vm.setSubCategory(null);
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

_sections(
                    title: 'Price Range',
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _minPriceController,
                            decoration: const InputDecoration(
                              labelText: 'Min',
                              prefixText: '\$',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            onChanged: (value) {
                              final min = double.tryParse(value);
                              widget.vm.setPriceRange(min, widget.vm.maxPrice);
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: _maxPriceController,
                            decoration: const InputDecoration(
                              labelText: 'Max',
                              prefixText: '\$',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            onChanged: (value) {
                              final max = double.tryParse(value);
                              widget.vm.setPriceRange(widget.vm.minPrice, max);
                            },
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
                                  widget.vm.setDiscountRange(min, widget.vm.maxDiscount);
                                },
                                controller: TextEditingController(
                                  text: widget.vm.minDiscount?.toString(),
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
                                  widget.vm.setDiscountRange(widget.vm.minDiscount, max);
                                },
                                controller: TextEditingController(
                                  text: widget.vm.maxDiscount?.toString(),
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
                          widget.vm.loadMarketplaceItems(page: 1);
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
