# Syllabus Edit and Calendar Sync Implementation

## Overview
Implemented the ability to edit generated syllabus/course timeline data and sync it to connected calendars with intelligent date normalization.

## New Files Created

### 1. `lib/utils/date_normalizer.dart`
Smart date normalization utility that handles various date formats:
- **Supported formats**: "April 30", "Apr 30", "2024-04-30", "04/30/2024", "30 April"
- **Smart year detection**: If no year provided, uses current year or next year based on context
- **Sequential normalization**: Ensures dates follow chronological order (e.g., Nov → Jan means next year)
- **Null/empty handling**: Safely handles missing or invalid dates

### 2. `lib/widgets/board/syllabus_section.dart`
Reusable widget for displaying and managing syllabus data:
- **Edit capability**: Tap any timeline item to edit all fields
- **Sync button**: One-click sync to connected calendar
- **Date normalization**: Automatically normalizes dates before syncing
- **Error handling**: Graceful error messages for sync failures

## Modified Files

### 1. `lib/models/course_timeline.dart`
- Added `copyWith()` method for easy editing

### 2. `lib/services/calendar_sync_service.dart`
- Added safe date parsing with try-catch to prevent crashes
- Handles invalid date formats gracefully

## How to Use

### In Any Board Screen

```dart
import 'package:navinotes/widgets/board/syllabus_section.dart';

// In your build method where you want to show the syllabus:
SyllabusSection(
  board: vm.board,
  onUpdate: (updatedTimelines) async {
    // Update the board with new timelines
    final updatedBoard = vm.board.copyWith(
      courseTimeLines: updatedTimelines,
    );
    await DatabaseHelper.instance.updateBoard(updatedBoard);
    
    // Refresh the UI
    vm.initialize(); // or setState(() {})
  },
  primaryColor: AppTheme.vividRose, // Your theme color
  backgroundColor: Colors.white, // Card background
)
```

## Features

### 1. Edit Timeline Items
- Tap any timeline card or the edit icon
- Edit dialog appears with all fields:
  - Week (e.g., "Week 1")
  - Title (e.g., "Introduction to Biology")
  - Description (optional)
  - Assignment (optional)
  - Due Date (optional)
- Supports multiple date formats
- Shows format hints to user

### 2. Sync to Calendar
- Click "Sync to Calendar" button
- Automatically normalizes all dates
- Creates calendar events for:
  - Assignments (with due dates)
  - Timeline topics (weekly events)
- Shows loading indicator
- Success/error messages

### 3. Date Normalization Examples

**Input** → **Normalized Output**
- "April 30" → "2024-04-30" (or 2025 if past)
- "Nov 15" → "2024-11-15"
- "Jan 10" (after Nov) → "2025-01-10" (next year)
- "" (empty) → null (skipped)
- null → null (skipped)

## Integration Steps for Each Board Screen

### Step 1: Import the Widget
```dart
import 'package:navinotes/widgets/board/syllabus_section.dart';
```

### Step 2: Replace Existing Timeline Display
Find where `_courseTimeline()` or similar is called and replace with:

```dart
SyllabusSection(
  board: vm.board,
  onUpdate: (updatedTimelines) async {
    final updatedBoard = vm.board.copyWith(
      courseTimeLines: updatedTimelines,
    );
    await DatabaseHelper.instance.updateBoard(updatedBoard);
    vm.initialize();
  },
  primaryColor: YOUR_THEME_COLOR,
  backgroundColor: YOUR_BACKGROUND_COLOR,
)
```

### Step 3: Customize Colors
Each board theme has different colors:
- **Dark Academia**: `Color(0xFF2B1810)` / `Color(0xFFF7F3E9)`
- **Light Academia**: `AppTheme.vividRose` / `Colors.white`
- **Minimalist**: `AppTheme.graphite` / `Colors.white`
- **Nature**: `AppTheme.forestGreen` / `AppTheme.mintWhisper`
- **Plain**: `AppTheme.vividRose` / `Colors.white`

## Error Handling

### Date Parsing Errors
- Invalid dates are skipped (not synced)
- User sees which items failed
- App doesn't crash

### Calendar Connection Errors
- Checks if calendar is connected
- Shows helpful error message
- Guides user to connect calendar

### Sync Failures
- Graceful error messages
- Logs errors for debugging
- Doesn't lose user data

## User Experience Flow

1. **View Syllabus**: User sees generated timeline
2. **Edit Item**: Tap to edit any field
3. **Save Changes**: Changes saved to database
4. **Sync**: Click "Sync to Calendar"
5. **Normalization**: Dates automatically fixed
6. **Calendar Events**: Events created in connected calendar
7. **Confirmation**: Success message shown

## Technical Details

### Date Normalization Algorithm
1. Try parsing as ISO date (YYYY-MM-DD)
2. Try parsing as full datetime
3. Try parsing "Month Day" format
4. Try parsing "Month Day, Year" format
5. Try parsing "Day Month" format
6. For sequences, ensure chronological order
7. If date is before previous, assume next year

### Calendar Sync Process
1. Normalize all dates in sequence
2. Update board in database
3. For each timeline item:
   - If has assignment + due date → create assignment event
   - If has title → create topic event
4. Show success/failure count

## Benefits

✅ **User Control**: Edit any generated data
✅ **Smart Dates**: Handles various formats automatically
✅ **No Crashes**: Safe parsing prevents errors
✅ **One-Click Sync**: Easy calendar integration
✅ **Visual Feedback**: Clear success/error messages
✅ **Reusable**: Same widget for all board types
✅ **Consistent UI**: Matches app design patterns

## Future Enhancements

- Bulk edit multiple items
- Delete timeline items
- Reorder timeline items
- Export to CSV
- Import from file
- Recurring events
- Reminders configuration

## Testing Checklist

- [ ] Edit timeline item
- [ ] Save with valid dates
- [ ] Save with various date formats
- [ ] Save with empty/null dates
- [ ] Sync to device calendar
- [ ] Sync to Google Calendar
- [ ] Handle sync errors gracefully
- [ ] Verify events in calendar app
- [ ] Test on iOS and Android

## Summary

The implementation provides a complete solution for editing and syncing syllabus data to calendars with intelligent date handling that prevents crashes and provides a smooth user experience.
