import 'package:flutter/foundation.dart';
import 'package:device_calendar/device_calendar.dart';
import 'package:googleapis/calendar/v3.dart' as calendar;
import 'package:http/http.dart' as http;
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:navinotes/packages.dart';
import 'package:timezone/timezone.dart' as tz;

class CalendarService {
  static final CalendarService _instance = CalendarService._internal();
  factory CalendarService() => _instance;
  CalendarService._internal();

  final DeviceCalendarPlugin _deviceCalendarPlugin = DeviceCalendarPlugin();
  final FlutterAppAuth _appAuth = FlutterAppAuth();
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'https://www.googleapis.com/auth/calendar',
      'email',
    ],
  );

  bool _isGoogleConnected = false;
  bool _isDeviceConnected = false;
  String? _googleAccessToken;
  String? _selectedCalendarId;

  bool get isGoogleConnected => _isGoogleConnected;
  bool get isDeviceConnected => _isDeviceConnected;
  String? get selectedCalendarId => _selectedCalendarId;

  Future<bool> requestPermissions() async {
    try {
      final permissionsGranted = await _deviceCalendarPlugin.hasPermissions();
      if (permissionsGranted.data == null || !permissionsGranted.data!) {
        final result = await _deviceCalendarPlugin.requestPermissions();
        if (result.data == null || !result.data!) {
          debugPrint('Calendar permissions not granted');
          return false;
        }
      }
      return true;
    } catch (e) {
      debugPrint('Error requesting calendar permissions: $e');
      return false;
    }
  }

  Future<List<Calendar>> getCalendars() async {
    try {
      final hasPermissions = await requestPermissions();
      if (!hasPermissions) return [];

      final result = await _deviceCalendarPlugin.retrieveCalendars();
      return result.data ?? [];
    } catch (e) {
      debugPrint('Error retrieving calendars: $e');
      return [];
    }
  }

  Future<bool> connectToDeviceCalendar() async {
    try {
      final hasPermissions = await requestPermissions();
      if (!hasPermissions) return false;

      _isDeviceConnected = true;
      return true;
    } catch (e) {
      debugPrint('Error connecting to device calendar: $e');
      return false;
    }
  }

  Future<bool> connectToGoogleCalendar() async {
    try {
      if (kIsWeb) {
        return await _connectToGoogleCalendarWeb();
      } else {
        return await _connectToGoogleCalendarMobile();
      }
    } catch (e) {
      debugPrint('Error connecting to Google Calendar: $e');
      return false;
    }
  }

  Future<bool> _connectToGoogleCalendarMobile() async {
    try {
      final GoogleSignInAccount? account = await _googleSignIn.signIn();
      if (account == null) return false;

      final GoogleSignInAuthentication auth = await account.authentication;
      _googleAccessToken = auth.accessToken;

      _isGoogleConnected = true;
      return true;
    } catch (e) {
      debugPrint('Error signing in with Google: $e');
      return false;
    }
  }

  Future<bool> _connectToGoogleCalendarWeb() async {
    try {
      final clientId = dotenv.env['GOOGLE_CLIENT_ID_WEB'] ?? 'YOUR_WEB_CLIENT_ID.apps.googleusercontent.com';
      const redirectUrl = 'http://localhost:8080';

      final AuthorizationTokenResponse result = await _appAuth.authorizeAndExchangeCode(
        AuthorizationTokenRequest(
          clientId,
          redirectUrl,
          scopes: [
            'https://www.googleapis.com/auth/calendar',
            'email',
          ],
          promptValues: ['consent'],
        ),
      );

      _googleAccessToken = result.accessToken;
      _isGoogleConnected = true;
      return true;
    } catch (e) {
      debugPrint('Error authorizing with Google on web: $e');
      return false;
    }
  }

  Future<void> disconnectGoogleCalendar() async {
    try {
      await _googleSignIn.signOut();
      _isGoogleConnected = false;
      _googleAccessToken = null;
    } catch (e) {
      debugPrint('Error disconnecting Google Calendar: $e');
    }
  }

  Future<void> disconnectDeviceCalendar() async {
    _isDeviceConnected = false;
    _selectedCalendarId = null;
  }

  Future<bool> selectCalendar(String calendarId) async {
    try {
      _selectedCalendarId = calendarId;
      return true;
    } catch (e) {
      debugPrint('Error selecting calendar: $e');
      return false;
    }
  }

  Future<bool> syncBoardToCalendar(Board board) async {
    try {
      if (!_isDeviceConnected && !_isGoogleConnected) {
        debugPrint('No calendar connection available');
        return false;
      }

      if (_isDeviceConnected) {
        return await _syncBoardToDeviceCalendar(board);
      } else if (_isGoogleConnected) {
        return await _syncBoardToGoogleCalendar(board);
      }
      return false;
    } catch (e) {
      debugPrint('Error syncing board to calendar: $e');
      return false;
    }
  }

  Future<bool> _syncBoardToDeviceCalendar(Board board) async {
    try {
      final syllabusContent = await board.getSyllabusContent();
      if (syllabusContent == null) {
        debugPrint('No syllabus content found');
        return false;
      }

      final courseTimelines = board.courseTimeLines ?? [];
      for (final timeline in courseTimelines) {
        if (timeline.assignment != null && timeline.due != null) {
          await _createAssignmentEvent(timeline, board.name);
        }
      }

      return true;
    } catch (e) {
      debugPrint('Error syncing board to device calendar: $e');
      return false;
    }
  }

  Future<bool> _syncBoardToGoogleCalendar(Board board) async {
    try {
      if (_googleAccessToken == null) return false;

      final client = GoogleHttpClient(_googleAccessToken!);
      final calendarApi = calendar.CalendarApi(client);

      final syllabusContent = await board.getSyllabusContent();
      if (syllabusContent == null) {
        debugPrint('No syllabus content found');
        return false;
      }

      final courseTimelines = board.courseTimeLines ?? [];
      for (final timeline in courseTimelines) {
        if (timeline.assignment != null && timeline.due != null) {
          await _createGoogleCalendarEvent(calendarApi, timeline, board.name);
        }
      }

      return true;
    } catch (e) {
      debugPrint('Error syncing board to Google Calendar: $e');
      return false;
    }
  }

  Future<void> _createAssignmentEvent(CourseTimeline timeline, String boardName) async {
    try {
      if (_selectedCalendarId == null) return;

      final event = Event(
        _selectedCalendarId!,
        title: timeline.assignment!,
        description: 'Assignment from $boardName\n${timeline.title}',
        start: tz.TZDateTime.from(DateTime.parse(timeline.due!).subtract(const Duration(hours: 1)), tz.local),
        end: tz.TZDateTime.from(DateTime.parse(timeline.due!), tz.local),
      );

      final result = await _deviceCalendarPlugin.createOrUpdateEvent(event);
      if (result?.isSuccess ?? false) {
        debugPrint('Created assignment event: ${timeline.assignment}');
      }
    } catch (e) {
      debugPrint('Error creating assignment event: $e');
    }
  }

  Future<void> _createGoogleCalendarEvent(
    calendar.CalendarApi calendarApi,
    CourseTimeline timeline,
    String boardName,
  ) async {
    try {
      final event = calendar.Event()
        ..summary = timeline.assignment!
        ..description = 'Assignment from $boardName\n${timeline.title}'
        ..start = (calendar.EventDateTime()
          ..dateTime = DateTime.parse(timeline.due!).subtract(const Duration(hours: 1))
          ..timeZone = 'UTC')
        ..end = (calendar.EventDateTime()
          ..dateTime = DateTime.parse(timeline.due!)
          ..timeZone = 'UTC');

      await calendarApi.events.insert(event, 'primary');
      debugPrint('Created Google Calendar event: ${timeline.assignment}');
    } catch (e) {
      debugPrint('Error creating Google Calendar event: $e');
    }
  }

  Future<bool> syncAllBoards(List<Board> boards) async {
    try {
      bool allSynced = true;
      for (final board in boards) {
        final synced = await syncBoardToCalendar(board);
        if (!synced) allSynced = false;
      }
      return allSynced;
    } catch (e) {
      debugPrint('Error syncing all boards: $e');
      return false;
    }
  }

  Future<void> clearCalendarData() async {
    _isGoogleConnected = false;
    _isDeviceConnected = false;
    _googleAccessToken = null;
    _selectedCalendarId = null;
  }
}

class GoogleHttpClient extends http.BaseClient {
  final String _accessToken;
  final _client = http.Client();

  GoogleHttpClient(this._accessToken);

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
