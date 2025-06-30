import 'package:navinotes/packages.dart';

class MarketplaceFooter extends StatelessWidget {
  const MarketplaceFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppTheme.white,
        border: Border(top: BorderSide(color: AppTheme.lightGray)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        spacing: 5,
        children: [
          _item(
            name: 'Browse',
            imagePath: Images.store2,
            isCurrent: true,
            route: Routes.marketplace,
          ),
          _item(name: 'My Purchases', imagePath: Images.shoppingBag),
          _item(name: 'My Store', imagePath: Images.store3),
          _item(name: 'Cart', imagePath: Images.shoppingCart),
        ],
      ),
    );
  }

  Widget _item({
    required String name,
    required String imagePath,
    bool isCurrent = false,
    String? route,
  }) {
    Color color = isCurrent ? AppTheme.strongBlue : AppTheme.steelMist;
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: InkWell(
              onTap: () {
                if (isNotNull(route) && !isCurrent) {
                  NavigationHelper.push(route!);
                }
              },
              child: Column(
                spacing: 5,
                children: [
                  SVGImagePlaceHolder(
                    imagePath: imagePath,
                    color: color,
                    size: 20,
                  ),
                  Text(
                    name,
                    style: AppTheme.text.copyWith(color: color, fontSize: 12.0),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
