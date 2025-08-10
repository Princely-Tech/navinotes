import 'package:navinotes/packages.dart';

class BoardMinimalistOutlineItem extends StatelessWidget {
  const BoardMinimalistOutlineItem(this.courseTimeline, {super.key});
  final CourseTimeline courseTimeline;
  @override
  Widget build(BuildContext context) {
    int? progress = getSessionProgress(courseTimeline);

    String status;
    if (progress == null) {
      status = 'Not Started';
    } else if (progress > 0) {
      status = 'In Progress';
    } else {
      status = 'Not Started';
    }

    bool isInProgress = status == 'In Progress';
    Color statusColor;
    if (isInProgress) {
      statusColor = const Color(0xFF00555A);
    } else {
      statusColor = const Color(0xFF6B6B6B);
    }
    return Container(
      padding: EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFF0F0F0)),
        borderRadius: BorderRadius.circular(2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            spacing: 15,
            children: [
              Expanded(
                child: Text(
                  courseTimeline.title,
                  style: TextStyle(
                    color: const Color(0xFF2C2C2C),
                    fontSize: 16,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color:
                      isInProgress
                          ? const Color(0x1900555A)
                          : const Color(0xFFF0F0F0),
                  borderRadius: BorderRadius.circular(2),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 12,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
            ],
          ),
          if (isNotNull(courseTimeline.assignment)) ...[
            SizedBox(height: 16),
            Text(
              courseTimeline.assignment!,
              style: TextStyle(
                color: const Color(0xFF2C2C2C),
                fontSize: 14,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
              ),
            ),
          ],

          SizedBox(height: 8),
          Text(
            stringOrNotSpecified(courseTimeline.due, nullPrefix: 'Due date'),
            style: TextStyle(
              color:
                  isInProgress
                      ? const Color(0xFF00555A)
                      : const Color(0xFF6B6B6B),
              fontSize: 12,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w300,
            ),
          ),

          if (isNotNull(progress)) ...[
            SizedBox(height: 16),
            LinearProgressIndicator(
              value: progress!.toDouble(),
              backgroundColor: const Color(0xFFF0F0F0),
              color: const Color(0xFF00555A),
            ),
          ],

          // SizedBox(height: 16),
          // Wrap(
          //   spacing: 8,
          //   runSpacing: 8,
          //   children:
          //       tags
          //           .map(
          //             (tag) => Chip(
          //               label: Text(
          //                 tag,
          //                 style: TextStyle(
          //                   color: const Color(0xFF2C2C2C),
          //                   fontSize: 12,
          //                   fontFamily: 'Inter',
          //                   fontWeight: FontWeight.w300,
          //                 ),
          //               ),
          //               backgroundColor: const Color(0xFFF0F0F0),
          //               materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          //               visualDensity: VisualDensity.compact,
          //             ),
          //           )
          //           .toList(),
          // ),
        ],
      ),
    );
  }
}
