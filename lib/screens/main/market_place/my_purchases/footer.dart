import 'package:navinotes/packages.dart';

class MyPurchasesFooter extends StatelessWidget {
  const MyPurchasesFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppTheme.white,
        border: Border(top: BorderSide(color: AppTheme.lightGray)),
      ),
      padding: const EdgeInsets.all(10),
      child: LayoutBuilder(
        builder: (_, constraints) {
          return Wrap(
            spacing: 30,
            runSpacing: 10,
            alignment: WrapAlignment.spaceBetween,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                spacing: 15,
                children: [
                  _richText(text1: 'Total items:', text2: '14 purchased'),
                  _richText(text1: 'Total investment:', text2: '\$124.85'),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                spacing: 15,
                children: [
                  Flexible(
                    child: Text(
                      'Content for personal use only. No redistribution permitted.',
                      style: AppTheme.text.copyWith(
                        color: AppTheme.steelMist,
                        fontSize: 12.0,
                        height: 1.0,
                      ),
                    ),
                  ),
                  AppButton.text(
                    onTap: () {},
                    text: 'Purchase Support',
                    prefix: SVGImagePlaceHolder(
                      imagePath: Images.headphone,
                      size: 14,
                      color: AppTheme.vividRose,
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _richText({required String text1, required String text2}) {
    final textStyle = AppTheme.text.copyWith(
      color: AppTheme.stormGray,
      height: 1.0,
    );
    return Flexible(
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: '$text1 ',
              style: textStyle.copyWith(fontWeight: FontWeight.w500),
            ),
            TextSpan(text: text2, style: textStyle),
          ],
        ),
      ),
    );
  }
}
