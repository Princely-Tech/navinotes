# Backend Requirements for Calendar Integration

## Overview
This document outlines what the backend team needs to know and potentially implement for the calendar integration feature.

## Current Implementation Status

### ✅ What's Already Working (No Backend Required)
The calendar integration is **fully client-side** and works without backend changes:

1. **Device Calendar Sync**
   - Direct device calendar access (iOS/Android)
   - No backend involvement
   - Works offline

2. **Google Calendar Sync**
   - OAuth handled client-side
   - Direct Google Calendar API calls from app
   - No backend proxy needed

3. **Data Storage**
   - Calendar sync preferences stored locally (SQLite)
   - No server-side storage required

## Backend Considerations

### Option 1: Keep It Client-Side (Current Implementation) ✅
**Pros:**
- No backend development needed
- Works immediately
- Reduced server load
- Better privacy (data stays on device)
- Offline capability

**Cons:**
- Can't sync calendar preferences across devices
- No centralized calendar event management
- Can't trigger syncs from backend

### Option 2: Add Backend Support (Optional Enhancement)

If you want to add backend features, here's what you could implement:

#### 2.1 Store Calendar Preferences
**Purpose**: Sync calendar settings across user's devices

**API Endpoint**: `POST /api/calendar/preferences`
```json
{
  "user_id": "string",
  "provider": "google|device",
  "calendar_id": "string",
  "auto_sync": boolean,
  "sync_interval_hours": number,
  "last_sync_at": "timestamp"
}
```

**Database Schema**:
```sql
CREATE TABLE calendar_preferences (
    id UUID PRIMARY KEY,
    user_id UUID REFERENCES users(id),
    provider VARCHAR(20) NOT NULL,
    calendar_id VARCHAR(255),
    auto_sync BOOLEAN DEFAULT true,
    sync_interval_hours INTEGER DEFAULT 24,
    last_sync_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);
```

#### 2.2 Track Sync History
**Purpose**: Monitor sync success/failures, analytics

**API Endpoint**: `POST /api/calendar/sync-history`
```json
{
  "user_id": "string",
  "board_id": "string",
  "provider": "google|device",
  "status": "success|failed",
  "events_synced": number,
  "error_message": "string",
  "synced_at": "timestamp"
}
```

**Database Schema**:
```sql
CREATE TABLE calendar_sync_history (
    id UUID PRIMARY KEY,
    user_id UUID REFERENCES users(id),
    board_id UUID REFERENCES boards(id),
    provider VARCHAR(20) NOT NULL,
    status VARCHAR(20) NOT NULL,
    events_synced INTEGER DEFAULT 0,
    error_message TEXT,
    synced_at TIMESTAMP DEFAULT NOW()
);
```

#### 2.3 Server-Side Calendar Sync (Advanced)
**Purpose**: Sync calendars from backend (scheduled jobs)

**Why you might want this:**
- Automatic background syncing
- Sync when app is closed
- Centralized sync management
- Better error handling and retry logic

**Implementation**:
```python
# Example: Django/Python backend
from google.oauth2.credentials import Credentials
from googleapiclient.discovery import build

def sync_user_calendar(user_id):
    # Get user's calendar preferences
    prefs = CalendarPreferences.objects.get(user_id=user_id)
    
    # Get user's boards with assignments
    boards = Board.objects.filter(user_id=user_id)
    
    # Create calendar service
    credentials = Credentials(token=prefs.access_token)
    service = build('calendar', 'v3', credentials=credentials)
    
    # Sync each board
    for board in boards:
        for assignment in board.assignments:
            event = {
                'summary': assignment.title,
                'description': f'Course: {board.name}',
                'start': {'dateTime': assignment.due_date},
                'end': {'dateTime': assignment.due_date}
            }
            service.events().insert(calendarId='primary', body=event).execute()
```

**Required Backend Changes:**
1. Store Google OAuth tokens securely
2. Implement token refresh logic
3. Create scheduled job for syncing
4. Handle API rate limits
5. Implement error handling and retries

## What Backend Team Should Do Now

### Immediate Actions (Optional)
1. **Review the implementation** - Understand how client-side sync works
2. **No changes required** - Current implementation works without backend

### Future Enhancements (If Desired)
1. **Add calendar preferences endpoint** - Store user preferences
2. **Add sync history tracking** - Monitor sync operations
3. **Consider server-side sync** - For advanced features

## API Integration Points (If Backend Sync Added)

### 1. Get Calendar Preferences
```
GET /api/calendar/preferences
Response: {
  "provider": "google",
  "calendar_id": "primary",
  "auto_sync": true,
  "last_sync_at": "2024-11-25T10:30:00Z"
}
```

### 2. Update Calendar Preferences
```
PUT /api/calendar/preferences
Body: {
  "provider": "google",
  "calendar_id": "primary",
  "auto_sync": true
}
```

### 3. Trigger Manual Sync
```
POST /api/calendar/sync
Body: {
  "board_id": "uuid"
}
Response: {
  "status": "success",
  "events_synced": 5
}
```

### 4. Get Sync History
```
GET /api/calendar/sync-history?board_id=uuid
Response: {
  "syncs": [
    {
      "synced_at": "2024-11-25T10:30:00Z",
      "status": "success",
      "events_synced": 5
    }
  ]
}
```

## Security Considerations

### If Implementing Backend Sync:

1. **OAuth Token Storage**
   - Encrypt tokens at rest
   - Use secure key management (AWS KMS, etc.)
   - Implement token rotation

2. **API Rate Limiting**
   - Google Calendar API has quotas
   - Implement exponential backoff
   - Cache calendar data when possible

3. **User Privacy**
   - Don't store calendar event content
   - Only store sync metadata
   - Comply with GDPR/privacy laws

4. **Access Control**
   - Verify user owns the board being synced
   - Validate calendar permissions
   - Implement proper authentication

## Testing Requirements

### If Backend Changes Are Made:

1. **Unit Tests**
   - Test calendar preference CRUD operations
   - Test sync history recording
   - Test OAuth token handling

2. **Integration Tests**
   - Test Google Calendar API integration
   - Test error handling
   - Test rate limiting

3. **Load Tests**
   - Test concurrent sync operations
   - Test API quota handling
   - Test database performance

## Monitoring & Logging

### Recommended Metrics (If Backend Sync):

1. **Sync Success Rate**
   - Track successful vs failed syncs
   - Alert on high failure rates

2. **API Usage**
   - Monitor Google Calendar API quota
   - Track API response times

3. **Error Tracking**
   - Log sync errors with context
   - Alert on critical failures

## Cost Considerations

### Google Calendar API Costs:
- **Free Tier**: 1,000,000 queries/day
- **Paid Tier**: $0.25 per 1,000 requests after free tier
- **Recommendation**: Client-side sync avoids these costs

### Backend Infrastructure:
- **Current**: No additional costs (client-side)
- **With Backend Sync**: 
  - Additional server resources for sync jobs
  - Database storage for preferences/history
  - Monitoring and logging costs

## Recommendation

### For Now: ✅ No Backend Changes Needed
The current client-side implementation is:
- Fully functional
- Cost-effective
- Privacy-friendly
- Easy to maintain

### Future: Consider Backend If...
- You want cross-device sync preferences
- You need analytics on calendar usage
- You want automatic background syncing
- You need centralized sync management

## Questions for Backend Team?

1. **Do you want to track calendar sync analytics?**
   - If yes: Implement sync history endpoint
   - If no: Keep current implementation

2. **Do you want users to sync preferences across devices?**
   - If yes: Implement preferences endpoint
   - If no: Keep current implementation

3. **Do you want server-side calendar syncing?**
   - If yes: Implement OAuth token storage and sync jobs
   - If no: Keep current implementation

## Summary

**Current Status**: ✅ Calendar integration works without backend changes

**Backend Action Required**: ❌ None (optional enhancements available)

**Recommendation**: Start with client-side implementation, add backend features based on user feedback and analytics needs.

---

**Contact**: If you have questions about the implementation or want to add backend features, please reach out to the mobile team.
