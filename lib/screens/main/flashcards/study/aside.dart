import 'package:navinotes/packages.dart';

class FlashCardStudyAside extends StatelessWidget {
  const FlashCardStudyAside({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(left: BorderSide(width: 1, color: Color(0xFFE5E7EB))),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            Expanded(
              child: ScrollableController(
                mobilePadding: EdgeInsets.symmetric(vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 16,
                  children: [
                    const Text(
                      'Study Session',
                      style: TextStyle(
                        color: Color(0xFF374151),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    // Progress stats
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFF6FF),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 16,
                        children: [
                          const Text(
                            'Current Progress',
                            style: TextStyle(
                              color: Color(0xFF1D4ED8),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: 16,
                            children: [
                              _progressItem(
                                title: 'Cards Reviewed:',
                                value: '3 of 12',
                              ),
                              _progressItem(
                                title: 'Time Spent:',
                                value: '4:23',
                              ),
                              _progressItem(
                                title: 'Avg. Response:',
                                value: '18.5 sec',
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Performance
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 8,
                      children: [
                        const Text(
                          'Performance',
                          style: TextStyle(
                            color: Color(0xFF374151),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),

                        Row(
                          spacing: 8,
                          children: [
                            Expanded(
                              child: LinearProgressIndicator(
                                minHeight: 8,
                                value: 0.65,
                                backgroundColor: const Color(0xFFF0F0F0),
                                borderRadius: BorderRadius.circular(8),
                                color: const Color(0xFF10B981),
                              ),
                            ),

                            const Text(
                              '65%',
                              style: TextStyle(
                                color: Color(0xFF4B5563),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        //
                      ],
                    ),

                    // Rating counts
                    ScrollableController(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        spacing: 5,
                        children: [
                          _buildRatingCount(
                            count: '1',
                            label: 'Again',
                            bgColor: const Color(0xFFFEE2E2),
                            textColor: const Color(0xFFDC2626),
                          ),
                          _buildRatingCount(
                            count: '0',
                            label: 'Hard',
                            bgColor: const Color(0xFFFFEDD5),
                            textColor: const Color(0xFFEA580C),
                          ),
                          _buildRatingCount(
                            count: '2',
                            label: 'Good',
                            bgColor: const Color(0xFFD1FAE5),
                            textColor: const Color(0xFF059669),
                          ),
                          _buildRatingCount(
                            count: '0',
                            label: 'Easy',
                            bgColor: const Color(0xFFD1FAE5),
                            textColor: const Color(0xFF059669),
                          ),
                        ],
                      ),
                    ),
                    Divider(color: AppTheme.lightGray),
                    // Deck information
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 8,
                      children: [
                        const Text(
                          'Deck Information',
                          style: TextStyle(
                            color: Color(0xFF374151),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        _buildInfoRow(Images.calender, 'Created: May 15, 2025'),
                        _buildInfoRow(
                          Images.refresh3,
                          'Last studied: 2 days ago',
                        ),
                        _buildInfoRow(
                          Images.tag,
                          'Tags: physics, mechanics, laws',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Column(
                spacing: 8,
                children: [
                  AppButton(
                    onTap: () {},
                    text: 'View Related Mind Map',
                    minHeight: 40,
                    spacing: 10,
                    prefix: SVGImagePlaceHolder(
                      imagePath: Images.share,
                      color: const Color(0xFF00555A),
                      size: 16,
                    ),
                    textColor: const Color(0xFF00555A),
                    color: const Color(0xFFDBEAFE),
                  ),
                  AppButton(
                    onTap: () {},
                    text: 'Edit FlashCard',
                    minHeight: 40,
                    spacing: 10,
                    prefix: SVGImagePlaceHolder(
                      imagePath: Images.edit,
                      color: const Color(0xFF4B5563),
                      size: 16,
                    ),
                    textColor: Color(0xFF4B5563),
                    color: const Color(0xFFF3F4F6),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _progressItem({required String title, required String value}) {
    return Row(
      spacing: 10,
      children: [
        Flexible(
          child: Text(
            title,
            style: TextStyle(color: Color(0xFF4B5563), fontSize: 14),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: Color(0xFF1F2937),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String icon, String text) {
    return Row(
      spacing: 8,
      children: [
        // Icon(icon, size: 14, color: const Color(0xFF4B5563)),
        SVGImagePlaceHolder(
          imagePath: icon,
          size: 14,
          color: const Color(0xFF4B5563),
        ),
        Text(
          text,
          style: const TextStyle(color: Color(0xFF4B5563), fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildRatingCount({
    required String count,
    required String label,
    required Color bgColor,
    required Color textColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 15),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        spacing: 2,
        children: [
          Text(
            count,
            style: TextStyle(
              color: textColor,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(label, style: TextStyle(color: textColor, fontSize: 12)),
        ],
      ),
    );
  }
}
