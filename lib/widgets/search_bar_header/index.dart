import 'package:navinotes/packages.dart';
import 'package:navinotes/widgets/search_bar_header/searchbar_one.dart';

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
                      SearchBarOne(),
                    ],
                  ),
                ),
                Row(
                  children: [
                    NotificationButton(),
                    SettingsButton(),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: ProfilePic(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
