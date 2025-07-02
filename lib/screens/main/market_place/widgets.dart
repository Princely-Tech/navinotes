import 'package:navinotes/packages.dart';

class RichTextHeader extends StatelessWidget {
  const RichTextHeader({super.key, required this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
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
                      text: title,
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
