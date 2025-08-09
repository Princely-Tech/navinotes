import 'package:navinotes/packages.dart';

class BoardDarkAcadTimelineItem extends StatelessWidget {
  const BoardDarkAcadTimelineItem(
    this.courseTimeline, {
    super.key,
    this.isFirst = false,
  });
  final CourseTimeline courseTimeline;
  final bool isFirst;
  @override
  Widget build(BuildContext context) {
    final padding = EdgeInsets.only(top: isFirst ? 0 : 40);
    return IntrinsicHeight(
      child: ResponsiveSection(
        mobile: Row(
          spacing: 30,
          children: [
            _timelineDivider(),
            Expanded(
              child: Padding(
                padding: padding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 20,
                  children: [
                    _timelineLeft(
                      description: courseTimeline.description,
                      title: courseTimeline.title,
                      week: courseTimeline.week,
                    ),
                    _timeLineRight(
                      assignment: courseTimeline.assignment,
                      dueDate: courseTimeline.due,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        laptop: Row(
          spacing: 30,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Padding(
                padding: padding,
                child: _timelineLeft(
                  description: courseTimeline.description,
                  title: courseTimeline.title,
                  week: courseTimeline.week,
                ),
              ),
            ),
            _timelineDivider(),
            Expanded(
              child: Padding(
                padding: padding,
                child: _timeLineRight(
                  assignment: courseTimeline.assignment,
                  dueDate: courseTimeline.due,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _timelineLeft({
    required String week,
    required String title,
    required String? description,
  }) {
    return Consumer<LayoutProviderVm>(
      builder: (_, layoutVm, _) {
        final textAlign = getDeviceResponsiveValue(
          deviceType: layoutVm.deviceType,
          mobile: TextAlign.start,
          laptop: TextAlign.end,
        );
        return Column(
          crossAxisAlignment: getDeviceResponsiveValue(
            deviceType: layoutVm.deviceType,
            mobile: CrossAxisAlignment.start,
            laptop: CrossAxisAlignment.end,
          ),
          spacing: 16,
          children: [
            Text(
              week,
              style: TextStyle(
                color: const Color(0xFFC19B47),
                fontSize: 16,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w500,
                height: 1.50,
              ),
            ),

            Text(
              title,
              textAlign: textAlign,
              style: TextStyle(
                color: const Color(0xFFF7F3E9),
                fontSize: 24,
                fontFamily: 'Playfair Display',
                fontWeight: FontWeight.w600,
                height: 1.33,
              ),
            ),

            if (isNotNull(description))
              Text(
                description!,
                textAlign: textAlign,
                style: TextStyle(
                  color: const Color(0xB2F7F3E9),
                  fontSize: 16,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                  height: 1.50,
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _timeLineRight({
    required String? assignment,
    required String? dueDate,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF4A3426),
            borderRadius: BorderRadius.circular(2),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 16,
            children: [
              Text(
                'Assignment',
                style: TextStyle(
                  color: const Color(0xFFF7F3E9),
                  fontSize: 16,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (isNotNull(assignment))
                Text(
                  assignment!,
                  style: TextStyle(
                    color: const Color(0xB2F7F3E9),
                    fontSize: 14,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              Text(
                'Due: $dueDate',
                style: TextStyle(
                  color: const Color(0xFFC19B47),
                  fontSize: 12,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _timelineDivider() {
    return Stack(
      children: [
        Positioned(
          left: 0,
          right: 0,
          top: 0,
          bottom: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              VerticalDivider(width: 1, color: const Color(0x4CC19B47)),
            ],
          ),
        ),
        Center(
          child: OutlinedChild(
            size: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFC19B47),
              shape: BoxShape.circle,
            ),
            child: SVGImagePlaceHolder(
              imagePath: Images.book,
              color: const Color(0xFF2B1810),
              size: 16,
            ),
          ),
        ),
      ],
    );
  }
}
