import 'package:navinotes/packages.dart';

class SellerUploadAside extends StatelessWidget {
  const SellerUploadAside({super.key, this.isExpandable = true});
  final bool isExpandable;
  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppTheme.whiteSmoke,
        border: Border(left: BorderSide(color: AppTheme.lightGray)),
      ),
      child: Column(
        children: [
          ExpandableController(
            mobile: isExpandable,
            child: ScrollableController(
              mobile: isExpandable,
              mobilePadding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 20,
                children: [
                  Text(
                    'Upload Guidelines',
                    style: TextStyle(
                      color: const Color(0xFF1F2937),
                      fontSize: 16,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  _tipSection(
                    title: 'Tips for Effective Descriptions',
                    tips: [
                      'Be specific about what users will learn',
                      'Highlight unique features of your content',
                      'Mention the problem your content solves',
                      'Include keywords relevant to your subject',
                    ],
                    isCheck: true,
                  ),

                  _tipSection(
                    title: 'Content Quality Checklist',
                    tips: [
                      'All text is free of spelling/grammar errors',
                      'Images are clear and professional',
                      'Content is original or properly licensed',
                      'Information is accurate and up-to- date',
                    ],
                    isCheck: false,
                  ),
                  _visibilityScore(),

                  AppButton(
                    onTap: () {},
                    text: 'Save as Draft',
                    color: AppTheme.lightGray,
                    textColor: AppTheme.darkSlateGray,
                    minHeight: 40,
                    prefix: SVGImagePlaceHolder(
                      imagePath: Images.sdCard,
                      size: 16,
                      color: AppTheme.darkSlateGray,
                    ),
                  ),
                  AppButton(
                    onTap: () {},
                    text: 'Get Help',
                    minHeight: 40,
                    color: AppTheme.paleBlue,
                    textColor: AppTheme.electricIndigo,
                    prefix: SVGImagePlaceHolder(
                      imagePath: Images.ques,
                      size: 16,
                      color: AppTheme.electricIndigo,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _visibilityScore() {
    return _section(
      title: 'Marketplace Visibility Score',
      child: CustomCard(
        addBorder: true,
        decoration: BoxDecoration(
          color: AppTheme.white,
          borderRadius: BorderRadius.circular(4),
        ),
        padding: EdgeInsets.all(10),
        child: Column(
          spacing: 10,
          children: [
            Row(
              spacing: 10,
              children: [
                Expanded(
                  child: Text(
                    'Current Score',
                    style: TextStyle(
                      color: const Color(0xFF4B5563),
                      fontSize: 14,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      height: 1,
                    ),
                  ),
                ),
                Text(
                  'Medium',
                  style: TextStyle(
                    color: const Color(0xFF00555A),
                    fontSize: 14,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                    height: 1,
                  ),
                ),
              ],
            ),
            LinearProgressIndicator(
              value: 3.5 / 10,
              backgroundColor: AppTheme.lightGray,
              borderRadius: BorderRadius.circular(100),
              minHeight: 10,
              color: AppTheme.amber,
            ),
            Text(
              'Complete all required fields and add more details to improve visibility',
              style: TextStyle(
                color: const Color(0xFF6B7280),
                fontSize: 12,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _section({required String title, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10,
      children: [
        Text(
          title,
          style: TextStyle(
            color: const Color(0xFF374151),
            fontSize: 14,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w500,
            height: 1,
          ),
        ),
        child,
      ],
    );
  }

  Widget _tipSection({
    required String title,
    required List<String> tips,
    required bool isCheck,
  }) {
    return _section(
      title: title,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 10,
        children:
            tips
                .map(
                  (str) => Row(
                    spacing: 10,
                    children: [
                      if (isCheck)
                        Icon(Icons.check, color: AppTheme.vividRose, size: 16)
                      else
                        Container(
                          height: 14,
                          width: 14,
                          decoration: BoxDecoration(
                            border: Border.all(color: AppTheme.blueGray),
                            shape: BoxShape.circle,
                          ),
                        ),
                      Expanded(
                        child: Text(
                          str,
                          style: TextStyle(
                            color: const Color(0xFF4B5563),
                            fontSize: 14,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                            height: 1,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
                .toList(),
      ),
    );
  }
}
