import 'package:navinotes/packages.dart';
import 'vm.dart';

class FlashCardsAppBar extends StatelessWidget {
  const FlashCardsAppBar({super.key});

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
                  return Consumer<FlashCardVm>(
                    builder: (_, vm, _) {
                      return ScrollableController(
                        scrollDirection: Axis.horizontal,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minWidth: constraints.maxWidth,
                          ),
                          child: ResponsivePadding(
                            mobile: EdgeInsets.all(10),
                            tablet: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              spacing: 20,
                              children: [
                                Row(
                                  children: [
                                    RichTextHeader(
                                      title: 'FlashCards',
                                      showLogo: true,
                                    ),
                                  ],
                                ),
                                _trailing(vm),
                              ],
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

  Widget _trailing(FlashCardVm vm) {
    return Row(
      children: [
        Row(
          children: [
            AppIconButton(
              onPressed: NavigationHelper.navigateToSettings,
              icon: SVGImagePlaceHolder(
                imagePath: Images.settings,
                color: AppTheme.stormGray,
                size: 16,
              ),
            ),
            AppIconButton(
              onPressed: NavigationHelper.navigateToTutorial,
              icon: SVGImagePlaceHolder(
                imagePath: Images.ques,
                color: AppTheme.stormGray,
                size: 16,
              ),
            ),
          ],
        ),
        // VisibleController(
        //   mobile: true,
        //   laptop: false,
        //   child: Padding(
        //     padding: const EdgeInsets.only(left: 5),
        //     child: MenuButton(onPressed: vm.openEndDrawer),
        //   ),
        // ),
      ],
    );
  }
}
