import 'package:navinotes/packages.dart';

//TODO return to this
class BoardLightAcadTimelineItem extends StatelessWidget {
  const BoardLightAcadTimelineItem(
    this.timelineItem, {
    super.key,
    this.onEdit,
    this.onDelete,
  });
  final CourseTimeline timelineItem;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  
  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('MMM d, yyyy').format(date);
    } catch (e) {
      return dateStr;
    }
  }
  
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
            child: Padding(
              padding: EdgeInsets.only(bottom: 24),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: 4,
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
                              if (timelineItem.date != null && timelineItem.date!.isNotEmpty)
                                Text(
                                  _formatDate(timelineItem.date!),
                                  style: TextStyle(
                                    color: const Color(0x99654321),
                                    fontSize: 14,
                                    fontFamily: 'EB Garamond',
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                            ],
                          ),
                        ),
                        if (onEdit != null || onDelete != null)
                          Row(
                            spacing: 4,
                            children: [
                              if (onEdit != null)
                                IconButton(
                                  icon: Icon(Icons.edit, size: 18, color: const Color(0xFFD4AF37)),
                                  onPressed: onEdit,
                                  padding: EdgeInsets.all(4),
                                  constraints: const BoxConstraints(),
                                  tooltip: 'Edit',
                                ),
                              if (onDelete != null)
                                IconButton(
                                  icon: Icon(Icons.delete, size: 18, color: const Color(0xFFE57373)),
                                  onPressed: onDelete,
                                  padding: EdgeInsets.all(4),
                                  constraints: const BoxConstraints(),
                                  tooltip: 'Delete',
                                ),
                            ],
                          ),
                      ],
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
                                  (timelineItem.assignment != null &&
                                          timelineItem.assignment!.isNotEmpty)
                                      ? timelineItem.assignment!
                                      : 'No assignment',
                                  style: TextStyle(
                                    color: const Color(0xFF654321),
                                    fontSize: 16,
                                    fontFamily: 'EB Garamond',
                                    fontWeight: FontWeight.w400,
                                    height: 1.50,
                                  ),
                                ),
                              ),
                              if (timelineItem.due != null &&
                                  timelineItem.due!.isNotEmpty)
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0x33D4AF37),
                                    // : const Color(0xFFF5F2E8),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    'Due: ${timelineItem.due ?? ''}',
                                    style: TextStyle(
                                      color: const Color(0xFF8B4513),
                                      fontSize: 12,
                                      fontFamily: 'Open Sans',
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ],
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
}
