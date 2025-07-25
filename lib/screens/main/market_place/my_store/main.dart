import 'package:navinotes/packages.dart';
import 'package:navinotes/screens/main/market_place/my_store/chart.dart';
import 'vm.dart';

class MyStoreMain extends StatelessWidget {
  const MyStoreMain({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MyStoreVm>(
      builder: (_, vm, _) {
        return ScrollableController(
          mobilePadding: const EdgeInsets.fromLTRB(10, 10, 10, 30),
          tabletPadding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 15,
            children: [
              ScrollableController(
                scrollDirection: Axis.horizontal,
                mobilePadding: const EdgeInsets.all(2),
                child: Row(
                  spacing: 15,
                  children: [
                    _card(
                      title: 'Total Earnings',
                      footer: '\$0 all- time',
                      value: '\$0',
                      percentage: '0',
                      imagePath: Images.dollar,
                    ),
                    _card(
                      title: 'Total Sales',
                      footer: '03 all-time',
                      value: '0',
                      percentage: '0',
                      imagePath: Images.shoppingCart,
                    ),
                    _card(
                      title: 'Average Rating',
                      footer: '0 reviews this month',
                      value: '0',
                      imagePath: Images.star2,
                    ),
                    _card(
                      title: 'Active Listings',
                      footer: '0 drafts in progress',
                      value: '0',
                      imagePath: Images.clipboard,
                    ),
                  ],
                ),
              ),
        
              ScrollableController(
                scrollDirection: Axis.horizontal,
                mobilePadding: const EdgeInsets.all(2),
                child: Row(
                  spacing: 15,
                  children: [
                    AppButton(
                      onTap: vm.goTosellerUploadContent,
                      text: 'Upload New Content',
                      mainAxisSize: MainAxisSize.min,
                      color: AppTheme.jungleGreen,
                      prefix: Icon(Icons.add, color: AppTheme.white, size: 25),
                    ),
        
                    AppButton(
                      onTap: () {},
                      text: 'View Analytics',
                      mainAxisSize: MainAxisSize.min,
                      color: AppTheme.white,
                      borderColor: AppTheme.lightGray,
                      textColor: AppTheme.defaultBlack,
                      prefix: SVGImagePlaceHolder(
                        imagePath: Images.chart2,
                        size: 16,
                        color: AppTheme.defaultBlack,
                      ),
                    ),
                    AppButton(
                      onTap: () {},
                      text: 'Manage Products',
                      mainAxisSize: MainAxisSize.min,
                      color: AppTheme.white,
                      borderColor: AppTheme.lightGray,
                      textColor: AppTheme.defaultBlack,
                      prefix: const SVGImagePlaceHolder(
                        imagePath: Images.edit,
                        size: 16,
                        color: AppTheme.defaultBlack,
                      ),
                    ),
                  ],
                ),
              ),
        
              _salesPerformance(),
            ],
          ),
        );
      }
    );
  }

  Widget _salesPerformance() {
    return CustomCard(
      padding: EdgeInsets.zero,
      addCardShadow: true,
      child: Column(
        spacing: 15,
        children: [
          LayoutBuilder(
            builder: (_, constraints) {
              return ScrollableController(
                scrollDirection: Axis.horizontal,
                child: Container(
                  constraints: BoxConstraints(minWidth: constraints.maxWidth),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: AppTheme.lightGray),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      spacing: 30,
                      children: [
                        Text(
                          'Sales Performance',
                          style: AppTheme.text.copyWith(
                            fontSize: 16.0,
                            fontWeight: getFontWeight(600),
                          ),
                        ),
                        CustomRowSelect(),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),

          Padding(padding: const EdgeInsets.all(15), child: MyStoreLineChart()),

          Container(
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: AppTheme.lightGray)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                spacing: 10,
                children: [
                  _performanceItem(
                    title: 'Revenue',
                    value: '\$0',
                    increasePercent: '0',
                  ),
                  _performanceItem(
                    title: 'Transactions',
                    value: '0',
                    increasePercent: '0',
                  ),
                  _performanceItem(
                    title: 'Avg. Order Value',
                    value: '\$0',
                    increasePercent: '0',
                  ),
                  _performanceItem(
                    title: 'Conversion Rate',
                    value: '0%',
                    decreasePercent: '0',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _performanceItem({
    required String title,
    required String value,
    String? increasePercent,
    String? decreasePercent,
  }) {
    bool isIncrease = isNotNull(increasePercent);
    return Flexible(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 10,
        children: [
          Text(
            title,
            style: AppTheme.text.copyWith(
              color: AppTheme.steelMist,
              height: 1.0,
            ),
          ),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: value,
                  style: AppTheme.text.copyWith(
                    fontSize: 16.0,
                    fontWeight: getFontWeight(600),
                  ),
                ),
                TextSpan(
                  text:
                      ' ${isIncrease ? '↑' : '↓'} ${increasePercent ?? decreasePercent}',
                  style: AppTheme.text.copyWith(
                    color:
                        isIncrease ? AppTheme.jungleGreen : AppTheme.bloodFire,
                    fontSize: 12.0,
                    fontWeight: getFontWeight(600),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _card({
    required String title,
    required String value,
    required String footer,
    String? percentage,
    required String imagePath,
  }) {
    return CustomCard(
      width: null,
      addCardShadow: true,
      child: IntrinsicWidth(
        child: Column(
          spacing: 20,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              spacing: 10,
              children: [
                Text(
                  title,
                  style: AppTheme.text.copyWith(
                    color: AppTheme.steelMist,
                    fontWeight: getFontWeight(500),
                  ),
                ),
                SVGImagePlaceHolder(
                  imagePath: imagePath,
                  size: 16,
                  color: AppTheme.vividRose,
                ),
              ],
            ),
            Row(
              spacing: 10,
              children: [
                Text(
                  value,
                  style: AppTheme.text.copyWith(
                    fontSize: 24.0,
                    fontWeight: getFontWeight(700),
                  ),
                ),
                if (value == '0')
                  StarRows(fullStars: 4, halfStars: 1)
                else
                  Text(
                    value == '0' ? 'product' : 'this month',
                    style: AppTheme.text.copyWith(color: AppTheme.steelMist),
                  ),
              ],
            ),

            Row(
              spacing: 10,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  footer,
                  style: AppTheme.text.copyWith(color: AppTheme.steelMist),
                ),
                if (isNotNull(percentage))
                  Row(
                    spacing: 3,
                    children: [
                      SVGImagePlaceHolder(imagePath: Images.arrowUp, size: 12),
                      Text(
                        '$percentage%',
                        style: AppTheme.text.copyWith(
                          color: AppTheme.jungleGreen,
                          fontSize: 12.0,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
