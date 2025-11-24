import 'dart:io';
import 'package:navinotes/packages.dart';

class ProfileVm extends ChangeNotifier {
  final SessionManager sessionManager;
  final ApiServiceProvider? apiServiceProvider;
  final BuildContext context;

  ProfileVm({
    required this.sessionManager,
    this.apiServiceProvider,
    required this.context,
  }) {
    _loadUserStats();
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;

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

  String get userName => currentUser?.name ?? 'Unknown User';
  String get userEmail => currentUser?.email ?? '';
  String get userSchool => currentUser?.schoolName ?? 'Not specified';
  String get userField => currentUser?.schoolField ?? 'Not specified';
  String get userLevel => currentUser?.schoolLevel ?? 'Not specified';
  String get userCountry => currentUser?.country ?? 'Not specified';
  String get userAbout => currentUser?.about ?? 'No description available';

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
    _setLoading(true);
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
      _setLoading(false);
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  Future<void> refreshStats() async {
    await _loadUserStats();
  }

  Future<void> updateProfilePicture(File imageFile) async {
    _setLoading(true);
    try {
      // TODO: Implement API call
      // await apiServiceProvider?.updateProfilePicture(imageFile);

      // Simulate API delay
      await Future.delayed(const Duration(seconds: 1));

      // Mock update local user
      if (currentUser != null) {
        debugPrint('Updating profile picture to: ${imageFile.path}');

        // In a real app, we would update the profilePicture field with the URL returned by the API
        // For local testing without backend, we might want to just save the path if we can handle it
        // currentUser!.profilePicture = imageFile.path;

        // Update session
        await sessionManager.updateSession(user: currentUser);
        notifyListeners();

        if (context.mounted) {
          MessageDisplayService.showMessage(
            context,
            'Profile picture updated successfully',
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        MessageDisplayService.showErrorMessage(
          context,
          'Failed to update profile picture: $e',
        );
      }
    } finally {
      _setLoading(false);
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
    _setLoading(true);
    try {
      await Future.delayed(const Duration(seconds: 1));

      if (currentUser != null) {
        if (name != null) currentUser!.name = name;
        if (country != null) currentUser!.country = country;
        if (iam != null) currentUser!.iam = iam;
        if (about != null) currentUser!.about = about;
        if (schoolName != null) currentUser!.schoolName = schoolName;
        if (schoolField != null) currentUser!.schoolField = schoolField;
        if (schoolLevel != null) currentUser!.schoolLevel = schoolLevel;

        await sessionManager.updateSession(user: currentUser);
        notifyListeners();

        if (context.mounted) {
          MessageDisplayService.showMessage(
            context,
            'Profile updated successfully',
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        MessageDisplayService.showErrorMessage(
          context,
          'Failed to update profile: $e',
        );
      }
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updateEmailPreferences({
    bool? emailMarketing,
    bool? emailProductUpdates,
    bool? emailMarketplaceNotifications,
  }) async {
    _setLoading(true);
    try {
      await Future.delayed(const Duration(seconds: 1));

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
        notifyListeners();

        if (context.mounted) {
          MessageDisplayService.showMessage(
            context,
            'Email preferences updated',
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        MessageDisplayService.showErrorMessage(
          context,
          'Failed to update email preferences: $e',
        );
      }
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updatePushPreferences({
    bool? pushPomodoroAlerts,
    bool? pushFlashcardReminders,
    bool? pushMarketplacePurchaseConfirmations,
    bool? pushMarketplaceSaleNotifications,
    bool? pushFeatureAnnouncements,
  }) async {
    _setLoading(true);
    try {
      await Future.delayed(const Duration(seconds: 1));

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
        notifyListeners();

        if (context.mounted) {
          MessageDisplayService.showMessage(
            context,
            'Push notification preferences updated',
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        MessageDisplayService.showErrorMessage(
          context,
          'Failed to update push preferences: $e',
        );
      }
    } finally {
      _setLoading(false);
    }
  }

  Future<void> logout() async {
    try {
      _setLoading(true);
      await sessionManager.clearSession();
      if (context.mounted) {
        NavigationHelper.pushAndRemoveUntil(Routes.auth);
      }
    } catch (e) {
      if (context.mounted) {
        MessageDisplayService.showErrorMessage(context, 'Failed to logout: $e');
      }
    } finally {
      _setLoading(false);
    }
  }

  Future<void> deleteAccount(String reason) async {
    try {
      _setLoading(true);

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
      _setLoading(false);
    }
  }
}
