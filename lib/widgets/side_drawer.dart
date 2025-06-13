import 'package:navinotes/packages.dart';

class NavigationSideBar extends StatelessWidget {
  const NavigationSideBar({super.key, required this.currentRoute});
  final String currentRoute;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Apptheme.white,
        border: Border(right: BorderSide(width: 2, color: Apptheme.lightGray)),
      ),
      child: Column(
        spacing: 15,
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Apptheme.lightGray)),
            ),
            padding: EdgeInsets.all(15),
            child: Row(
              spacing: 10,
              children: [
                SVGImagePlaceHolder(imagePath: Images.logo, size: 29),
                Expanded(
                  child: Text(
                    AppStrings.appName,
                    overflow: TextOverflow.ellipsis,
                    style: Apptheme.text.copyWith(
                      color: Apptheme.vividRose,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 15),
              child: ScrollableController(
                child: Column(
                  children: [
                    _item(
                      title: 'Dashboard',
                      icon: Images.home,
                      route: Routes.dashboard,
                    ),
                    _item(title: 'Recent Notes', icon: Images.recent),
                    _item(title: 'Flashcards', icon: Images.flashCards),
                    _item(title: 'Pomodoro Timer', icon: Images.timer),
                    _item(title: 'Settings', icon: Images.settings),
                    _item(title: 'Marketplace', icon: Images.store),
                  ],
                ),
              ),
            ),
          ),
          _footer(),
        ],
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
            style: Apptheme.text.copyWith(
              color: Apptheme.steelMist,
              fontSize: 12,
            ),
          ),
          Column(
            spacing: 4,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LinearProgressIndicator(
                value: 3.5 / 10,
                backgroundColor: Apptheme.lightGray,
                borderRadius: BorderRadius.circular(100),
                minHeight: 8,
                color: Apptheme.vividBlue,
              ),
              Text(
                '3.5 GB / 10 GB',
                style: Apptheme.text.copyWith(
                  color: Apptheme.steelMist,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _item({
    required String title,
    required String icon,
    String? route, //TODO make required
  }) {
    bool isActive = currentRoute == route;
    final color = isActive ? Apptheme.vividRose : Apptheme.defaultBlack;
    Radius radius = Radius.circular(100);
    return Material(
      color: Colors.transparent,
      child: ListTile(
        leading: SVGImagePlaceHolder(imagePath: icon, size: 18, color: color),
        selected: isActive,
        selectedTileColor: Apptheme.polarGlow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: radius,
            bottomRight: radius,
          ),
        ),
        title: Text(
          title,
          style: Apptheme.text.copyWith(
            color: color,
            fontSize: 16,
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
