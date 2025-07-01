import 'package:navinotes/packages.dart';
import 'vm.dart';

class MarketplaceAppBar extends StatelessWidget {
  const MarketplaceAppBar({super.key});

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
                  return Consumer<MarketPlaceVm>(
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

  Widget _trailing(MarketPlaceVm vm) {
    return Row(
      children: [
        Row(
          spacing: 10,
          children: [
            Icon(Icons.notifications_none, color: AppTheme.darkSlateGray),
            ProfilePic(size: 32),
          ],
        ),
        VisibleController(
          mobile: true,
          desktop: false,
          child: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: MenuButton(onPressed: vm.openDrawer),
          ),
        ),
      ],
    );
  }

  Widget _leading() {
    return Consumer<LayoutProviderVm>(
      builder: (_, layoutVm, _) {
        bool hideTxts =
            layoutVm.deviceType == DeviceType.mobile ||
            layoutVm.deviceType == DeviceType.tablet;
        return InkWell(
          onTap: () => NavigationHelper.pop(),
          child: Row(
            spacing: 10,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.arrow_back, color: AppTheme.darkSlateGray, size: 20),
              Text.rich(
                TextSpan(
                  children: [
                    if (!hideTxts) ...[
                      TextSpan(
                        text: AppStrings.appName,
                        style: AppTheme.text.copyWith(
                          color: AppTheme.vividRose,
                          fontSize: 24.0,
                          fontWeight: getFontWeight(700),
                        ),
                      ),
                      TextSpan(
                        text: ' | ',
                        style: AppTheme.text.copyWith(
                          color: AppTheme.blueGray,
                          fontSize: 16.0,
                        ),
                      ),
                    ],
                    TextSpan(
                      text: 'Marketplace',
                      style: AppTheme.text.copyWith(
                        color: AppTheme.darkSlateGray,
                        fontSize: 20.0,
                        fontWeight: getFontWeight(500),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
