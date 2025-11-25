# iOS Calendar Integration Setup Guide

## Overview
This guide covers the additional steps required for iOS calendar integration with Google Calendar and Apple Calendar.

## 1. iOS Configuration Files

### Info.plist (Already Added ✅)
The calendar permission is already configured in `ios/Runner/Info.plist`:
```xml
<key>NSCalendarsUsageDescription</key>
<string>We need access to your calendar to sync study schedules and assignments</string>
```

## 2. Google Sign-In for iOS

### Step 1: Add URL Scheme
You need to add a custom URL scheme to handle Google Sign-In callbacks.

**File**: `ios/Runner/Info.plist`

Add this configuration:
```xml
<key>CFBundleURLTypes</key>
<array>
  <dict>
    <key>CFBundleTypeRole</key>
    <string>Editor</string>
    <key>CFBundleURLSchemes</key>
    <array>
      <!-- Replace with your REVERSED_CLIENT_ID from GoogleService-Info.plist -->
      <string>com.googleusercontent.apps.YOUR-CLIENT-ID</string>
    </array>
  </dict>
</array>
```

### Step 2: GoogleService-Info.plist
1. Download `GoogleService-Info.plist` from Firebase Console
2. Place it in `ios/Runner/` directory
3. Add it to Xcode project:
   - Open `ios/Runner.xcworkspace` in Xcode
   - Right-click on Runner folder
   - Select "Add Files to Runner"
   - Select `GoogleService-Info.plist`
   - Ensure "Copy items if needed" is checked

### Step 3: Get Client IDs
From your `GoogleService-Info.plist`, you'll need:
- `CLIENT_ID` - for iOS OAuth
- `REVERSED_CLIENT_ID` - for URL scheme

Add to your `.env` file:
```
GOOGLE_CLIENT_ID_IOS=YOUR_IOS_CLIENT_ID.apps.googleusercontent.com
```

## 3. Device Calendar (Apple Calendar)

### Permissions
Already configured! The `device_calendar` plugin will automatically:
- Request calendar access when needed
- Show the permission dialog with your usage description
- Handle permission denials gracefully

### Testing on Simulator
Note: Calendar permissions work differently on simulator:
- iOS Simulator has limited calendar functionality
- Test on a real device for full calendar features
- Simulator may not show all calendars

## 4. Xcode Project Settings

### Minimum Deployment Target
Ensure your iOS deployment target is set correctly:

**File**: `ios/Podfile`
```ruby
platform :ios, '12.0'  # Minimum iOS 12
```

### Capabilities
Open `ios/Runner.xcworkspace` in Xcode and verify:
1. **Signing & Capabilities** tab
2. No additional capabilities needed for calendar
3. Ensure proper signing is configured

## 5. Google Cloud Console Setup

### Create OAuth 2.0 Credentials

1. **Go to Google Cloud Console**
   - https://console.cloud.google.com/

2. **Create/Select Project**
   - Create a new project or select existing

3. **Enable APIs**
   - Enable "Google Calendar API"
   - Enable "Google Sign-In API"

4. **Create OAuth Credentials**
   
   **For iOS:**
   - Credentials → Create Credentials → OAuth 2.0 Client ID
   - Application type: iOS
   - Bundle ID: Your app's bundle identifier (e.g., `com.yourcompany.navinotes`)
   - Copy the Client ID

   **For Android:**
   - Application type: Android
   - Package name: Your app's package name
   - SHA-1 certificate fingerprint (get from your keystore)
   - Copy the Client ID

   **For Web (if needed):**
   - Application type: Web application
   - Authorized redirect URIs: `http://localhost:8080`
   - Copy the Client ID

5. **Download Configuration Files**
   - For iOS: Download `GoogleService-Info.plist`
   - For Android: Download `google-services.json`

## 6. Update Environment Variables

Add to your `.env` file (copy from `.env.example`):
```env
# Google Calendar OAuth Configuration
GOOGLE_CLIENT_ID_WEB=YOUR_WEB_CLIENT_ID.apps.googleusercontent.com
GOOGLE_CLIENT_ID_IOS=YOUR_IOS_CLIENT_ID.apps.googleusercontent.com
GOOGLE_CLIENT_ID_ANDROID=YOUR_ANDROID_CLIENT_ID.apps.googleusercontent.com
```

## 7. Testing Checklist

### Device Calendar (Apple Calendar)
- [ ] Run app on real iOS device
- [ ] Tap "Connect Calendar" → "Connect Device Calendar"
- [ ] Grant calendar permission when prompted
- [ ] Select a calendar from the list
- [ ] Sync a board with assignments
- [ ] Open Apple Calendar app and verify events appear

### Google Calendar
- [ ] Configure Google OAuth credentials
- [ ] Add GoogleService-Info.plist to iOS project
- [ ] Update URL scheme in Info.plist
- [ ] Run app on device
- [ ] Tap "Connect Calendar" → "Connect Google Calendar"
- [ ] Sign in with Google account
- [ ] Grant calendar permission
- [ ] Sync a board
- [ ] Check Google Calendar web/app for events

## 8. Common iOS Issues

### Issue: "Calendar permission denied"
**Solution:**
- Go to iOS Settings → Privacy → Calendars
- Enable access for NaviNotes

### Issue: "Google Sign-In not working"
**Solution:**
- Verify GoogleService-Info.plist is in project
- Check URL scheme matches REVERSED_CLIENT_ID
- Ensure OAuth credentials are configured for iOS
- Verify bundle ID matches in Google Console

### Issue: "No calendars showing"
**Solution:**
- Check calendar permission is granted
- Ensure device has calendars configured
- Try on real device (not simulator)
- Check device has iCloud or local calendars set up

### Issue: "Events not appearing in calendar"
**Solution:**
- Verify calendar is selected in app
- Check event dates are valid
- Ensure calendar is not hidden in Calendar app
- Refresh Calendar app

## 9. Build Configuration

### Debug Build
```bash
flutter run --debug
```

### Release Build
```bash
flutter build ios --release
```

### Archive for App Store
1. Open `ios/Runner.xcworkspace` in Xcode
2. Select "Any iOS Device" as target
3. Product → Archive
4. Follow App Store submission process

## 10. App Store Submission Notes

### Privacy Manifest
When submitting to App Store, you'll need to declare:
- **Calendar Access**: Explain why you need calendar access
- **Google Sign-In**: If using Google Calendar
- **Network Usage**: For syncing with Google Calendar API

### App Privacy Questions
Answer these in App Store Connect:
- **Does your app use calendar data?** Yes
- **Purpose**: To sync study schedules and assignments
- **Is data linked to user identity?** Yes (if syncing to Google)
- **Is data used for tracking?** No

## Summary

### Required Steps:
1. ✅ Add calendar permission to Info.plist (Already done)
2. ⚠️ Add GoogleService-Info.plist (if using Google Calendar)
3. ⚠️ Configure URL scheme in Info.plist (if using Google Calendar)
4. ⚠️ Set up Google OAuth credentials
5. ⚠️ Update .env with client IDs
6. ✅ Test on real iOS device

### Optional (Device Calendar Only):
If you're only using Apple's device calendar (not Google Calendar), you only need:
- Calendar permission in Info.plist ✅ (Already done)
- Test on real device

The device calendar integration works out of the box with no additional configuration!
