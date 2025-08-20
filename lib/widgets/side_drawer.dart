import 'package:navinotes/packages.dart';

class NavigationSideBar extends StatelessWidget {
  const NavigationSideBar({
    super.key,
    this.activeRoute,
    this.shrinkWrap = false,
  });
  final String? activeRoute;
  final bool shrinkWrap;
  @override
  Widget build(BuildContext context) {
    return WidthLimiter(
      mobile: shrinkWrap ? 100 : double.infinity,
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.white,
          border: Border(
            right: BorderSide(width: 2, color: AppTheme.lightGray),
          ),
        ),
        child: Column(
          spacing: 15,
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: AppTheme.lightGray)),
              ),
              padding: EdgeInsets.all(15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SVGImagePlaceHolder(imagePath: Images.logo, size: 29),
                  VisibleController(
                    mobile: !shrinkWrap,
                    child: Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                          AppStrings.appName,
                          overflow: TextOverflow.ellipsis,
                          style: AppTheme.text.copyWith(
                            color: AppTheme.vividRose,
                            fontSize: 20.0,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: shrinkWrap ? 0 : 15),
                child: ScrollableController(
                  child: Column(
                    children: [
                      _item(
                        title: 'Dashboard',
                        icon: Images.home,
                        route: Routes.dashboard,
                      ),
                      _item(
                        title: 'Recent Notes',
                        icon: Images.recent,
                        route: Routes.recentNotes,
                      ),
                      _item(
                        title: 'FlashCards',
                        icon: Images.flashCards,
                        route: Routes.flashCards,
                      ),
                      //TODO bring these back
                      // _item(title: 'Pomodoro Timer', icon: Images.timer),
                      // _item(title: 'Settings', icon: Images.settings),
                      _item(
                        title: 'Marketplace',
                        icon: Images.store,
                        route: Routes.marketplace,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            _footer(),
          ],
        ),
      ),
    );
  }

  Widget _footer() {
    return Padding(
      padding: EdgeInsets.all(15),
      child: Column(
        spacing: 10,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Storage Usage',
            style: AppTheme.text.copyWith(
              color: AppTheme.steelMist,
              fontSize: shrinkWrap ? 10.0 : 12.0,
            ),
          ),
          Column(
            spacing: 4,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LinearProgressIndicator(
                value: 3.5 / 10,
                backgroundColor: AppTheme.lightGray,
                borderRadius: BorderRadius.circular(100),
                minHeight: 8,
                color: AppTheme.vividBlue,
              ),
              Text(
                '3.5 GB / 10 GB',
                style: AppTheme.text.copyWith(
                  color: AppTheme.steelMist,
                  fontSize: shrinkWrap ? 10.0 : 12.0,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _itemIcon({required String icon, required Color color}) {
    return SVGImagePlaceHolder(imagePath: icon, size: 18, color: color);
  }

  Widget _item({
    required String title,
    required String icon,
    String? route, //TODO make required
  }) {
    bool isActive = activeRoute == route;
    final color = isActive ? AppTheme.vividRose : AppTheme.defaultBlack;
    Radius radius = Radius.circular(100);
    return Material(
      color: Colors.transparent,
      child: ListTile(
        leading: shrinkWrap ? null : _itemIcon(icon: icon, color: color),
        selected: isActive,
        selectedTileColor: AppTheme.polarGlow,
        shape: RoundedRectangleBorder(
          borderRadius:
              shrinkWrap
                  ? BorderRadius.zero
                  : BorderRadius.only(topRight: radius, bottomRight: radius),
        ),

        title:
            shrinkWrap
                ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [_itemIcon(icon: icon, color: color)],
                )
                : Text(
                  title,
                  style: AppTheme.text.copyWith(
                    color: color,
                    fontSize: 16.0,
                    fontWeight: getFontWeight(isActive ? 500 : 400),
                  ),
                ),
        onTap: () {
          if (isNotNull(route) && !isActive) {
            NavigationHelper.push(route!);
          }
        },
      ),
    );
  }
}
