import 'package:navinotes/packages.dart';
import 'vm.dart';

class ProductDetailAppBar extends StatelessWidget {
  const ProductDetailAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppTheme.white,
        border: Border(bottom: BorderSide(color: AppTheme.lightGray)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: WidthLimiter(
              mobile: largeDesktopSize,
              child: LayoutBuilder(
                builder: (_, constraints) {
                  return Consumer<ProductDetailVm>(
                    builder: (_, vm, _) {
                      return ScrollableController(
                        scrollDirection: Axis.horizontal,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minWidth: constraints.maxWidth,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              spacing: 20,
                              children: [_leading(), _trailing(vm)],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget _searchField() {
  //   return CustomInputField(
  //     prefixIcon: Icon(Icons.search, color: AppTheme.blueGray, size: 20),
  //     hintText: 'Search marketplace',
  //     fillColor: AppTheme.lightAsh,
  //     border: OutlineInputBorder(
  //       borderRadius: BorderRadius.circular(999),
  //       borderSide: BorderSide.none,
  //     ),
  //     hintStyle: AppTheme.text.copyWith(
  //       color: AppTheme.slateGray,
  //       height: 1.43,
  //     ),
  //   );
  // }

  Widget _trailing(ProductDetailVm vm) {
    return Row(
      children: [
        // VisibleController(
        //   mobile: false,
        //   laptop: true,
        //   child: Padding(
        //     padding: const EdgeInsets.only(right: 15),
        //     child: WidthLimiter(mobile: 256, child: _searchField()),
        //   ),
        // ),
        Row(
          spacing: 15,
          children: [
            Badge(
              backgroundColor: AppTheme.primaryColor,
              textStyle: AppTheme.text.copyWith(
                color: AppTheme.white,
                fontSize: 8.0,
              ),
             // label: Center(child: Text('2', textAlign: TextAlign.center)), // TODO: Count cart items here
              child: SVGImagePlaceHolder(
                imagePath: Images.shoppingCart,
                size: 20,
                color: AppTheme.darkSlateGray,
              ),
            ),
            ProfilePic(size: 32),
          ],
        ),
        // VisibleController(
        //   mobile: true,
        //   desktop: false,
        //   child: Padding(
        //     padding: const EdgeInsets.only(left: 10),
        //     child: MenuButton(onPressed: vm.openEndDrawer),
        //   ),
        // ),
      ],
    );
  }

  Widget _leading() {
    return InkWell(
      onTap: () => NavigationHelper.pop(),
      child: Row(
        children: [
          Row(
            spacing: 10,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.arrow_back, color: AppTheme.darkSlateGray, size: 20),
              SVGImagePlaceHolder(imagePath: Images.logo, size: 40),
            ],
          ),
          VisibleController(
            mobile: false,
            tablet: true,
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                AppStrings.appName,
                style: AppTheme.text.copyWith(
                  color: AppTheme.vividRose,
                  fontSize: 24.0,
                  fontWeight: getFontWeight(700),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
