import 'package:flutter/material.dart';
import 'package:navinotes/settings/index.dart';
import 'package:navinotes/widgets/index.dart';

class AboutMeAside extends StatelessWidget {
  const AboutMeAside({super.key});

  @override
  Widget build(BuildContext context) {
    double gap = 30;
    Widget horizontalView = Column(
      spacing: gap,
      children: [_profilePreviewer(), _proTip()],
      // children: [_whyShare(), _proTip(), _profilePreviewer()],
    );
    return Padding(
      padding: const EdgeInsets.only(bottom: 30),
      child: ResponsiveSection(
        mobile: horizontalView,

        // laptop: Column(
        //   spacing: gap,
        //   children: [
        //     _profilePreviewer(),
        //     _proTip(),
        //     // IntrinsicHeight(
        //     //   child: Row(
        //     //     crossAxisAlignment: CrossAxisAlignment.stretch,
        //     //     spacing: gap,
        //     //     children: [
        //     //       Expanded(child: _whyShare()),
        //     //       Expanded(child: _proTip()),
        //     //     ],
        //     //   ),
        //     // ),
        //   ],
        // ),
      ),
    );
  }

  Widget _profilePreviewer() {
    return CustomCard(
      padding: EdgeInsets.all(25),
      child: Column(
        spacing: 15,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Profile Preview',
            style: Apptheme.text.copyWith(
              fontSize: 16,
              fontWeight: getFontWeight(500),
            ),
          ),
          Container(
            decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Apptheme.lightGray),
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
                    OutlinedChild(
                      size: 55,
                      decoration: BoxDecoration(
                        color: Apptheme.pastelBloom,
                        border: Border.all(color: Apptheme.skyFoam),
                        shape: BoxShape.circle,
                      ),
                      child: SVGImagePlaceHolder(
                        imagePath: Images.logo,
                        size: 22,
                      ),
                    ),
                    Expanded(
                      child: Column(
                        spacing: 5,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Jane Smith',
                            style: Apptheme.text.copyWith(
                              fontSize: 16,
                              fontWeight: getFontWeight(500),
                            ),
                          ),
                          Text(
                            'Student • Undergraduate',
                            style: Apptheme.text.copyWith(
                              color: Apptheme.stormGray,
                            ),
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
                        style: Apptheme.text.copyWith(
                          color: Apptheme.stormGray,
                        ),
                      ),
                      TextSpan(
                        text: ' Studying, Research, Notes',
                        style: Apptheme.text.copyWith(
                          color: Apptheme.vividRose,
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
                              color: Apptheme.pastelBloom,
                              textColor: Apptheme.vividRose,
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
        color: Apptheme.pastelBloom,
        border: Border.all(color: Apptheme.paleBlue),
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
                    style: Apptheme.text.copyWith(color: Apptheme.black),
                  ),
                  // child: Text.rich(
                  //   TextSpan(
                  //     children: [
                  //       TextSpan(
                  //         text: 'Pro Tip:',
                  //         style: Apptheme.text.copyWith(
                  //           color: Apptheme.darkSlateGray,
                  //           fontWeight: FontWeight.w700,
                  //         ),
                  //       ),
                  //       TextSpan(
                  //         text:
                  //             'Students who complete their profiles are 3x more likely to find study partners within the app!',
                  //         style: Apptheme.text.copyWith(
                  //           color: Apptheme.darkSlateGray,
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
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
