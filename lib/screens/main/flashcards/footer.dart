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

      child: LayoutBuilder(
        builder: (_, constraints) {
          return ScrollableController(
            scrollDirection: Axis.horizontal,
            child: Container(
              padding: const EdgeInsets.all(10),
              constraints: BoxConstraints(minWidth: constraints.maxWidth),
              child: Row(
                spacing: 40,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    spacing: 15,
                    children: [
                      AppButton(
                        onTap: () {},
                        mainAxisSize: MainAxisSize.min,
                        text: 'Add Card',
                        minHeight: 40,
                        color: AppTheme.primaryColor,
                        prefix: Icon(
                          Icons.add,
                          size: 18,
                          color: AppTheme.white,
                        ),
                      ),
                      AppButton(
                        onTap: () {},
                        mainAxisSize: MainAxisSize.min,
                        text: 'Save Deck',
                        minHeight: 40,
                        spacing: 10,
                        prefix: SVGImagePlaceHolder(
                          imagePath: Images.sdCard2,
                          size: 16,
                          color: AppTheme.white,
                        ),
                      ),
                    ],
                  ),

                  Row(
                    spacing: 15,
                    children: [
                      AppButton.secondary(
                        onTap: () {},
                        mainAxisSize: MainAxisSize.min,
                        text: 'Deck Settings',
                        minHeight: 40,
                        color: AppTheme.lightGray,
                        spacing: 10,
                        prefix: SVGImagePlaceHolder(
                          imagePath: Images.settings,
                          size: 14,
                          color: AppTheme.darkSlateGray,
                        ),
                        textColor: AppTheme.darkSlateGray,
                      ),
                      AppButton(
                        onTap: () {},
                        mainAxisSize: MainAxisSize.min,
                        text: 'Study Now',
                        minHeight: 40,
                        spacing: 10,
                        color: AppTheme.iceBlue,
                        borderColor: AppTheme.lightGray,
                        prefix: SVGImagePlaceHolder(
                          imagePath: Images.cap,
                          size: 16,
                          color: AppTheme.vividRose,
                        ),
                        textColor: AppTheme.vividRose,
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
