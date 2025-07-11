import 'package:navinotes/packages.dart';

class FlashCardsFooter extends StatelessWidget {
  const FlashCardsFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppTheme.white,
        border: Border(top: BorderSide(color: AppTheme.lightGray)),
      ),
      padding: const EdgeInsets.all( 10),
      child: Row(
        spacing: 5,
        children: [
          _item(
            name: 'Browse',
            imagePath: Images.store2,
            isCurrent: true,
            route: Routes.marketplace,
          ),
          _item(
            name: 'My Purchases',
            imagePath: Images.shoppingBag,
            route: Routes.myPurchases,
          ),
          _item(
            name: 'My Store',
            imagePath: Images.store3,
            route: Routes.myStore,
          ),
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
      child: InkWell(
        onTap: () {
          if (isNotNull(route) && !isCurrent) {
            NavigationHelper.push(route!);
          }
        },
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
                      textAlign: TextAlign.center,
                      style: AppTheme.text.copyWith(
                        color: color,
                        fontSize: 12.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
