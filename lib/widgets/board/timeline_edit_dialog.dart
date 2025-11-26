import 'package:flutter/material.dart';
import 'package:navinotes/models/course_timeline.dart';

class TimelineEditDialog extends StatefulWidget {
  final CourseTimeline timeline;
  final Function(CourseTimeline) onSave;

  const TimelineEditDialog({
    super.key,
    required this.timeline,
    required this.onSave,
  });

  @override
  State<TimelineEditDialog> createState() => _TimelineEditDialogState();
}

class _TimelineEditDialogState extends State<TimelineEditDialog> {
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
      
      title: const Text('Edit Timeline Item'),
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
                hintText: 'e.g., Chapter 1-3',
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
