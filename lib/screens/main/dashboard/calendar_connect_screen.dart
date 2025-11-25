import 'package:flutter/foundation.dart';
import 'package:device_calendar/device_calendar.dart';
import 'package:navinotes/services/calendar_service.dart';
import 'package:navinotes/packages.dart';

class CalendarConnectScreen extends StatefulWidget {
  const CalendarConnectScreen({super.key});

  @override
  State<CalendarConnectScreen> createState() => _CalendarConnectScreenState();
}

class _CalendarConnectScreenState extends State<CalendarConnectScreen> {
  final CalendarService _calendarService = CalendarService();
  bool _isLoading = false;
  bool _isGoogleConnected = false;
  bool _isDeviceConnected = false;
  List<Calendar> _calendars = [];
  Calendar? _selectedCalendar;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadCalendarStatus();
  }

  Future<void> _loadCalendarStatus() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final isGoogleConnected = _calendarService.isGoogleConnected;
      final isDeviceConnected = _calendarService.isDeviceConnected;
      
      setState(() {
        _isGoogleConnected = isGoogleConnected;
        _isDeviceConnected = isDeviceConnected;
      });

      if (isDeviceConnected) {
        await _loadCalendars();
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load calendar status: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadCalendars() async {
    try {
      final calendars = await _calendarService.getCalendars();
      setState(() {
        _calendars = calendars;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load calendars: $e';
      });
    }
  }

  Future<void> _connectToGoogleCalendar() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final success = await _calendarService.connectToGoogleCalendar();
      if (success) {
        setState(() {
          _isGoogleConnected = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Connected to Google Calendar')),
        );
      } else {
        setState(() {
          _errorMessage = 'Failed to connect to Google Calendar';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error connecting to Google Calendar: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _connectToDeviceCalendar() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final success = await _calendarService.connectToDeviceCalendar();
      if (success) {
        setState(() {
          _isDeviceConnected = true;
        });
        await _loadCalendars();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Connected to device calendar')),
        );
      } else {
        setState(() {
          _errorMessage = 'Failed to connect to device calendar';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error connecting to device calendar: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _selectCalendar(Calendar calendar) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final success = await _calendarService.selectCalendar(calendar.id!);
      if (success) {
        setState(() {
          _selectedCalendar = calendar;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Selected ${calendar.name}')),
        );
      } else {
        setState(() {
          _errorMessage = 'Failed to select calendar';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error selecting calendar: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _disconnectGoogleCalendar() async {
    await _calendarService.disconnectGoogleCalendar();
    setState(() {
      _isGoogleConnected = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Disconnected from Google Calendar')),
    );
  }

  Future<void> _disconnectDeviceCalendar() async {
    await _calendarService.disconnectDeviceCalendar();
    setState(() {
      _isDeviceConnected = false;
      _calendars = [];
      _selectedCalendar = null;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Disconnected from device calendar')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Connect Calendar'),
        backgroundColor: AppTheme.tropicalTeal,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_errorMessage != null)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        border: Border.all(color: Colors.red),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _errorMessage!,
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  
                  // Only show Google Calendar for Android
                  if (defaultTargetPlatform == TargetPlatform.android)
                    _buildGoogleCalendarSection(),
                  if (defaultTargetPlatform == TargetPlatform.android)
                    const SizedBox(height: 24),
                  _buildDeviceCalendarSection(),
                  const SizedBox(height: 24),
                  if (_isGoogleConnected || _isDeviceConnected)
                    _buildSyncSection(),
                ],
              ),
            ),
    );
  }

  Widget _buildGoogleCalendarSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Google Calendar',
          style: AppTheme.text.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppTheme.graphite,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Sync your study schedules with Google Calendar',
          style: AppTheme.text.copyWith(
            fontSize: 14,
            color: AppTheme.steelMist,
          ),
        ),
        const SizedBox(height: 16),
        if (_isGoogleConnected) ...[
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.tropicalTeal.withOpacity(0.1),
              border: Border.all(color: AppTheme.tropicalTeal),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.check_circle, color: AppTheme.tropicalTeal),
                const SizedBox(width: 8),
                const Text('Connected to Google Calendar'),
                const Spacer(),
                TextButton(
                  onPressed: _disconnectGoogleCalendar,
                  child: const Text('Disconnect'),
                ),
              ],
            ),
          ),
        ] else ...[
          AppButton(
            onTap: _connectToGoogleCalendar,
            text: 'Connect Google Calendar',
            color: AppTheme.tropicalTeal,
            mainAxisSize: MainAxisSize.min,
          ),
        ],
      ],
    );
  }

  Widget _buildDeviceCalendarSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Device Calendar',
          style: AppTheme.text.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppTheme.graphite,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Sync with your device\'s built-in calendar app',
          style: AppTheme.text.copyWith(
            fontSize: 14,
            color: AppTheme.steelMist,
          ),
        ),
        const SizedBox(height: 16),
        if (_isDeviceConnected) ...[
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.tropicalTeal.withOpacity(0.1),
              border: Border.all(color: AppTheme.tropicalTeal),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.check_circle, color: AppTheme.tropicalTeal),
                    const SizedBox(width: 8),
                    const Text('Connected to device calendar'),
                    const Spacer(),
                    TextButton(
                      onPressed: _disconnectDeviceCalendar,
                      child: const Text('Disconnect'),
                    ),
                  ],
                ),
                if (_selectedCalendar != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    'Selected: ${_selectedCalendar!.name}',
                    style: TextStyle(color: AppTheme.tropicalTeal),
                  ),
                ],
              ],
            ),
          ),
          if (_calendars.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text(
              'Select a calendar:',
              style: AppTheme.text.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            ..._calendars.map((calendar) => RadioListTile<Calendar>(
              title: Text(calendar.name ?? 'Unknown Calendar'),
              subtitle: calendar.accountName != null ? Text(calendar.accountName!) : null,
              value: calendar,
              groupValue: _selectedCalendar,
              onChanged: (value) {
                if (value != null) {
                  _selectCalendar(value);
                }
              },
            )),
          ],
        ] else ...[
          AppButton(
            onTap: _connectToDeviceCalendar,
            text: 'Connect Device Calendar',
            color: AppTheme.tropicalTeal,
            mainAxisSize: MainAxisSize.min,
          ),
        ],
      ],
    );
  }

  Widget _buildSyncSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Calendar Sync',
          style: AppTheme.text.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppTheme.graphite,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Your syllabus and assignments will be synced to your connected calendar',
          style: AppTheme.text.copyWith(
            fontSize: 14,
            color: AppTheme.steelMist,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppTheme.lightAsh,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(Icons.info_outline, color: AppTheme.graphite),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Calendar sync is now enabled. Go to your boards to sync syllabus and assignments.',
                  style: AppTheme.text.copyWith(
                    fontSize: 12,
                    color: AppTheme.graphite,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
