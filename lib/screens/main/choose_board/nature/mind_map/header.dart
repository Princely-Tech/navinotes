import 'package:navinotes/packages.dart';
import 'vm.dart';

class BoardNatureMindMapHeader extends StatelessWidget {
  const BoardNatureMindMapHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<BoardNatureMindMapVm>(
      builder: (_, vm, _) {
        return Container(
          decoration: BoxDecoration(
            color: AppTheme.sageMist,
            border: Border(
              bottom: BorderSide(color: AppTheme.deepMoss.withAlpha(0x19)),
            ),
          ),
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return ScrollableController(
                scrollDirection: Axis.horizontal,
                child: Container(
                  constraints: BoxConstraints(minWidth: constraints.maxWidth),
                  child: Row(
                    spacing: 30,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          VisibleController(
                            mobile: true,
                            desktop: false,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: MenuButton(
                                decoration: BoxDecoration(
                                  color: AppTheme.darkMossGreen,
                                ),
                                onPressed: vm.openDrawer,
                              ),
                            ),
                          ),
                          Text(
                            'Advanced Biology',
                            style: AppTheme.text.copyWith(
                              color: AppTheme.darkMossGreen,
                              fontSize: 20.0,
                              fontFamily: AppTheme.fontLibreBaskerville,
                            ),
                          ),
                        ],
                      ),
                      VisibleController(
                        mobile: false,
                        desktop: true,
                        child: Row(
                          spacing: 25,
                          children: [
                            _imgItem(img: Images.leaf),
                            _imgItem(img: Images.plant),
                            _imgItem(img: Images.tree),
                            _searchField(),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Row(
                            children: [
                              AppButton(
                                mainAxisSize: MainAxisSize.min,
                                spacing: 10,
                                onTap: () {},
                                minHeight: 32,
                                padding: EdgeInsets.symmetric(
                                  vertical: 5,
                                  horizontal: 15,
                                ),
                                text: 'Share',
                                color: AppTheme.deepMoss,
                                prefix: SVGImagePlaceHolder(
                                  imagePath: Images.share2,
                                  color: AppTheme.white,
                                  size: 14,
                                ),
                                style: AppTheme.text.copyWith(
                                  color: AppTheme.white,
                                  fontFamily: AppTheme.fontCrimsonText,
                                ),
                              ),
                              VisibleController(
                                mobile: false,
                                desktop: true,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 15),
                                  child: Text(
                                    'Customization',
                                    style: AppTheme.text.copyWith(
                                      color: AppTheme.darkMossGreen,
                                      fontFamily: AppTheme.fontCrimsonText,
                                      height: 1.43,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 15),
                                child: ProfilePic(size: 32),
                              ),
                            ],
                          ),
                          VisibleController(
                            mobile: true,
                            laptop: false,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: MenuButton(
                                decoration: BoxDecoration(
                                  color: AppTheme.darkMossGreen,
                                ),
                                onPressed: vm.openEndDrawer,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _imgItem({required String img}) {
    return SVGImagePlaceHolder(
      imagePath: img,
      color: AppTheme.coffee,
      size: 16,
    );
  }

  Widget _searchField() {
    return WidthLimiter(
      mobile: 192,
      child: CustomInputField(
        prefixIcon: Icon(Icons.search, color: AppTheme.coffee, size: 20),
        hintText: 'Search...',
        fillColor: AppTheme.white,
        constraints: BoxConstraints(maxHeight: 34),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(color: AppTheme.burntLeather.withAlpha(0x33)),
        ),
        style: AppTheme.text.copyWith(
          color: AppTheme.coffee,
          fontSize: 16.0,
          fontFamily: AppTheme.fontCrimsonText,
          height: 1.50,
        ),
        hintStyle: AppTheme.text.copyWith(
          color: AppTheme.slateGray,
          fontFamily: AppTheme.fontCrimsonText,
          height: 1.50,
        ),
      ),
    );
  }
}
