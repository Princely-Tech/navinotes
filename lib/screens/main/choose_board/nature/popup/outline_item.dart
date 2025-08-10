import 'package:navinotes/packages.dart';

class BoardNatureOutlineItem extends StatelessWidget {
  const BoardNatureOutlineItem(this.index, {super.key});
  final int index;
  @override
  Widget build(BuildContext context) {
    return Consumer<BoardEditVm>(
      builder: (_, vm, _) {
        Color color = getRandomListElement([
          const Color(0xFF4A7C59),
          const Color(0xFF8B7355),
          const Color(0xFF9CAF88),
        ]);
        Widget divider = _timeLineDivider(color: color);
        CrossAxisAlignment alignment =
            isEven(index) ? CrossAxisAlignment.start : CrossAxisAlignment.end;
        List<CourseTimeline> courseOutlines = vm.board.courseTimeLines ?? [];
        CourseTimeline timelineItem = courseOutlines[index];
        bool isLast = index == courseOutlines.length - 1;
        return Consumer<LayoutProviderVm>(
          builder: (_, layoutVm, _) {
            bool show2 = getDeviceResponsiveValue(
              deviceType: layoutVm.deviceType,
              mobile: false,
              tablet: true,
              // laptop: true,
            );

            return IntrinsicHeight(
              child: Row(
                spacing: 32,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (alignment == CrossAxisAlignment.end && show2) ...[
                    Expanded(child: SizedBox()),
                    divider,
                  ],
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                        bottom:
                            isLast
                                ? 0
                                : show2
                                ? 50
                                : 20,
                      ),
                      child: Column(
                        crossAxisAlignment:
                            alignment == CrossAxisAlignment.start
                                ? CrossAxisAlignment.end
                                : CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: show2 ? null : double.infinity,
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: color.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: color.withValues(alpha: 0.3),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${timelineItem.week}: ${timelineItem.title}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontFamily: 'Crimson Text',
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),

                                if (isNotNull(timelineItem.description)) ...[
                                  SizedBox(height: 8),
                                  Text(
                                    timelineItem.description!,
                                    style: TextStyle(
                                      color: Colors.white.withValues(
                                        alpha: 0.8,
                                      ),
                                      fontSize: 16,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  SizedBox(height: 16),
                                ],

                                if (isNotNull(timelineItem.assignment)) ...[
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: color.withValues(alpha: 0.3),
                                      borderRadius: BorderRadius.circular(9999),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.assignment,
                                          size: 16,
                                          color: Colors.white,
                                        ),
                                        SizedBox(width: 8),
                                        Flexible(
                                          child: Text(
                                            timelineItem.assignment!,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                                if (isNotNull(timelineItem.due)) ...[
                                  SizedBox(height: 8),
                                  Text(
                                    timelineItem.due!,
                                    style: TextStyle(
                                      color: Colors.white.withValues(
                                        alpha: 0.6,
                                      ),
                                      fontSize: 14,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (alignment == CrossAxisAlignment.start && show2) ...[
                    divider,
                    Expanded(child: SizedBox()),
                  ],
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _timeLineDivider({required Color color}) {
    return Stack(
      children: [
        Center(child: VerticalDivider(color: const Color(0x4C9CAF88))),
        Padding(
          padding: const EdgeInsets.only(top: 32),
          child: Container(
            width: 15,
            height: 15,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              // border: Border.all(width: 4, color: const Color(0xFF2D5016)),
            ),
          ),
        ),
      ],
    );
  }
}
