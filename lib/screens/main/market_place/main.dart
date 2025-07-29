import 'package:navinotes/models/markeplace_item.dart';
import 'package:navinotes/packages.dart';
import 'vm.dart';

class MarketplaceMain extends StatelessWidget {
  MarketplaceMain({super.key});

  final PageController _featuredController = PageController(
    viewportFraction: 0.9,
  );
    final double _featuredItemWidth =
      254; // Width of each featured item including spacing


  @override
  Widget build(BuildContext context) {
    return ApiServiceComponent(
      child: Consumer<ApiServiceProvider>(
        builder: (_, apiServiceProvider, __) {
          return ChangeNotifierProvider(
            create:
                (_) => MarketPlaceVm(
                  scaffoldKey: GlobalKey<ScaffoldState>(),
                  apiServiceProvider: apiServiceProvider,
                ),
            child: Consumer<MarketPlaceVm>(
              builder: (context, vm, _) {
                // Load data when the widget is first built
                if (vm.items.isEmpty && !vm.isLoading) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    vm.loadMarketplaceItems();
                    vm.loadFeaturedItems();
                  });
                }

                return ResponsivePadding(
                  mobile: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                  tablet: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: Column(
                    children: [
                      _header(),
                      Expanded(
                        child: ScrollableController(
                          mobilePadding: EdgeInsets.symmetric(vertical: 20),
                          onEndReached:
                              vm.hasMorePages ? vm.loadNextPage : null,
                          child: Column(
                            spacing: 30,
                            children: [
                              _featured(vm: vm),
                              _allContent(vm: vm),
                              if (vm.totalPages > 1) _pagination(vm: vm),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _allContent({required MarketPlaceVm vm}) {
    if (vm.isLoading && vm.items.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return _section(
      title: 'All Content',
      titleRight: Row(
        spacing: 10,
        children: [
          _layoutBtn(PageDisplayFormat.grid),
          _layoutBtn(PageDisplayFormat.list),
        ],
      ),
      child:
          vm.items.isEmpty
              ? Center(
                child: Text(
                  'No items found',
                  style: AppTheme.text.copyWith(color: AppTheme.stormGray),
                ),
              )
              : CustomGrid(
                spacing: 20,
                children: vm.items.map((item) => _contentItem(item)).toList(),
              ),
    );
  }

  Widget _contentItem(MarketItem item) {
    return Consumer<MarketPlaceVm>(
      builder: (_, vm, _) {
        return InkWell(
          onTap: vm.goToProductDetail,
          child: CustomCard(
            padding: EdgeInsets.zero,
            addBorder: true,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AspectRatio(
                  aspectRatio: 3,
                  child: ImagePlaceHolder(
                    imagePath: item.coverImagePath,
                    isCardHeader: true,
                    type: ImagePlaceHolderTypes.network,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 15,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 10,
                        children: [
                          Text(
                            item.title,
                            style: AppTheme.text.copyWith(
                              color: AppTheme.charcoalBlue,
                              fontSize: 16.0,
                              fontWeight: getFontWeight(500),
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            'by ${item.author}',
                            style: AppTheme.text.copyWith(
                              color: AppTheme.stormGray,
                              fontSize: 12.0,
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              StarRows(
                                fullStars: item.rating.round(),
                                emptyStars: 5 - item.rating.round(),
                              ),
                              Text(
                                '(${item.ratingCount})',
                                style: AppTheme.text.copyWith(
                                  color: AppTheme.stormGray,
                                  fontSize: 12.0,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        spacing: 10,
                        children: [
                          if (item.tags.isNotEmpty)
                            // Replace the current tags Row with this Wrap widget
                            Wrap(
                              spacing: 6,
                              runSpacing: 4,
                              children:
                                  item.tags
                                      .take(3)
                                      .map(
                                        (tag) => Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 2,
                                          ),
                                          decoration: BoxDecoration(
                                            color: AppTheme.lightGray
                                                .withOpacity(0.2),
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            border: Border.all(
                                              color: AppTheme.steelMist
                                                  .withOpacity(0.3),
                                              width: 0.5,
                                            ),
                                          ),
                                          child: Text(
                                            tag,
                                            style: AppTheme.text.copyWith(
                                              color: AppTheme.steelMist,
                                              fontSize: 10.0,
                                              height: 1.2,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      )
                                      .toList(),
                            ),
                          AppButton(
                            onTap: () {},
                            text: 'Add To Cart',
                            mainAxisSize: MainAxisSize.min,
                            color: AppTheme.strongBlue,
                            minHeight: 28,
                          ),
                        ],
                      ),
                      if (item.discountPercent != null &&
                          item.discountPercent! > 0)
                        Row(
                          children: [
                            Text(
                              '\$${item.getAmount().toStringAsFixed(2)}',
                              style: AppTheme.text.copyWith(
                                color: AppTheme.strongBlue,
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '\$${item.getOriginalAmount().toStringAsFixed(2)}',
                              style: AppTheme.text.copyWith(
                                color: AppTheme.stormGray,
                                fontSize: 12.0,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          ],
                        )
                      else
                        Text(
                          '\$${item.getAmount().toStringAsFixed(2)}',
                          style: AppTheme.text.copyWith(
                            color: AppTheme.strongBlue,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _layoutBtn(PageDisplayFormat format) {
    bool isGrid = format == PageDisplayFormat.grid;
    return OutlinedChild(
      size: 30,
      decoration: BoxDecoration(
        border: Border.all(width: 2, color: AppTheme.lightGray),
      ),
      child: SVGImagePlaceHolder(
        imagePath: isGrid ? Images.grid : Images.menu,
        color: isGrid ? AppTheme.darkSlateGray : AppTheme.blueGray,
        size: isGrid ? 14 : 16,
      ),
    );
  }

 Widget _featured({required MarketPlaceVm vm}) {
    if (vm.isLoadingFeatured && vm.featuredItems.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (vm.featuredItems.isEmpty) {
      return const SizedBox.shrink();
    }

    // Function to handle scrolling
    void _scrollFeatured(int direction) {
      final double scrollAmount = _featuredItemWidth * 2; // Scroll by 2 items
      final double newPosition =
          _featuredController.offset + (scrollAmount * direction);

      // Clamp the position to valid range
      final double maxScroll = _featuredController.position.maxScrollExtent;
      final double clampedPosition = newPosition.clamp(0.0, maxScroll);

      _featuredController.animateTo(
        clampedPosition,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }

    return _section(
      title: 'Featured for You',
      titleRight: Row(
        children: [
          OutlinedButton(
            onPressed: () => _scrollFeatured(-1), // Scroll left
            style: OutlinedButton.styleFrom(
              shape: CircleBorder(side: BorderSide(color: AppTheme.lightGray)),
              padding: EdgeInsets.zero,
            ),
            child: const Icon(Icons.keyboard_arrow_left, size: 25),
          ),
          OutlinedButton(
            onPressed: () => _scrollFeatured(1), // Scroll right
            style: OutlinedButton.styleFrom(
              shape: CircleBorder(side: BorderSide(color: AppTheme.lightGray)),
              padding: EdgeInsets.zero,
            ),
            child: const Icon(Icons.keyboard_arrow_right, size: 25),
          ),
        ],
      ),
      child: SizedBox(
        //height: 200,
        child: ScrollableController(
          scrollDirection: Axis.horizontal,
          controller: _featuredController, // Add this line
          child: Row(
            spacing: 15,
            children:
                vm.featuredItems.map((item) => _featureItem(item)).toList(),
          ),
        ),
      ),
    );
  }
  Widget _featureItem(MarketItem item) {
    String image = item.coverImagePath;
    return Consumer<MarketPlaceVm>(
      builder: (_, vm, _) {
        return InkWell(
          onTap: vm.goToProductDetail,
          child: CustomCard(
            padding: EdgeInsets.zero,
            addBorder: true,
            width: _featuredItemWidth,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 144,
                  child: ImagePlaceHolder(imagePath: image, isCardHeader: true, type: ImagePlaceHolderTypes.network),
                ),
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 15,
                    children: [
                      Text(
                        item.title,
                        style: AppTheme.text.copyWith(
                          color: AppTheme.charcoalBlue,
                          fontSize: 16.0,
                          fontWeight: getFontWeight(500),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        item.author,
                        style: AppTheme.text.copyWith(
                          color: AppTheme.stormGray,
                          fontSize: 12.0,
                        ),
                      ),

                      SizedBox(
                        width: double.infinity,
                        child: Wrap(
                          alignment: WrapAlignment.spaceBetween,
                          runSpacing: 10,
                          spacing: 10,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                StarRows(fullStars: item.rating.round(), emptyStars: 5 - item.rating.round()),
                                Text(
                                  '(${item.ratingCount})',
                                  style: AppTheme.text.copyWith(
                                    color: AppTheme.stormGray,
                                    fontSize: 12.0,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              '\$${item.getAmount().toStringAsFixed(2)}',
                              style: AppTheme.text.copyWith(
                                color: AppTheme.jungleGreen,
                                fontSize: 16.0,
                                fontWeight: getFontWeight(500),
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
        );
      },
    );
  }

  Widget _section({
    required String title,
    required Widget child,
    required Widget titleRight,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 15,
      children: [
        Row(
          spacing: 20,
          children: [
            Expanded(
              child: Text(
                title,
                style: AppTheme.text.copyWith(
                  fontSize: 20.0,
                  fontWeight: getFontWeight(500),
                ),
              ),
            ),
            titleRight,
          ],
        ),
        child,
      ],
    );
  }

  Widget _header() {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(child: _searchField()),
          VisibleController(
            mobile: false,
            tablet: true,
            child: Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: Row(
                spacing: 12,
                children: [
                  AppButton(
                    spacing: 10,
                    prefix: SVGImagePlaceHolder(
                      imagePath: Images.filter,
                      size: 16,
                      color: AppTheme.darkSlateGray,
                    ),
                    suffix: Container(
                      decoration: ShapeDecoration(
                        color: const Color(0xFFDBEAFE),
                        shape: CircleBorder(),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 3,
                      ),
                      child: Text(
                        '2',
                        textAlign: TextAlign.center,
                        style: AppTheme.text.copyWith(
                          color: AppTheme.persianBlue,
                          fontSize: 12.0,
                        ),
                      ),
                    ),
                    minHeight: 35,
                    onTap: () {},
                    text: 'Filter',
                    color: AppTheme.white,
                    borderColor: AppTheme.lightGray,
                    mainAxisSize: MainAxisSize.min,
                    textColor: AppTheme.darkSlateGray,
                  ),
                  AppButton(
                    spacing: 10,
                    prefix: SVGImagePlaceHolder(
                      imagePath: Images.filter,
                      size: 16,
                      color: AppTheme.darkSlateGray,
                    ),
                    suffix: Icon(
                      Icons.keyboard_arrow_down,
                      size: 26,
                      color: AppTheme.darkSlateGray,
                    ),
                    minHeight: 35,
                    onTap: () {},
                    text: 'Most Popular',
                    color: AppTheme.white,
                    borderColor: AppTheme.lightGray,
                    mainAxisSize: MainAxisSize.min,
                    textColor: AppTheme.darkSlateGray,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _searchField() {
    return CustomInputField(
      prefixIcon: Icon(Icons.search, color: AppTheme.slateGray, size: 20),
      hintText: 'Search for mind maps, flashcards, study guides...',
      fillColor: AppTheme.white,
      hintStyle: AppTheme.text.copyWith(
        color: AppTheme.slateGray,
        height: 1.43,
      ),
    );
  }

  Widget _pagination({required MarketPlaceVm vm}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed:
                vm.currentPage > 1
                    ? () => vm.loadMarketplaceItems(page: vm.currentPage - 1)
                    : null,
          ),
          ...List.generate(vm.totalPages > 5 ? 5 : vm.totalPages, (index) {
            int pageNumber;
            if (vm.totalPages <= 5) {
              pageNumber = index + 1;
            } else if (vm.currentPage <= 3) {
              pageNumber = index + 1;
            } else if (vm.currentPage >= vm.totalPages - 2) {
              pageNumber = vm.totalPages - 4 + index;
            } else {
              pageNumber = vm.currentPage - 2 + index;
            }

            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              child: InkWell(
                onTap: () => vm.loadMarketplaceItems(page: pageNumber),
                child: Container(
                  width: 36,
                  height: 36,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color:
                        vm.currentPage == pageNumber
                            ? AppTheme.strongBlue
                            : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '$pageNumber',
                    style: AppTheme.text.copyWith(
                      color:
                          vm.currentPage == pageNumber
                              ? Colors.white
                              : AppTheme.charcoalBlue,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            );
          }),
          if (vm.totalPages > 5 && vm.currentPage < vm.totalPages - 2)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 4),
              child: Text('...'),
            ),
          if (vm.totalPages > 5 && vm.currentPage < vm.totalPages - 2)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              child: InkWell(
                onTap: () => vm.loadMarketplaceItems(page: vm.totalPages),
                child: Container(
                  width: 36,
                  height: 36,
                  alignment: Alignment.center,
                  child: Text(
                    '$vm.totalPages',
                    style: AppTheme.text.copyWith(
                      color: AppTheme.charcoalBlue,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed:
                vm.hasMorePages
                    ? () => vm.loadMarketplaceItems(page: vm.currentPage + 1)
                    : null,
          ),
        ],
      ),
    );
  }
}
