import 'package:navinotes/packages.dart';

class BoardMinimalistOutlineItem extends StatelessWidget {
  const BoardMinimalistOutlineItem(
    this.courseTimeline, {
    super.key,
    this.onEdit,
    this.onDelete,
  });
  final CourseTimeline courseTimeline;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    int? progress = getSessionProgress(courseTimeline);

    Color statusColor = const Color(0xFF00555A);

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
          if (onEdit != null || onDelete != null)
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (onEdit != null)
                  IconButton(
                    icon: Icon(Icons.edit, size: 18, color: const Color(0xFF00555A)),
                    onPressed: onEdit,
                    padding: EdgeInsets.all(4),
                    constraints: const BoxConstraints(),
                    tooltip: 'Edit',
                  ),
                if (onDelete != null)
                  IconButton(
                    icon: Icon(Icons.delete, size: 18, color: Colors.red),
                    onPressed: onDelete,
                    padding: EdgeInsets.all(4),
                    constraints: const BoxConstraints(),
                    tooltip: 'Delete',
                  ),
              ],
            ),
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
                  color: const Color(0x1900555A),
                  borderRadius: BorderRadius.circular(2),
                ),
                child: Text(
                  courseTimeline.due ?? '',
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
          if (hasText(courseTimeline.assignment)) ...[
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
              color: const Color(0xFF00555A),
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
        ],
      ),
    );
  }
}
