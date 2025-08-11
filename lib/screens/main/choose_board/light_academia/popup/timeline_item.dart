import 'package:navinotes/packages.dart';

//TODO return to this
class BoardLightAcadTimelineItem extends StatelessWidget {
  const BoardLightAcadTimelineItem(this.timelineItem, {super.key});
  final CourseTimeline timelineItem;
  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          VisibleController(
            mobile: false,
            tablet: true,
            child: Padding(
              padding: const EdgeInsets.only(right: 15),
              child: Stack(
                children: [
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    top: 0,
                    child: Center(
                      child: Container(
                        width: 2,
                        color: const Color(0x99FFB347),
                      ),
                    ),
                  ),
                  OutlinedChild(
                    size: 32,
                    decoration: BoxDecoration(
                      color: const Color(0xFFD4AF37),
                      shape: BoxShape.circle,
                    ),
                    child: SVGImagePlaceHolder(
                      imagePath: Images.flask,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: CustomCard(
              addCardShadow: true,
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFFFAF7F0),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0x338B4513)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 16,
                children: [
                  Text(
                    '${timelineItem.week}: ${timelineItem.title}',
                    style: TextStyle(
                      color: const Color(0xFF654321),
                      fontSize: 20,
                      fontFamily: 'EB Garamond',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0x7FF0EBE0),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0x198B4513)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          spacing: 15,
                          children: [
                            Expanded(
                              child: Text(
                                timelineItem.description ??
                                    timelineItem.assignment ??
                                    'No assignment',
                                style: TextStyle(
                                  color: const Color(0xFF654321),
                                  fontSize: 16,
                                  fontFamily: 'EB Garamond',
                                  fontWeight: FontWeight.w400,
                                  height: 1.50,
                                ),
                              ),
                            ),
                            // Container(
                            //   padding: EdgeInsets.symmetric(
                            //     horizontal: 8,
                            //     vertical: 4,
                            //   ),
                            //   decoration: BoxDecoration(
                            //     color:
                            //         status == 'In Progress'
                            //             ? const Color(0x33FFB347)
                            //             : status == 'Due Oct 15'
                            //             ? const Color(0x33D4AF37)
                            //             : const Color(0xFFF5F2E8),
                            //     borderRadius: BorderRadius.circular(4),
                            //   ),
                            //   child: Text(
                            //     status,
                            //     style: TextStyle(
                            //       color: const Color(0xFF8B4513),
                            //       fontSize: 12,
                            //       fontFamily: 'Open Sans',
                            //       fontWeight: FontWeight.w400,
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),

                        // if (progress > 0) ...[
                        // SizedBox(height: 16),
                        // LinearProgressIndicator(
                        //   value: 100,
                        //   backgroundColor: const Color(0xFFF5F2E8),
                        //   color: const Color(0xFFD4AF37),
                        // ),
                        // ],

                        // SizedBox(height: 16),
                        // Wrap(
                        //   spacing: 8,
                        //   runSpacing: 8,
                        //   children:
                        //       tags
                        //           .map(
                        //             (tag) => Text(
                        //               tag,
                        //               style: TextStyle(
                        //                 color: const Color(0xFF8B4513),
                        //                 fontSize: 12,
                        //                 fontFamily: 'Open Sans',
                        //                 fontWeight: FontWeight.w400,
                        //               ),
                        //             ),
                        //           )
                        //           .toList(),
                        // ),
                      ],
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
}
