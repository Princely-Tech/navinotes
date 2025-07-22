import 'package:navinotes/packages.dart';

class SearchBarHeader extends StatelessWidget {
  const SearchBarHeader({
    super.key,
    required this.openDrawer,
    this.borderBottom = false,
  });
  final VoidCallback openDrawer;
  final bool borderBottom;
  @override
  Widget build(BuildContext context) {
    return Consumer<LayoutProviderVm>(
      builder: (_, layoutVm, _) {
        return Container(
          decoration: BoxDecoration(
            color: borderBottom ? AppTheme.white : AppTheme.transparent,
            border: Border(
              bottom: BorderSide(
                color: borderBottom ? AppTheme.lightGray : Colors.transparent,
              ),
            ),
          ),
          child: ResponsivePadding(
            mobile: EdgeInsets.all(10),
            tablet: EdgeInsets.symmetric(
              horizontal: defaultHorizontalPadding,
              vertical: 10,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              spacing: 30,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      VisibleController(
                        mobile: getMenuVisible(layoutVm.deviceType),
                        child: Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: InkWell(
                            onTap: openDrawer,
                            child: Icon(
                              Icons.menu,
                              size: 24,
                              color: AppTheme.steelMist,
                            ),
                          ),
                        ),
                      ),
                      _searchBar(),
                    ],
                  ),
                ),
                Row(
                  spacing: 20,
                  children: [
                    SVGImagePlaceHolder(imagePath: Images.bell, size: 16),
                    SVGImagePlaceHolder(
                      imagePath: Images.settings,
                      size: 16,
                      color: AppTheme.steelMist,
                    ),
                    ProfilePic(),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _searchBar() {
    return Expanded(
      child: Align(
        alignment: Alignment.centerLeft,
        child: WidthLimiter(
          mobile: 512,
          child: CustomInputField(
            prefixIcon: Icon(Icons.search, color: AppTheme.slateGray, size: 20),
            hintText: 'Search your notes, boards, and more...',
            hintStyle: AppTheme.text.copyWith(
              color: AppTheme.slateGray,
              fontSize: 16.0,
              height: 1.50,
            ),
          ),
        ),
      ),
    );
  }
}
