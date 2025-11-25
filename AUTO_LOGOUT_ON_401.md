# Automatic Logout on 401 Unauthorized

## Overview
Implemented automatic session clearing and navigation to login screen when the backend returns a 401 Unauthorized error.

## Implementation Details

### File Modified
`lib/settings/rest_network_service/dio_network_service.dart`

### Changes Made

#### 1. Enhanced Error Interceptor
Added automatic logout handling in the `DataErrorInterceptor.onError` method:

```dart
} else if (err.isUnauthorisedError) {
  exception = UnauthorisedException(errorMessage: message);
  
  // Handle 401 Unauthorized - Clear session and navigate to login
  _handleUnauthorized();
}
```

#### 2. New `_handleUnauthorized()` Method
Created a dedicated method to handle 401 errors:

```dart
/// Handle 401 Unauthorized error by clearing session and navigating to login
void _handleUnauthorized() {
  debugPrint('401 Unauthorized - Logging out user');
  
  // Clear session data
  final sessionManager = NavigationHelper.navigatorKey.currentContext?.read<SessionManager>();
  if (sessionManager != null) {
    sessionManager.clearSession();
  }
  
  // Navigate to login screen and clear navigation stack
  Future.microtask(() {
    NavigationHelper.logOut();
  });
}
```

## How It Works

### Flow:
1. **API Request Fails** with 401 status code
2. **Dio Interceptor** catches the error
3. **Error Handler** detects it's a 401 Unauthorized error
4. **Session Cleared**:
   - Removes authentication token
   - Clears user data from SharedPreferences
   - Resets session state
5. **Navigation**:
   - Redirects to login screen (`Routes.auth`)
   - Clears entire navigation stack (no back button)
   - User must log in again

### Key Features:
- ✅ **Automatic Detection** - No manual checks needed
- ✅ **Clean Session** - All user data cleared
- ✅ **Secure** - Prevents unauthorized access
- ✅ **User-Friendly** - Smooth transition to login
- ✅ **No Back Navigation** - Can't go back to authenticated screens

## Error Scenarios Handled

### 401 Unauthorized Triggers:
- Expired authentication token
- Invalid token
- Token revoked by backend
- User logged out from another device
- Session timeout

### What Happens:
```
Backend Response (401)
        ↓
Dio Interceptor Catches Error
        ↓
Identifies 401 Status Code
        ↓
Clears SessionManager Data
        ↓
Navigates to Login Screen
        ↓
User Sees Login Page
```

## User Experience

### Before:
- ❌ User sees "Unauthenticated" error
- ❌ Stays on current screen
- ❌ Must manually navigate to login
- ❌ Confusing experience

### After:
- ✅ Error message briefly shown
- ✅ Automatically redirected to login
- ✅ Session data cleared
- ✅ Clear, expected behavior

## Technical Details

### Session Clearing:
The `SessionManager.clearSession()` method removes:
- `user_token` from SharedPreferences
- `user_data` from SharedPreferences
- In-memory user object
- In-memory token
- Email and OTP data
- User boards cache

### Navigation:
Uses `NavigationHelper.logOut()` which calls:
```dart
pushAndRemoveUntil(Routes.auth)
```
This removes all previous routes from the stack.

### Timing:
`Future.microtask()` ensures navigation happens after the current frame, preventing navigation conflicts during error handling.

## Testing

### To Test:
1. Log in to the app
2. Manually expire or invalidate the token on the backend
3. Make any API request (e.g., analyze syllabus, create board)
4. Observe automatic logout and redirect to login

### Expected Behavior:
- Error message appears briefly
- User is redirected to login screen
- Cannot navigate back to previous screens
- Must log in again to access app

## Security Benefits

1. **Prevents Stale Sessions** - Forces re-authentication
2. **Protects User Data** - Clears sensitive information
3. **Consistent State** - App state matches backend state
4. **Audit Trail** - Logs 401 events for debugging

## Error Messages

The user will see:
1. Brief error toast: "Unauthenticated" (from backend message)
2. Automatic redirect to login screen
3. Clean login form (no previous data)

## Debugging

### Console Output:
When a 401 occurs, you'll see:
```
flutter: 401 Unauthorized - Logging out user
```

This helps track when automatic logouts happen during development.

## Related Files

- `lib/settings/rest_network_service/dio_network_service.dart` - Error interceptor
- `lib/settings/navigation_helper.dart` - Navigation utilities
- `lib/providers/session.dart` - Session management
- `lib/settings/routes.dart` - Route definitions

## Future Enhancements

Potential improvements:
- Show a more user-friendly message before redirect
- Add a countdown timer ("Redirecting in 3... 2... 1...")
- Store the attempted route to redirect back after re-login
- Implement token refresh before 401 occurs
- Add analytics tracking for 401 events

## Summary

✅ **Automatic logout on 401 errors**  
✅ **Session data cleared securely**  
✅ **Smooth navigation to login**  
✅ **No manual intervention needed**  
✅ **Better user experience**  
✅ **Enhanced security**

The app now handles authentication failures gracefully and automatically!
