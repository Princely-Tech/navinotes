# Calendar Integration Guide

## Overview
The NaviNotes app now includes full Google Calendar and Apple/Device Calendar integration for syncing syllabus and assignments.

## Features Implemented

### 1. Calendar Connection
- **Google Calendar**: OAuth authentication with Google Sign-In
- **Device Calendar**: Native iOS/Android calendar access
- **Calendar Selection**: Choose specific calendars to sync to

### 2. Sync Functionality
- Automatically sync syllabus content to calendar
- Create calendar events for assignments with due dates
- Create timeline events for course weeks
- Detailed event descriptions with course info

### 3. User Interface
- Calendar connection screen with provider selection
- Sync buttons on individual boards
- Status indicators for connected calendars
- Error handling and user feedback

## Files Created/Modified

### Services
- `lib/services/calendar_service.dart` - Core calendar service handling connections
- `lib/services/calendar_sync_service.dart` - Sync logic for boards and timelines

### UI Components
- `lib/screens/main/dashboard/calendar_connect_screen.dart` - Connection interface
- `lib/widgets/board/calendar_sync_button.dart` - Sync button widget
- `lib/screens/main/dashboard/empty_dashboard.dart` - Updated with connect button

### Models
- `lib/models/calendar_sync.dart` - Data models for sync tracking

## Dependencies Added

```yaml
googleapis: ^13.2.0           # Google Calendar API
googleapis_auth: ^2.0.0       # Google OAuth authentication
device_calendar: ^4.3.0       # Device calendar access
flutter_appauth: ^8.0.0+1     # OAuth authentication
timezone: ^0.9.4              # Timezone handling
http: ^1.4.0                  # HTTP client
```

## Permissions Required

### Android (AndroidManifest.xml)
```xml
<uses-permission android:name="android.permission.READ_CALENDAR" />
<uses-permission android:name="android.permission.WRITE_CALENDAR" />
```

### iOS (Info.plist)
```xml
<key>NSCalendarsUsageDescription</key>
<string>We need access to your calendar to sync study schedules and assignments</string>
```

## Usage Instructions

### For Users

1. **Connect Calendar**
   - Open the app dashboard
   - Tap "Connect Calendar" in Quick Actions
   - Choose Google Calendar or Device Calendar
   - Grant necessary permissions

2. **Select Calendar**
   - If using device calendar, select which calendar to sync to
   - The selected calendar will be used for all syncs

3. **Sync Content**
   - Open any board with syllabus and assignments
   - Tap the sync button to sync to calendar
   - Events will be created automatically

### For Developers

#### Google Calendar Setup
1. Create a project in Google Cloud Console
2. Enable Google Calendar API
3. Create OAuth 2.0 credentials
4. Update client ID in `calendar_service.dart`:
   ```dart
   const clientId = 'YOUR_CLIENT_ID.apps.googleusercontent.com';
   ```

#### Event Creation
Events are created with:
- **Title**: Assignment name or timeline title
- **Description**: Course info, week, and assignment details
- **Start/End**: Based on due dates or week calculations
- **Timezone**: Local timezone using `tz.local`

#### Sync Logic
```dart
// Sync a board
final success = await CalendarSyncService().syncBoardToCalendar(board);

// Check connection status
final isConnected = await CalendarSyncService().isCalendarConnected();

// Get connected calendars
final calendars = await CalendarSyncService().getConnectedCalendars();
```

## Architecture

### Calendar Service
Handles low-level calendar operations:
- Permission requests
- Calendar retrieval
- OAuth authentication
- Event creation

### Calendar Sync Service
Manages high-level sync logic:
- Board-to-calendar mapping
- Timeline parsing
- Event description generation
- Batch syncing

### Data Flow
```
Board → CourseTimeline → CalendarSyncService → CalendarService → Device/Google Calendar
```

## Error Handling

The integration includes comprehensive error handling:
- Permission denied scenarios
- Network failures
- Invalid date formats
- Missing calendar selection
- OAuth failures

All errors are logged and displayed to users with actionable messages.

## Testing

### Manual Testing Checklist
- [ ] Connect to Google Calendar
- [ ] Connect to Device Calendar
- [ ] Select a calendar
- [ ] Sync a board with assignments
- [ ] Verify events appear in calendar
- [ ] Check event descriptions
- [ ] Test with multiple boards
- [ ] Test disconnect functionality

### Known Limitations
1. Google Calendar requires OAuth setup
2. Device calendar requires platform permissions
3. Week parsing assumes standard academic calendar
4. Timezone handling uses device local time

## Future Enhancements

Potential improvements:
- Two-way sync (calendar → app)
- Recurring events for weekly classes
- Calendar event updates when assignments change
- Multiple calendar support
- Custom event colors
- Reminder notifications
- Sync scheduling (auto-sync)

## Troubleshooting

### "No calendar connection available"
- Ensure you've connected a calendar in settings
- Check calendar permissions in device settings

### "Failed to sync to calendar"
- Verify the board has syllabus content
- Check that assignments have valid due dates
- Ensure calendar is still accessible

### Google Calendar not working
- Verify OAuth credentials are configured
- Check Google Calendar API is enabled
- Ensure proper scopes are requested

## Support

For issues or questions:
1. Check the error messages in the app
2. Review device calendar permissions
3. Verify Google OAuth setup (if using Google Calendar)
4. Check logs for detailed error information

---

**Last Updated**: November 25, 2024
**Version**: 1.0.0
