import 'package:navinotes/packages.dart';
import 'package:navinotes/services/calendar_sync_service.dart';
import 'package:navinotes/utils/date_normalizer.dart';

/// Reusable widget for displaying and managing syllabus/course timeline
class SyllabusSection extends StatelessWidget {
  final Board board;
  final Function(List<CourseTimeline>) onUpdate;
  final Color primaryColor;
  final Color backgroundColor;

  const SyllabusSection({
    super.key,
    required this.board,
    required this.onUpdate,
    required this.primaryColor,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final courseOutlines = board.courseTimeLines ?? [];
    
    if (courseOutlines.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Course Timeline',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
            _buildSyncButton(context),
          ],
        ),
        const SizedBox(height: 16),
        ...courseOutlines.asMap().entries.map((entry) {
          final index = entry.key;
          final timeline = entry.value;
          return _buildTimelineItem(context, timeline, index);
        }).toList(),
      ],
    );
  }

  Widget _buildSyncButton(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () => _syncToCalendar(context),
      icon: const Icon(Icons.sync, size: 18),
      label: const Text('Sync to Calendar'),
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  Widget _buildTimelineItem(BuildContext context, CourseTimeline timeline, int index) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: backgroundColor,
      child: InkWell(
        onTap: () => _editTimeline(context, timeline, index),
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Text(
                          timeline.week,
                          style: TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.w600,
                            color: primaryColor,
                          ),
                        ),
                        if (timeline.date != null && timeline.date!.isNotEmpty) ...[
                          const SizedBox(width: 8),
                          Text(
                            '• ${_formatDate(timeline.date!)}',
                            style: TextStyle(
                              fontSize: 12.0,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.edit, size: 18, color: primaryColor),
                    onPressed: () => _editTimeline(context, timeline, index),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                timeline.title,
                style: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (timeline.description != null && timeline.description!.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  timeline.description!,
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.grey[600],
                  ),
                ),
              ],
              if (timeline.assignment != null && timeline.assignment!.isNotEmpty) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.assignment, size: 16, color: primaryColor),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        timeline.assignment!,
                        style: const TextStyle(fontSize: 14.0),
                      ),
                    ),
                  ],
                ),
              ],
              if (timeline.due != null && timeline.due!.isNotEmpty) ...[
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.calendar_today, size: 16, color: primaryColor),
                    const SizedBox(width: 4),
                    Text(
                      'Due: ${timeline.due}',
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w500,
                        color: primaryColor,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  /// Format date string to a readable format
  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('MMM d, yyyy').format(date);
    } catch (e) {
      // If parsing fails, return the original string
      return dateStr;
    }
  }

  void _editTimeline(BuildContext context, CourseTimeline timeline, int index) {
    showDialog(
      context: context,
      builder: (context) => _EditTimelineDialog(
        timeline: timeline,
        primaryColor: primaryColor,
        onSave: (updated) {
          final courseOutlines = List<CourseTimeline>.from(board.courseTimeLines ?? []);
          courseOutlines[index] = updated;
          onUpdate(courseOutlines);
        },
      ),
    );
  }

  Future<void> _syncToCalendar(BuildContext context) async {
    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Syncing to calendar...'),
              ],
            ),
          ),
        ),
      ),
    );

    try {
      // Normalize dates before syncing
      final normalizedTimelines = _normalizeTimelineDates(board.courseTimeLines ?? []);
      
      // Update board with normalized dates
      final updatedBoard = board.copyWith(courseTimeLines: normalizedTimelines);
      await DatabaseHelper.instance.updateBoard(updatedBoard);
      
      // Sync to calendar
      final syncService = CalendarSyncService();
      final success = await syncService.syncBoardToCalendar(updatedBoard);
      
      // Close loading dialog
      if (context.mounted) Navigator.of(context).pop();
      
      // Show result
      if (context.mounted) {
        if (success) {
          MessageDisplayService.showMessage(
            context,
            'Successfully synced to calendar!',
            isError: false,
          );
          onUpdate(normalizedTimelines);
        } else {
          MessageDisplayService.showMessage(
            context,
            'Failed to sync. Please ensure a calendar is connected.',
            isError: true,
          );
        }
      }
    } catch (e) {
      // Close loading dialog
      if (context.mounted) Navigator.of(context).pop();
      
      // Show error
      if (context.mounted) {
        MessageDisplayService.showMessage(
          context,
          'Error syncing to calendar: ${e.toString()}',
          isError: true,
        );
      }
      debugPrint('Error syncing to calendar: $e');
    }
  }

  /// Normalize all timeline dates to proper ISO format
  List<CourseTimeline> _normalizeTimelineDates(List<CourseTimeline> timelines) {
    final dueDates = timelines.map((t) => t.due).toList();
    final normalizedDates = DateNormalizer.normalizeSequence(dueDates);
    
    return timelines.asMap().entries.map((entry) {
      final index = entry.key;
      final timeline = entry.value;
      final normalizedDue = normalizedDates[index];
      
      return timeline.copyWith(due: normalizedDue ?? timeline.due);
    }).toList();
  }
}

class _EditTimelineDialog extends StatefulWidget {
  final CourseTimeline timeline;
  final Color primaryColor;
  final Function(CourseTimeline) onSave;

  const _EditTimelineDialog({
    required this.timeline,
    required this.primaryColor,
    required this.onSave,
  });

  @override
  State<_EditTimelineDialog> createState() => _EditTimelineDialogState();
}

class _EditTimelineDialogState extends State<_EditTimelineDialog> {
  late TextEditingController _weekController;
  late TextEditingController _dateController;
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _assignmentController;
  late TextEditingController _dueController;

  @override
  void initState() {
    super.initState();
    _weekController = TextEditingController(text: widget.timeline.week);
    _dateController = TextEditingController(text: widget.timeline.date ?? '');
    _titleController = TextEditingController(text: widget.timeline.title);
    _descriptionController = TextEditingController(text: widget.timeline.description ?? '');
    _assignmentController = TextEditingController(text: widget.timeline.assignment ?? '');
    _dueController = TextEditingController(text: widget.timeline.due ?? '');
  }

  @override
  void dispose() {
    _weekController.dispose();
    _dateController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    _assignmentController.dispose();
    _dueController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Edit Timeline Item',
        style: TextStyle(color: widget.primaryColor),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _weekController,
              decoration: const InputDecoration(
                labelText: 'Week',
                hintText: 'e.g., Week 1',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _dateController,
              decoration: const InputDecoration(
                labelText: 'Date (optional)',
                hintText: 'e.g., 2024-04-30 or April 30',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                hintText: 'e.g., Introduction to Biology',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description (optional)',
                hintText: 'Brief description',
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _assignmentController,
              decoration: const InputDecoration(
                labelText: 'Assignment (optional)',
                hintText: 'e.g., Chapter 1 Reading',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _dueController,
              decoration: const InputDecoration(
                labelText: 'Due Date (optional)',
                hintText: 'e.g., April 30 or 2024-04-30',
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Supported formats: "April 30", "Apr 30", "2024-04-30", "04/30/2024"',
              style: TextStyle(
                fontSize: 12.0,
                color: Colors.grey[600],
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _save,
          style: ElevatedButton.styleFrom(
            backgroundColor: widget.primaryColor,
            foregroundColor: Colors.white,
          ),
          child: const Text('Save'),
        ),
      ],
    );
  }

  void _save() {
    final updated = widget.timeline.copyWith(
      week: _weekController.text.trim(),
      date: _dateController.text.trim().isEmpty 
          ? null 
          : _dateController.text.trim(),
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim().isEmpty 
          ? null 
          : _descriptionController.text.trim(),
      assignment: _assignmentController.text.trim().isEmpty 
          ? null 
          : _assignmentController.text.trim(),
      due: _dueController.text.trim().isEmpty 
          ? null 
          : _dueController.text.trim(),
    );
    
    widget.onSave(updated);
    Navigator.of(context).pop();
  }
}
