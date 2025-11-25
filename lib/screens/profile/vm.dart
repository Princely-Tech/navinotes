import 'dart:io';
import 'package:navinotes/packages.dart';
import 'package:navinotes/settings/navi_backup.dart';

class ProfileVm extends ChangeNotifier {
  final SessionManager sessionManager;
  final ApiServiceProvider apiServiceProvider;
  final BuildContext context;

  ProfileVm({
    required this.sessionManager,
    required this.apiServiceProvider,
    required this.context,
  }) {
    _loadUserStats();
  }

  bool _isStatsLoading = false;
  bool get isStatsLoading => _isStatsLoading;

  bool _isProfilePictureLoading = false;
  bool get isProfilePictureLoading => _isProfilePictureLoading;

  bool _isProfileDataLoading = false;
  bool get isProfileDataLoading => _isProfileDataLoading;

  bool _isEmailPrefsLoading = false;
  bool get isEmailPrefsLoading => _isEmailPrefsLoading;

  bool _isPushPrefsLoading = false;
  bool get isPushPrefsLoading => _isPushPrefsLoading;

  bool _isAccountActionLoading = false;
  bool get isAccountActionLoading => _isAccountActionLoading;

  // Keep for backward compatibility if needed, or for initial screen load
  bool get isLoading => _isStatsLoading;

  int _totalBoards = 0;
  int get totalBoards => _totalBoards;

  int _totalContents = 0;
  int get totalContents => _totalContents;

  int _totalNotes = 0;
  int get totalNotes => _totalNotes;

  int _totalMindMaps = 0;
  int get totalMindMaps => _totalMindMaps;

  int _totalFiles = 0;
  int get totalFiles => _totalFiles;

  User? get currentUser => sessionManager.user;

  String get userName => currentUser?.name ?? '';
  String get userEmail => currentUser?.email ?? '';
  String get userSchool => currentUser?.schoolName ?? '';
  String get userField => currentUser?.schoolField ?? '';
  String get userLevel => currentUser?.schoolLevel ?? '';
  String get userCountry => currentUser?.country ?? '';
  String get userAbout => currentUser?.about ?? '';

  String get memberSince {
    if (currentUser?.createdAt != null) {
      try {
        final date = DateTime.parse(currentUser!.createdAt);
        return DateFormat('MMMM yyyy').format(date);
      } catch (e) {
        return 'Unknown';
      }
    }
    return 'Unknown';
  }

  Future<void> _loadUserStats() async {
    _isStatsLoading = true;
    notifyListeners();
    try {
      // Get all boards for the user
      final boards = await DatabaseHelper.instance.getAllBoards();
      _totalBoards = boards.length;

      // Get all contents across all boards
      int totalContentsCount = 0;
      int notesCount = 0;
      int mindMapsCount = 0;
      int filesCount = 0;

      for (final board in boards) {
        final contents = await board.getContents();
        totalContentsCount += contents.length;

        for (final content in contents) {
          switch (content.type) {
            case AppContentType.note:
              notesCount++;
              break;
            case AppContentType.mindmapNode:
              mindMapsCount++;
              break;
            case AppContentType.file:
              filesCount++;
              break;
            case AppContentType.flashcardDeck:
              // Handle flashcard decks if needed
              break;
          }
        }
      }

      _totalContents = totalContentsCount;
      _totalNotes = notesCount;
      _totalMindMaps = mindMapsCount;
      _totalFiles = filesCount;
    } catch (e) {
      debugPrint('Error loading user stats: $e');
    } finally {
      _isStatsLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshStats() async {
    await _loadUserStats();
  }

  Future<void> updateProfilePicture(File imageFile) async {
    _isProfilePictureLoading = true;
    notifyListeners();
    try {
      if (apiServiceProvider != null) {
        final request = FormDataRequest.post(
          '/profile/picture',
          files: {'profile_picture': imageFile},
        );

        final response = await apiServiceProvider!.apiService
            .sendFormDataRequest(request);

        if (response['user'] != null) {
          final updatedUser = User.fromJson(response['user']);
          await sessionManager.updateSession(user: updatedUser);
        } else {
          // Fallback if API doesn't return user object
          if (currentUser != null) {
            // In a real app, we would update the profilePicture field with the URL returned by the API
            // For local testing without backend, we might want to just save the path if we can handle it
            // currentUser!.profilePicture = imageFile.path;
            // For now, since we can't reliably get the URL without the backend response containing it or a way to parse it, we might rely on reloading the profile or trusting the backend return.
            // Assuming backend returns the updated user object is the standard way.
          }
        }

        if (context.mounted) {
          MessageDisplayService.showMessage(
            context,
            'Profile picture updated successfully',
          );
        }
      } else {
        // Simulate API delay for non-connected testing if needed, or just error out?
        // For now, let's throw an error if API is not available as per request "make a call to backend"
        throw Exception("API Service not available");
      }
    } catch (e) {
      if (context.mounted) {
        MessageDisplayService.showErrorMessage(
          context,
          'Failed to update profile picture: $e',
        );
      }
    } finally {
      _isProfilePictureLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateProfileData({
    String? name,
    String? country,
    String? iam,
    String? about,
    String? schoolName,
    String? schoolField,
    String? schoolLevel,
  }) async {
    _isProfileDataLoading = true;
    notifyListeners();
    try {
      if (apiServiceProvider != null) {
        final Map<String, dynamic> data = {};
        if (name != null) data['name'] = name;
        if (country != null) data['country'] = country;
        if (iam != null) data['iam'] = iam;
        if (about != null) data['about'] = about;
        if (schoolName != null) data['school_name'] = schoolName;
        if (schoolField != null) data['school_field'] = schoolField;
        if (schoolLevel != null) data['school_level'] = schoolLevel;

        final response = await apiServiceProvider!.apiService.sendJsonRequest(
          JsonRequest.post('/profile', data),
        );

        if (response['user'] != null) {
          final updatedUser = User.fromJson(response['user']);
          await sessionManager.updateSession(user: updatedUser);
        }

        if (context.mounted) {
          MessageDisplayService.showMessage(
            context,
            'Profile updated successfully',
          );
        }
      } else {
        throw Exception("API Service not available");
      }
    } catch (e) {
      if (context.mounted) {
        MessageDisplayService.showErrorMessage(
          context,
          'Failed to update profile: $e',
        );
      }
    } finally {
      _isProfileDataLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateEmailPreferences({
    bool? emailMarketing,
    bool? emailProductUpdates,
    bool? emailMarketplaceNotifications,
  }) async {
    _isEmailPrefsLoading = true;
    notifyListeners();
    try {
      if (apiServiceProvider != null) {
        final Map<String, dynamic> data = {};
        if (emailMarketing != null) {
          data['email_marketing'] = emailMarketing;
        }
        if (emailProductUpdates != null) {
          data['email_product_updates'] = emailProductUpdates;
        }
        if (emailMarketplaceNotifications != null) {
          data['email_marketplace_notifications'] =
              emailMarketplaceNotifications;
        }

        final response = await apiServiceProvider!.apiService.sendJsonRequest(
          JsonRequest.post('/profile/email-preferences', data),
        );

        // Update local session based on success - optimistically or from response
        // The docs say it returns "email_preferences" object, not the full user.
        // So we update the current user manually.
        if (currentUser != null) {
          if (emailMarketing != null) {
            currentUser!.emailMarketing = emailMarketing;
          }
          if (emailProductUpdates != null) {
            currentUser!.emailProductUpdates = emailProductUpdates;
          }
          if (emailMarketplaceNotifications != null) {
            currentUser!.emailMarketplaceNotifications =
                emailMarketplaceNotifications;
          }
          await sessionManager.updateSession(user: currentUser);
        }

        if (context.mounted) {
          MessageDisplayService.showMessage(
            context,
            'Email preferences updated',
          );
        }
      } else {
        throw Exception("API Service not available");
      }
    } catch (e) {
      if (context.mounted) {
        MessageDisplayService.showErrorMessage(
          context,
          'Failed to update email preferences: $e',
        );
      }
    } finally {
      _isEmailPrefsLoading = false;
      notifyListeners();
    }
  }

  Future<void> updatePushPreferences({
    bool? pushPomodoroAlerts,
    bool? pushFlashcardReminders,
    bool? pushMarketplacePurchaseConfirmations,
    bool? pushMarketplaceSaleNotifications,
    bool? pushFeatureAnnouncements,
  }) async {
    _isPushPrefsLoading = true;
    notifyListeners();
    try {
      if (apiServiceProvider != null) {
        final Map<String, dynamic> data = {};
        if (pushPomodoroAlerts != null) {
          data['push_pomodoro_alerts'] = pushPomodoroAlerts;
        }
        if (pushFlashcardReminders != null) {
          data['push_flashcard_reminders'] = pushFlashcardReminders;
        }
        if (pushMarketplacePurchaseConfirmations != null) {
          data['push_marketplace_purchase_confirmations'] =
              pushMarketplacePurchaseConfirmations;
        }
        if (pushMarketplaceSaleNotifications != null) {
          data['push_marketplace_sale_notifications'] =
              pushMarketplaceSaleNotifications;
        }
        if (pushFeatureAnnouncements != null) {
          data['push_feature_announcements'] = pushFeatureAnnouncements;
        }

        await apiServiceProvider!.apiService.sendJsonRequest(
          JsonRequest.post('/profile/push-notification-preferences', data),
        );

        // Update local session based on success
        if (currentUser != null) {
          if (pushPomodoroAlerts != null) {
            currentUser!.pushPomodoroAlerts = pushPomodoroAlerts;
          }
          if (pushFlashcardReminders != null) {
            currentUser!.pushFlashcardReminders = pushFlashcardReminders;
          }
          if (pushMarketplacePurchaseConfirmations != null) {
            currentUser!.pushMarketplacePurchaseConfirmations =
                pushMarketplacePurchaseConfirmations;
          }
          if (pushMarketplaceSaleNotifications != null) {
            currentUser!.pushMarketplaceSaleNotifications =
                pushMarketplaceSaleNotifications;
          }
          if (pushFeatureAnnouncements != null) {
            currentUser!.pushFeatureAnnouncements = pushFeatureAnnouncements;
          }
          await sessionManager.updateSession(user: currentUser);
        }

        if (context.mounted) {
          MessageDisplayService.showMessage(
            context,
            'Push notification preferences updated',
          );
        }
      } else {
        throw Exception("API Service not available");
      }
    } catch (e) {
      if (context.mounted) {
        MessageDisplayService.showErrorMessage(
          context,
          'Failed to update push preferences: $e',
        );
      }
    } finally {
      _isPushPrefsLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    try {
      _isAccountActionLoading = true;
      notifyListeners();
      await sessionManager.clearSession();
      if (context.mounted) {
        NavigationHelper.pushAndRemoveUntil(Routes.auth);
      }
    } catch (e) {
      if (context.mounted) {
        MessageDisplayService.showErrorMessage(context, 'Failed to logout: $e');
      }
    } finally {
      _isAccountActionLoading = false;
      notifyListeners();
    }
  }

  Future<void> exportUserData() async {
    try {
      _isAccountActionLoading = true;
      notifyListeners();

      await NaviBackupService.exportUserData(
        context: context,
        user: currentUser,
      );
    } catch (e) {
      if (context.mounted) {
        MessageDisplayService.showErrorMessage(
          context,
          'Failed to export data: $e',
        );
      }
    } finally {
      _isAccountActionLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteAccount(String reason) async {
    try {
      _isAccountActionLoading = true;
      notifyListeners();

      // For now, just clear local data and logout since API endpoint may not be available
      // TODO: Implement actual API call when endpoint is available
      if (apiServiceProvider != null) {
        // Future API implementation would go here
        debugPrint(
          'API call for account deletion would be made here with reason: $reason',
        );
      }

      // Clear local data by deleting all boards and their contents
      final boards = await DatabaseHelper.instance.getAllBoards();
      for (final board in boards) {
        final contents = await board.getContents();
        for (final content in contents) {
          await DatabaseHelper.instance.deleteContent(content.id!);
        }
      }
      // Clear session data
      await sessionManager.clearSession();

      if (context.mounted) {
        MessageDisplayService.showMessage(
          context,
          'Account data cleared successfully',
        );
        NavigationHelper.pushAndRemoveUntil(Routes.auth);
      }
    } catch (e) {
      if (context.mounted) {
        MessageDisplayService.showErrorMessage(
          context,
          'Failed to delete account: $e',
        );
      }
    } finally {
      _isAccountActionLoading = false;
      notifyListeners();
    }
  }
}
