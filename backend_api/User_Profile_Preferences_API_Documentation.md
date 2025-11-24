# User Profile & Preferences API Documentation

## Overview

This document outlines the API endpoints for user profile management, including profile updates, image uploads, email preferences, and push notification preferences.

## Base URL

```text
https://your-domain.com/api/v1
```

## Authentication

All endpoints require authentication using Laravel Sanctum. Include the Authorization header:

```text
Authorization: Bearer {token}
```

---

## 1. User Profile Management

### 1.1 Get User Profile

Retrieve the current user's profile information.

**Endpoint:** `GET /profile`

**Response:**

```json
{
  "id": 1,
  "name": "John Doe",
  "email": "john@example.com",
  "country": "United States",
  "latitude": 40.7128,
  "longitude": -74.0060,
  "iam": "Student",
  "about": "I am a computer science student...",
  "school_name": "University of Example",
  "school_field": "Computer Science",
  "school_level": "Bachelor",
  "profile_picture": "profile_pictures/filename.jpg",
  "for_exam": true,
  "for_project": true,
  "for_research": false,
  "for_brainstorming": true,
  "for_course_note": true,
  "for_other": null,
  "email_marketing": true,
  "email_product_updates": true,
  "email_marketplace_notifications": true,
  "push_pomodoro_alerts": true,
  "push_flashcard_reminders": true,
  "push_marketplace_purchase_confirmations": true,
  "push_marketplace_sale_notifications": true,
  "push_feature_announcements": true,
  "email_verified_at": "2023-01-01T12:00:00.000000Z",
  "created_at": "2023-01-01T10:00:00.000000Z",
  "updated_at": "2023-01-01T11:00:00.000000Z"
}
```

### 1.2 Update User Profile

Update the user's profile information.

**Endpoint:** `POST /profile`

**Request Body:**

```json
{
  "name": "John Updated",
  "country": "Canada",
  "latitude": 43.6532,
  "longitude": -79.3832,
  "iam": "Developer",
  "about": "I am a software developer...",
  "school_name": "Tech University",
  "school_field": "Software Engineering",
  "school_level": "Master",
  "for_exam": false,
  "for_project": true,
  "for_research": true,
  "for_brainstorming": false,
  "for_course_note": true,
  "for_other": "Personal development"
}
```

**Response:**
```json
{
  "message": "Profile updated successfully",
  "user": {
    "id": 1,
    "name": "John Updated",
    // ... all user fields with updated values
  }
}
```

### 1.3 Upload Profile Picture

Upload a new profile picture for the user.

**Endpoint:** `POST /profile/picture`

**Request:** `multipart/form-data`

- `profile_picture` (file, required): Image file (jpeg, png, jpg, gif, max 5MB)

**Response:**

```json
{
  "message": "Profile picture updated successfully",
  "profile_picture_url": "https://your-domain.com/storage/profile_pictures/filename.jpg",
  "user": {
    "id": 1,
    "profile_picture": "profile_pictures/filename.jpg",
    // ... other user fields
  }
}
```

---

## 2. Email Preferences

### 2.1 Update Email Preferences

Update the user's email notification preferences.

**Endpoint:** `POST /profile/email-preferences`

**Request Body:**

```json
{
  "email_marketing": false,
  "email_product_updates": true,
  "email_marketplace_notifications": false
}
```

**Response:**
```json
{
  "message": "Email preferences updated successfully",
  "email_preferences": {
    "email_marketing": false,
    "email_product_updates": true,
    "email_marketplace_notifications": false
  }
}
```

**Email Preference Fields:**

- `email_marketing`: Marketing emails and promotional content
- `email_product_updates`: Product updates and new feature announcements
- `email_marketplace_notifications`: Marketplace activity notifications

---

## 3. Push Notification Preferences

### 3.1 Update Push Notification Preferences

Update the user's push notification preferences.

**Endpoint:** `POST /profile/push-notification-preferences`

**Request Body:**

```json
{
  "push_pomodoro_alerts": true,
  "push_flashcard_reminders": false,
  "push_marketplace_purchase_confirmations": true,
  "push_marketplace_sale_notifications": true,
  "push_feature_announcements": false
}
```

**Response:**
```json
{
  "message": "Push notification preferences updated successfully",
  "push_notification_preferences": {
    "push_pomodoro_alerts": true,
    "push_flashcard_reminders": false,
    "push_marketplace_purchase_confirmations": true,
    "push_marketplace_sale_notifications": true,
    "push_feature_announcements": false
  }
}
```

**Push Notification Preference Fields:**

- `push_pomodoro_alerts`: Pomodoro timer alerts and notifications
- `push_flashcard_reminders`: Flashcard review reminders
- `push_marketplace_purchase_confirmations`: Purchase confirmations from marketplace
- `push_marketplace_sale_notifications`: Sales notifications for user's marketplace listings
- `push_feature_announcements`: New feature announcements

---

## 4. Error Responses

All endpoints may return the following error responses:

### 401 Unauthorized

```json
{
  "error": "Unauthenticated",
  "message": "User not authenticated"
}
```

### 400 Bad Request

```json
{
  "error": "Validation failed",
  "message": "The given data was invalid.",
  "errors": {
    "field_name": ["Error message for field"]
  }
}
```

### 500 Internal Server Error

```json
{
  "error": "Failed to process request",
  "message": "Detailed error message"
}
```

---

## 5. UI Implementation Guidelines

### 5.1 Profile Settings Screen Structure

1. **Basic Information Section**

   - Name input
   - Email (read-only)
   - Country selector
   - Location coordinates (auto-filled or manual)
   - "I am" field (role/title)
   - About section (textarea)

2. **Education Section**

   - School name
   - Field of study
   - Education level

3. **Usage Purpose Section**

   - Checkboxes for: Exam, Project, Research, Brainstorming, Course Notes
   - "Other" text field

4. **Profile Picture Section**

   - Current picture display
   - Upload button
   - Remove option

5. **Email Preferences Section**

   - Toggle switches for each email type
   - Save button for email preferences

6. **Push Notifications Section**

   - Toggle switches for each notification type
   - Save button for push notifications

### 5.2 Default Values

- All email preferences default to `true`
- All push notification preferences default to `true`
- Profile picture is optional (placeholder image used when not set)

### 5.3 Validation Rules

- Name: Required, max 255 characters
- Country: Optional, max 191 characters
- Latitude/Longitude: Optional, numeric values
- "I am": Optional, max 191 characters
- About: Optional, text field
- School fields: Optional, max 191 characters each
- Profile picture: Image file (jpeg, png, jpg, gif), max 5MB

### 5.4 User Experience Considerations

1. **Real-time Updates**: Consider implementing real-time preference updates without requiring full page refresh
2. **Confirmation Messages**: Show success messages when preferences are updated
3. **Loading States**: Display loading indicators during API calls
4. **Error Handling**: Display user-friendly error messages for validation failures
5. **Profile Picture Preview**: Show preview before uploading new profile picture
6. **Responsive Design**: Ensure all sections work well on mobile devices

### 5.5 Security Considerations

- All API calls require valid authentication token
- Profile picture uploads should be validated for file type and size
- Email field should be read-only in the UI (changes require separate verification process)
- Consider adding confirmation dialogs for critical preference changes

---

## 6. Testing Recommendations

### 6.1 Test Cases

1. **Profile Update**

   - Update individual fields
   - Update multiple fields simultaneously
   - Test validation for required fields
   - Test character limits

2. **Profile Picture Upload**

   - Upload valid image files
   - Test file size limits
   - Test invalid file types
   - Test replacing existing picture

3. **Email Preferences**

   - Toggle individual preferences
   - Test default values
   - Verify preference persistence

4. **Push Notification Preferences**

   - Toggle individual preferences
   - Test default values
   - Verify preference persistence

5. **Error Scenarios**

   - Test with expired authentication token
   - Test with invalid data
   - Test network failures

---

## 7. API Rate Limiting

Consider implementing rate limiting for:

- Profile picture uploads (to prevent abuse)
- Profile update requests (to prevent rapid changes)

---

## 8. Future Enhancements

Potential future features to consider:

- Profile visibility settings
- Social media links
- Skills and interests tags
- Profile completion percentage
- Profile view analytics
- Export profile data
- Account deletion/deactivation

---

**Last Updated:** November 24, 2025

**API Version:** v1

**Documentation Version:** 1.0
