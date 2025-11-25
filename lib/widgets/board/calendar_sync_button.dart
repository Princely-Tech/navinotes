import 'package:navinotes/services/calendar_sync_service.dart';
import 'package:navinotes/packages.dart';

class CalendarSyncButton extends StatefulWidget {
  final Board board;
  const CalendarSyncButton(this.board, {super.key});

  @override
  State<CalendarSyncButton> createState() => _CalendarSyncButtonState();
}

class _CalendarSyncButtonState extends State<CalendarSyncButton> {
  final CalendarSyncService _calendarSyncService = CalendarSyncService();
  bool _isSyncing = false;
  bool _isConnected = false;

  @override
  void initState() {
    super.initState();
    _checkCalendarConnection();
  }

  Future<void> _checkCalendarConnection() async {
    final connected = await _calendarSyncService.isCalendarConnected();
    if (mounted) {
      setState(() {
        _isConnected = connected;
      });
    }
  }

  Future<void> _syncToCalendar() async {
    if (!_isConnected) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please connect a calendar first')),
      );
      return;
    }

    setState(() {
      _isSyncing = true;
    });

    try {
      final success = await _calendarSyncService.syncBoardToCalendar(widget.board);
      
      if (mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Synced "${widget.board.name}" to calendar')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to sync to calendar')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSyncing = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppButton(
      onTap: _syncToCalendar,
      text: _isSyncing ? 'Syncing...' : 'Sync to Calendar',
      color: _isConnected ? AppTheme.tropicalTeal : AppTheme.steelMist,
      loading: _isSyncing,
      mainAxisSize: MainAxisSize.min,
    );
  }
}
