import 'package:flutter/material.dart';
import 'package:navinotes/settings/apptheme.dart';
import 'package:navinotes/settings/images.dart';
import 'package:navinotes/widgets/components.dart';

class AboutMeAside extends StatelessWidget {
  const AboutMeAside({super.key});

  @override
  Widget build(BuildContext context) {
    double gap = 30;
    Widget mobileView = Column(
      spacing: gap,
      children: [_whyShare(), _proTip(), _profilePreviewer()],
    );
    return Padding(
      padding: const EdgeInsets.only(bottom: 30),
      child: ResponsiveSection(
        mobile: mobileView,
        desktops: mobileView,
        laptops: Column(
          spacing: gap,
          children: [
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: gap,
                children: [
                  Expanded(child: _whyShare()),
                  Expanded(child: _proTip()),
                ],
              ),
            ),
            _profilePreviewer(),
          ],
        ),
      ),
    );
  }

  Widget _profilePreviewer() {
    return Container(
      decoration: ShapeDecoration(
        color: Apptheme.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Apptheme.lightGray),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      padding: EdgeInsets.all(25),
      child: Column(
        spacing: 15,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Profile Preview',
            style: Apptheme.text.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w500,
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
                    SVGImagePlaceHolder(
                      imagePath: Images.logoRounded2,
                      size: 48,
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
                              fontWeight: FontWeight.w500,
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
                        text: 'Uses MindMapper for:',
                        style: Apptheme.text.copyWith(
                          color: Apptheme.stormGray,
                        ),
                      ),
                      TextSpan(
                        text: ' Studying, Research, Notes',
                        style: Apptheme.text.copyWith(
                          color: Apptheme.strongBlue,
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
                            (str) => Flexible(
                              child: Container(
                                decoration: ShapeDecoration(
                                  color: Apptheme.paleBlue,
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                      color: Apptheme.whisperGrey,
                                    ),
                                    borderRadius: BorderRadius.circular(9999),
                                  ),
                                ),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 5,
                                ),
                                child: Text(
                                  str,
                                  style: Apptheme.text.copyWith(
                                    color: Apptheme.electricIndigo,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
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
    return Container(
      decoration: ShapeDecoration(
        color: const Color(0xFFEFF6FF),
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 1, color: const Color(0xFFDBEAFE)),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      padding: EdgeInsets.all(30),
      child: Row(
        children: [
          ImagePlaceHolder(imagePath: Images.brainPers, size: 48),
          Expanded(
            child: Container(
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: const Color(0xFFE5E7EB)),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              padding: EdgeInsets.all(20),
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'Pro Tip:',
                      style: TextStyle(
                        color: const Color(0xFF374151),
                        fontSize: 14,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w700,
                        height: 1,
                      ),
                    ),
                    TextSpan(
                      text:
                          'Students who complete their profiles are 3x more likely to find study partners within the app!',
                      style: TextStyle(
                        color: const Color(0xFF374151),
                        fontSize: 14,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _whyShare() {
    TextStyle tileStyle = TextStyle(
      color: const Color(0xFF4B5563),
      fontSize: 16,
      fontFamily: 'Inter',
      fontWeight: FontWeight.w400,
      height: 1.5,
    );
    return Container(
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: const Color(0xFFE5E7EB)),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      padding: EdgeInsets.all(15),
      child: Column(
        spacing: 15,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ExpansionTile(
            initiallyExpanded: true,
            title: Text(
              'Why Share This Info?',
              style: TextStyle(
                color: const Color(0xFF1F2937),
                fontSize: 16,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w500,
                height: 1,
              ),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            children: <Widget>[
              ListTile(
                // dense: true,
                minVerticalPadding: 10,
                title: Text(
                  'Sharing your information helps us to:',
                  style: tileStyle,
                ),
              ),
              ListTile(
                minVerticalPadding: 0,
                contentPadding: EdgeInsets.only(left: 40),
                title: Text(
                  'Customize templates based on your field of study\nSuggest relevant study techniques\nConnect you with similar users for collaboration\nProvide personalized content recommendations',
                  style: tileStyle,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              'We value your privacy. Your information is never shared with third parties.',
              style: TextStyle(
                color: Colors.black,
                fontSize: 12,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
