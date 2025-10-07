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
            case AppContentType.notebook:
              notesCount++;
              break;
            case AppContentType.mindmap:
              mindMapsCount++;
              break;
            case AppContentType.mindmapNode:
              // Mind map nodes are counted as part of mind maps
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
        debugPrint('API call for account deletion would be made here with reason: $reason');
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
          'Account data cleared successfully'
        );
        NavigationHelper.pushAndRemoveUntil(Routes.auth);
      }
    } catch (e) {
      if (context.mounted) {
        MessageDisplayService.showErrorMessage(
          context, 
          'Failed to delete account: $e'
        );
      }
    } finally {
      _setLoading(false);
    }
  }
}
