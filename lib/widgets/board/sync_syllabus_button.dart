import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:navinotes/packages.dart';
import 'package:navinotes/services/calendar_sync_service.dart';
import 'package:navinotes/services/calendar_service.dart';

class SyncSyllabusButton extends StatefulWidget {
  final Board board;
  final Color? buttonColor;
  final Color? textColor;
  final Color? iconColor;

  const SyncSyllabusButton({
    super.key,
    required this.board,
    this.buttonColor,
    this.textColor,
    this.iconColor,
  });

  @override
  State<SyncSyllabusButton> createState() => _SyncSyllabusButtonState();
}

class _SyncSyllabusButtonState extends State<SyncSyllabusButton> {
  final CalendarService _calendarService = CalendarService();
  final CalendarSyncService _syncService = CalendarSyncService();
  bool _isSyncing = false;

  @override
  Widget build(BuildContext context) {
    final isConnected = _calendarService.isDeviceConnected || _calendarService.isGoogleConnected;

    return ElevatedButton.icon(
      onPressed: _isSyncing ? null : () => _handleSync(context),
      icon: _isSyncing
          ? SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  widget.iconColor ?? Colors.white,
                ),
              ),
            )
          : Icon(
              isConnected ? Icons.sync : Icons.calendar_today,
              size: 18,
              color: widget.iconColor ?? Colors.white,
            ),
      label: Text(
        _isSyncing
            ? 'Syncing...'
            : isConnected
                ? 'Sync to Calendar'
                : 'Connect Calendar',
        style: TextStyle(
          color: widget.textColor ?? Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: widget.buttonColor ?? AppTheme.vividRose,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Future<void> _handleSync(BuildContext context) async {
    final isConnected = _calendarService.isDeviceConnected || _calendarService.isGoogleConnected;

    if (!isConnected) {
      _showCalendarConnectionDialog(context);
      return;
    }

    // Check if there are any timeline items with dates
    final courseTimelines = widget.board.courseTimeLines ?? [];
    if (courseTimelines.isEmpty) {
      MessageDisplayService.showMessage(
        context,
        'No syllabus items to sync',
        isError: true,
      );
      return;
    }

    final itemsWithDates = courseTimelines.where((timeline) {
      return timeline.date != null || timeline.due != null;
    }).toList();

    if (itemsWithDates.isEmpty) {
      MessageDisplayService.showMessage(
        context,
        'No syllabus items with dates found',
        isError: true,
      );
      return;
    }

    // Check if already synced
    if (widget.board.lastCalendarSyncAt != null) {
      final lastSyncDate = DateTime.fromMillisecondsSinceEpoch(
        widget.board.lastCalendarSyncAt! * 1000,
      );
      final shouldResync = await _showResyncConfirmationDialog(context, lastSyncDate);
      if (!shouldResync) return;
    }

    setState(() => _isSyncing = true);

    try {
      final success = await _syncService.syncBoardToCalendar(widget.board);

      if (!mounted) return;

      if (success) {
        // Update board with sync timestamp
        final updatedBoard = widget.board.copyWith(
          lastCalendarSyncAt: DateTime.now().millisecondsSinceEpoch ~/ 1000,
          updatedAt: DateTime.now().millisecondsSinceEpoch ~/ 1000,
        );
        await DatabaseHelper.instance.updateBoard(updatedBoard);

        MessageDisplayService.showMessage(
          context,
          'Syllabus synced to calendar successfully!',
          isError: false,
        );
      } else {
        MessageDisplayService.showMessage(
          context,
          'Failed to sync syllabus to calendar',
          isError: true,
        );
      }
    } catch (e) {
      if (!mounted) return;
      MessageDisplayService.showMessage(
        context,
        'Error syncing to calendar: $e',
        isError: true,
      );
    } finally {
      if (mounted) {
        setState(() => _isSyncing = false);
      }
    }
  }

  Future<bool> _showResyncConfirmationDialog(BuildContext context, DateTime lastSyncDate) async {
    final timeAgo = _getTimeAgo(lastSyncDate);
    
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.orange),
            const SizedBox(width: 12),
            const Text('Already Synced'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'This syllabus was last synced $timeAgo.',
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 12),
            const Text(
              'Syncing again will create duplicate events in your calendar.',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Do you want to continue?',
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
            ),
            child: const Text('Sync Anyway'),
          ),
        ],
      ),
    ) ?? false;
  }

  String _getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
    } else {
      return 'just now';
    }
  }

  void _showCalendarConnectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.calendar_today, color: AppTheme.vividRose),
            const SizedBox(width: 12),
            const Text('Connect Calendar'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Connect your calendar to sync syllabus items and assignments.',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            const Text(
              'Choose a calendar provider:',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton.icon(
            onPressed: () async {
              Navigator.of(context).pop();
              await _connectDeviceCalendar(context);
            },
            icon: const Icon(Icons.phone_android, size: 18),
            label: const Text('Device Calendar'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.vividBlue,
            ),
          ),
          // Only show Google Calendar option on Android and Web
          if (!kIsWeb && !Platform.isIOS)
            ElevatedButton.icon(
              onPressed: () async {
                Navigator.of(context).pop();
                await _connectGoogleCalendar(context);
              },
              icon: const Icon(Icons.cloud, size: 18),
              label: const Text('Google Calendar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.vividRose,
              ),
            ),
          if (kIsWeb)
            ElevatedButton.icon(
              onPressed: () async {
                Navigator.of(context).pop();
                await _connectGoogleCalendar(context);
              },
              icon: const Icon(Icons.cloud, size: 18),
              label: const Text('Google Calendar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.vividRose,
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _connectDeviceCalendar(BuildContext context) async {
    setState(() => _isSyncing = true);

    try {
      final success = await _calendarService.connectToDeviceCalendar();

      if (!mounted) return;

      if (success) {
        // Show calendar selection if needed
        final calendars = await _calendarService.getCalendars();
        if (calendars.isNotEmpty && mounted) {
          _showCalendarSelectionDialog(context, calendars);
        }
      } else {
        MessageDisplayService.showMessage(
          context,
          'Failed to connect to device calendar',
          isError: true,
        );
      }
    } catch (e) {
      if (!mounted) return;
      MessageDisplayService.showMessage(
        context,
        'Error connecting to device calendar: $e',
        isError: true,
      );
    } finally {
      if (mounted) {
        setState(() => _isSyncing = false);
      }
    }
  }

  Future<void> _connectGoogleCalendar(BuildContext context) async {
    setState(() => _isSyncing = true);

    try {
      final success = await _calendarService.connectToGoogleCalendar();

      if (!mounted) return;

      if (success) {
        MessageDisplayService.showMessage(
          context,
          'Connected to Google Calendar successfully!',
          isError: false,
        );
      } else {
        MessageDisplayService.showMessage(
          context,
          'Failed to connect to Google Calendar',
          isError: true,
        );
      }
    } catch (e) {
      if (!mounted) return;
      MessageDisplayService.showMessage(
        context,
        'Error connecting to Google Calendar: $e',
        isError: true,
      );
    } finally {
      if (mounted) {
        setState(() => _isSyncing = false);
      }
    }
  }

  void _showCalendarSelectionDialog(BuildContext context, List calendars) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Calendar'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: calendars.map<Widget>((cal) {
            return ListTile(
              title: Text(cal.name ?? 'Unnamed Calendar'),
              onTap: () {
                _calendarService.selectCalendar(cal.id);
                Navigator.of(context).pop();
                MessageDisplayService.showMessage(
                  context,
                  'Calendar selected: ${cal.name}',
                  isError: false,
                );
              },
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
}
