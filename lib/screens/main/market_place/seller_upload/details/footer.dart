import 'package:navinotes/packages.dart';

class SellerUploadFooter extends StatelessWidget {
  const SellerUploadFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final textStyle = AppTheme.text.copyWith(color: AppTheme.stormGray);
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppTheme.lightAsh,
        border: Border(top: BorderSide(color: AppTheme.lightGray)),
      ),
      child: LayoutBuilder(
        builder: (_, constraints) {
          return ScrollableController(
            scrollDirection: Axis.horizontal,
            child: Container(
              padding: const EdgeInsets.all(20),
              constraints: BoxConstraints(minWidth: constraints.maxWidth),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                spacing: 35,
                children: [
                  Text(
                    '© 2025 NueroNote. All rights reserved.',
                    style: textStyle,
                  ),
                  Row(
                    spacing: 15,
                    children:
                        ['Help Center', 'Privacy Policy', 'Terms of Service']
                            .map(
                              (str) => AppButton.text(
                                onTap: () {},
                                text: str,
                                style: textStyle,
                              ),
                            )
                            .toList(),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
