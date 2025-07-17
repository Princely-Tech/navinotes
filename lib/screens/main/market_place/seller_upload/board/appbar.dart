import 'package:navinotes/packages.dart';
import 'vm.dart';

class SellerSelectContentAppBar extends StatelessWidget {
  const SellerSelectContentAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppTheme.white,
        border: Border(bottom: BorderSide(color: AppTheme.lightGray)),
      ),
      child: LayoutBuilder(
        builder: (_, constraints) {
          return Consumer<SellerSelectContentVm>(
            builder: (_, vm, _) {
              return ScrollableController(
                scrollDirection: Axis.horizontal,
                child: ConstrainedBox(
                  constraints: BoxConstraints(minWidth: constraints.maxWidth),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: ResponsiveHorizontalPadding(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        spacing: 20,
                        children: [
                          Consumer<LayoutProviderVm>(
                            builder: (_, layoutVm, _) {
                              return Row(
                                children: [
                                  AppButton.text(
                                    onTap: NavigationHelper.pop,
                                    prefix: Icon(
                                      Icons.arrow_back,
                                      color: AppTheme.darkSlateGray,
                                      size: 20,
                                    ),
                                    color: AppTheme.stormGray,
                                    text: getDeviceResponsiveValue(
                                      deviceType: layoutVm.deviceType,
                                      mobile: 'Back',
                                      laptop: 'Back to My Store Dashboard',
                                    ),
                                  ),
                                  VisibleController(
                                    mobile: false,
                                    tablet: true,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 15),
                                      child: _logoSection(),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                          _trailing(vm),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _logoSection() {
    return Row(
      spacing: 10,
      children: [
        SVGImagePlaceHolder(imagePath: Images.logo, size: 40),
        Column(
          spacing: 5,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'NaviNotes',
              style: AppTheme.text.copyWith(
                color: AppTheme.vividRose,
                fontSize: 24.0,
                fontWeight: getFontWeight(700),
                height: 1.0,
              ),
            ),
            Text(
              'Upload Content for Sale',
              style: AppTheme.text.copyWith(
                color: AppTheme.stormGray,
                height: 1.0,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _trailing(SellerSelectContentVm vm) {
    return Row(
      children: [
        Row(
          spacing: 10,
          children: [
           
            ProfilePic(size: 32),
          ],
        ),
      ],
    );
  }
}
