import 'package:navinotes/packages.dart';
import 'vm.dart';
import 'widget.dart';

class AboutMeAside extends StatelessWidget {
  const AboutMeAside({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AboutMeVm>(
      builder: (_, vm, _) {
        double gap = 30;
        Widget horizontalView = Column(
          spacing: gap,
          children: [_profilePreviewer(vm), _proTip()],
        );
        return Padding(
          padding: const EdgeInsets.only(bottom: 30),
          child: ResponsiveSection(mobile: horizontalView),
        );
      },
    );
  }

  Widget _profilePreviewer(AboutMeVm vm) {
    return CustomCard(
      padding: EdgeInsets.all(25),
      child: Column(
        spacing: 15,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Profile Preview',
            style: AppTheme.text.copyWith(
              fontSize: 16.0,
              fontWeight: getFontWeight(500),
            ),
          ),
          Container(
            decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                side: BorderSide(color: AppTheme.lightGray),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 20,
              children: [
                Row(
                  spacing: 15,
                  children: [
                    AboutMeProfilePic(),
                    Expanded(
                      child: Column(
                        spacing: 5,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ValueListenableBuilder(
                            valueListenable: vm.nameController,
                            builder: (_, controller, __) {
                              return Text(
                                controller.text,
                                style: AppTheme.text.copyWith(
                                  fontSize: 16.0,
                                  fontWeight: getFontWeight(500),
                                ),
                              );
                            },
                          ),
                          ValueListenableBuilder(
                            valueListenable: vm.educationLevelController,
                            builder: (_, educationLevelController, __) {
                              return ValueListenableBuilder(
                                valueListenable: vm.roleController,
                                builder: (_, roleController, __) {
                                  String role = roleController.text;
                                  String educationLevel =
                                      educationLevelController.text;
                                  return Text(
                                    '$role ${role.isNotEmpty && educationLevel.isNotEmpty ? "•" : ""} $educationLevel',
                                    style: AppTheme.text.copyWith(
                                      color: AppTheme.stormGray,
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'Uses ${AppStrings.appName} for:',
                        style: AppTheme.text.copyWith(
                          color: AppTheme.stormGray,
                        ),
                      ),
                      TextSpan(
                        text: vm.selectedApplicationReasons
                            .map((e) => e.shortName())
                            .join(", "),
                        // text: ' Studying, Research, Notes',
                        style: AppTheme.text.copyWith(
                          color: AppTheme.vividRose,
                        ),
                      ),
                    ],
                  ),
                ),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children:
                      ['Study Tips', 'Research Tools', 'Note Templates']
                          .map(
                            (str) => CustomTag(
                              str,
                              color: AppTheme.pastelBloom,
                              textColor: AppTheme.vividRose,
                            ),
                          )
                          .toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _proTip() {
    return CustomCard(
      decoration: BoxDecoration(
        color: AppTheme.pastelBloom,
        border: Border.all(color: AppTheme.paleBlue),
      ),
      padding: EdgeInsets.all(30),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 20,
        children: [
          SVGImagePlaceHolder(imagePath: Images.logo, size: 34),
          Expanded(
            child: Stack(
              children: [
                Positioned(
                  top: 16,
                  left: 0,
                  child: CustomCard(
                    height: 20,
                    width: 10,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                      border: Border(),
                    ),
                  ),
                ),

                CustomCard(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.all(20),
                  margin: EdgeInsets.only(left: 8),
                  child: Text(
                    'We value your privacy. Your information is never shared with third parties.',
                    style: AppTheme.text.copyWith(color: AppTheme.black),
                  ),
                ),
                Positioned(
                  top: 16,
                  left: 0,
                  child: CustomCard(
                    height: 20,
                    width: 20,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                      border: Border(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
