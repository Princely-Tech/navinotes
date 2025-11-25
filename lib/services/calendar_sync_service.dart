import 'package:navinotes/services/calendar_service.dart';
import 'package:navinotes/packages.dart';
import 'package:device_calendar/device_calendar.dart';
import 'package:googleapis/calendar/v3.dart' as calendar;
import 'package:http/http.dart' as http;
import 'package:timezone/timezone.dart' as tz;

class CalendarSyncService {
  static final CalendarSyncService _instance = CalendarSyncService._internal();
  factory CalendarSyncService() => _instance;
  CalendarSyncService._internal();

  final CalendarService _calendarService = CalendarService();

  Future<bool> syncBoardToCalendar(Board board) async {
    try {
      if (!_calendarService.isDeviceConnected && !_calendarService.isGoogleConnected) {
        debugPrint('No calendar connection available');
        return false;
      }

      debugPrint('Starting calendar sync for board: ${board.name}');
      
      final syllabusContent = await board.getSyllabusContent();
      if (syllabusContent == null) {
        debugPrint('No syllabus content found for board: ${board.name}');
        return false;
      }

      final courseTimelines = board.courseTimeLines ?? [];
      if (courseTimelines.isEmpty) {
        debugPrint('No course timelines found for board: ${board.name}');
        return false;
      }

      int syncedCount = 0;
      int totalCount = 0;

      for (final timeline in courseTimelines) {
        totalCount++;
        
        if (timeline.assignment != null && timeline.due != null) {
          final success = await _syncAssignmentToCalendar(timeline, board);
          if (success) syncedCount++;
        }

        if (timeline.title.isNotEmpty) {
          final success = await _syncTimelineToCalendar(timeline, board);
          if (success) syncedCount++;
        }
      }

      debugPrint('Calendar sync completed for board ${board.name}: $syncedCount/$totalCount items synced');
      return syncedCount > 0;
    } catch (e) {
      debugPrint('Error syncing board ${board.name} to calendar: $e');
      return false;
    }
  }

  Future<bool> _syncAssignmentToCalendar(CourseTimeline timeline, Board board) async {
    try {
      if (_calendarService.isDeviceConnected) {
        return await _createDeviceAssignmentEvent(timeline, board);
      } else if (_calendarService.isGoogleConnected) {
        return await _createGoogleAssignmentEvent(timeline, board);
      }
      return false;
    } catch (e) {
      debugPrint('Error syncing assignment to calendar: $e');
      return false;
    }
  }

  Future<bool> _syncTimelineToCalendar(CourseTimeline timeline, Board board) async {
    try {
      if (_calendarService.isDeviceConnected) {
        return await _createDeviceTimelineEvent(timeline, board);
      } else if (_calendarService.isGoogleConnected) {
        return await _createGoogleTimelineEvent(timeline, board);
      }
      return false;
    } catch (e) {
      debugPrint('Error syncing timeline to calendar: $e');
      return false;
    }
  }

  Future<bool> _createDeviceAssignmentEvent(CourseTimeline timeline, Board board) async {
    try {
      final selectedCalendarId = _calendarService.selectedCalendarId;
      if (selectedCalendarId == null) {
        debugPrint('No calendar selected for device calendar sync');
        return false;
      }

      final dueDate = DateTime.parse(timeline.due!);
      final event = Event(
        selectedCalendarId,
        title: 'Assignment: ${timeline.assignment}',
        description: _buildEventDescription(timeline, board, isAssignment: true),
        start: tz.TZDateTime.from(dueDate.subtract(const Duration(hours: 1)), tz.local),
        end: tz.TZDateTime.from(dueDate, tz.local),
      );

      final deviceCalendarPlugin = DeviceCalendarPlugin();
      final result = await deviceCalendarPlugin.createOrUpdateEvent(event);
      
      if (result?.isSuccess ?? false) {
        debugPrint('Created device calendar assignment event: ${timeline.assignment}');
        return true;
      } else {
        debugPrint('Failed to create device calendar assignment event: ${result?.errors}');
        return false;
      }
    } catch (e) {
      debugPrint('Error creating device assignment event: $e');
      return false;
    }
  }

  Future<bool> _createDeviceTimelineEvent(CourseTimeline timeline, Board board) async {
    try {
      final selectedCalendarId = _calendarService.selectedCalendarId;
      if (selectedCalendarId == null) {
        debugPrint('No calendar selected for device calendar sync');
        return false;
      }

      final startDate = _parseWeekToDate(timeline.week);
      final event = Event(
        selectedCalendarId,
        title: timeline.title,
        description: _buildEventDescription(timeline, board, isAssignment: false),
        start: tz.TZDateTime.from(startDate, tz.local),
        end: tz.TZDateTime.from(startDate.add(const Duration(hours: 2)), tz.local),
      );

      final deviceCalendarPlugin = DeviceCalendarPlugin();
      final result = await deviceCalendarPlugin.createOrUpdateEvent(event);
      
      if (result?.isSuccess ?? false) {
        debugPrint('Created device calendar timeline event: ${timeline.title}');
        return true;
      } else {
        debugPrint('Failed to create device calendar timeline event: ${result?.errors}');
        return false;
      }
    } catch (e) {
      debugPrint('Error creating device timeline event: $e');
      return false;
    }
  }

  Future<bool> _createGoogleAssignmentEvent(CourseTimeline timeline, Board board) async {
    try {
      final dueDate = DateTime.parse(timeline.due!);
      final event = calendar.Event()
        ..summary = 'Assignment: ${timeline.assignment}'
        ..description = _buildEventDescription(timeline, board, isAssignment: true)
        ..start = (calendar.EventDateTime()
          ..dateTime = dueDate.subtract(const Duration(hours: 1))
          ..timeZone = 'UTC')
        ..end = (calendar.EventDateTime()
          ..dateTime = dueDate
          ..timeZone = 'UTC');

      final calendarApi = await _getGoogleCalendarApi();
      if (calendarApi == null) return false;

      await calendarApi.events.insert(event, 'primary');
      debugPrint('Created Google Calendar assignment event: ${timeline.assignment}');
      return true;
    } catch (e) {
      debugPrint('Error creating Google assignment event: $e');
      return false;
    }
  }

  Future<bool> _createGoogleTimelineEvent(CourseTimeline timeline, Board board) async {
    try {
      final startDate = _parseWeekToDate(timeline.week);
      final event = calendar.Event()
        ..summary = timeline.title
        ..description = _buildEventDescription(timeline, board, isAssignment: false)
        ..start = (calendar.EventDateTime()
          ..dateTime = startDate
          ..timeZone = 'UTC')
        ..end = (calendar.EventDateTime()
          ..dateTime = startDate.add(const Duration(hours: 2))
          ..timeZone = 'UTC');

      final calendarApi = await _getGoogleCalendarApi();
      if (calendarApi == null) return false;

      await calendarApi.events.insert(event, 'primary');
      debugPrint('Created Google Calendar timeline event: ${timeline.title}');
      return true;
    } catch (e) {
      debugPrint('Error creating Google timeline event: $e');
      return false;
    }
  }

  Future<calendar.CalendarApi?> _getGoogleCalendarApi() async {
    try {
      final httpClient = _GoogleHttpClient('access_token');
      return calendar.CalendarApi(httpClient);
    } catch (e) {
      debugPrint('Error getting Google Calendar API: $e');
      return null;
    }
  }

  String _buildEventDescription(CourseTimeline timeline, Board board, {required bool isAssignment}) {
    final buffer = StringBuffer();
    buffer.writeln('Course: ${board.name}');
    
    if (board.subject != null) {
      buffer.writeln('Subject: ${board.subject}');
    }
    
    if (board.level != null) {
      buffer.writeln('Level: ${board.level}');
    }
    
    if (board.term != null) {
      buffer.writeln('Term: ${board.term}');
    }
    
    buffer.writeln('Week: ${timeline.week}');
    
    if (timeline.description != null && timeline.description!.isNotEmpty) {
      buffer.writeln('\nDescription: ${timeline.description}');
    }
    
    if (isAssignment) {
      buffer.writeln('\nDue date: ${timeline.due}');
      buffer.writeln('\nThis event was created automatically by NaviNotes');
    } else {
      buffer.writeln('\nThis event was created automatically by NaviNotes');
    }
    
    return buffer.toString();
  }

  DateTime _parseWeekToDate(String week) {
    try {
      final now = DateTime.now();
      final weekNumber = int.tryParse(week.replaceAll(RegExp(r'[^0-9]'), '')) ?? 1;
      
      final startOfYear = DateTime(now.year, 1, 1);
      final firstMonday = startOfYear.add(Duration(days: (8 - startOfYear.weekday) % 7));
      
      return firstMonday.add(Duration(days: (weekNumber - 1) * 7));
    } catch (e) {
      debugPrint('Error parsing week date: $e');
      return DateTime.now().add(const Duration(days: 7));
    }
  }

  Future<bool> syncAllBoardsToCalendar(List<Board> boards) async {
    try {
      if (!_calendarService.isDeviceConnected && !_calendarService.isGoogleConnected) {
        debugPrint('No calendar connection available');
        return false;
      }

      int syncedBoards = 0;
      for (final board in boards) {
        final success = await syncBoardToCalendar(board);
        if (success) syncedBoards++;
      }

      debugPrint('Calendar sync completed: $syncedBoards/${boards.length} boards synced');
      return syncedBoards > 0;
    } catch (e) {
      debugPrint('Error syncing all boards to calendar: $e');
      return false;
    }
  }

  Future<bool> isCalendarConnected() async {
    return _calendarService.isDeviceConnected || _calendarService.isGoogleConnected;
  }

  Future<void> disconnectCalendar() async {
    await _calendarService.clearCalendarData();
  }

  Future<List<String>> getConnectedCalendars() async {
    final List<String> connectedCalendars = [];
    
    if (_calendarService.isGoogleConnected) {
      connectedCalendars.add('Google Calendar');
    }
    
    if (_calendarService.isDeviceConnected) {
      final calendars = await _calendarService.getCalendars();
      connectedCalendars.addAll(calendars.map((c) => c.name ?? 'Unknown Calendar'));
    }
    
    return connectedCalendars;
  }
}

class _GoogleHttpClient extends http.BaseClient {
  final String _accessToken;
  final _client = http.Client();

  _GoogleHttpClient(this._accessToken);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    request.headers['Authorization'] = 'Bearer $_accessToken';
    return _client.send(request);
  }

  @override
  void close() {
    _client.close();
    super.close();
  }
}
