import 'package:navinotes/packages.dart';

class BoardCreateVm extends ChangeNotifier {
  final BoardTypeCodes boardType;

  BoardCreateVm({required this.boardType});

  bool isPrivate = true;
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController subjectController = TextEditingController();
  final TextEditingController levelController = TextEditingController();
  final TextEditingController termController = TextEditingController();
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    subjectController.dispose();
    levelController.dispose();
    termController.dispose();
    super.dispose();
  }

  void updateIsPrivate(bool value) {
    isPrivate = value;
    notifyListeners();
  }

  Future<void> createBoard() async {
    debugPrint('createBoard called for ${boardType.name}');
    if (isLoading) {
      debugPrint('Already loading');
      return;
    }

    if (titleController.text.trim().isEmpty) {
      _showError('Please enter a title for your board');
      return;
    }

    _setLoading(true);

    try {
      // Get current user ID from session
      final sessionManager =
          NavigationHelper.navigatorKey.currentContext!.read<SessionManager>();
      final currentUser = sessionManager.user;

      if (currentUser == null) {
        throw Exception('User not logged in');
      }

      final currentTimestamp = generateUnixTimestamp();

      // Create a new board
      final newBoard = Board(
        guid: generateGUID(currentUser.id!),
        userId: currentUser.id!,
        type: boardType.name,
        name: titleController.text.trim(),
        customization: {'isPrivate': isPrivate, 'theme': 'default'},
        isPublic: !isPrivate,
        description:
            descriptionController.text.trim().isNotEmpty
                ? descriptionController.text.trim()
                : null,
        subject:
            subjectController.text.trim().isNotEmpty
                ? subjectController.text.trim()
                : null,
        level:
            levelController.text.trim().isNotEmpty
                ? levelController.text.trim()
                : null,
        term:
            termController.text.trim().isNotEmpty
                ? termController.text.trim()
                : null,
        createdAt: currentTimestamp,
        updatedAt: currentTimestamp,
      );

      // Save to database
      final dbHelper = DatabaseHelper.instance;
      final boardId = await dbHelper.insertBoard(newBoard);

      if (boardId == 0) {
        throw Exception('Failed to save board to database');
      }

      newBoard.setIDAfterCreate(boardId);

      // Navigate to edit screen with the new board ID
      if (NavigationHelper.navigatorKey.currentContext != null) {
        NavigationHelper.navigateToBoard(
          newBoard,
          replace: true, //Removes the form route and proceed
          // arguments: { //TODO show message using MessageDisplayService
          //   'showSuccess': true,
          //   'message': 'Board created successfully!',
          // },
        );
      }
    } catch (e) {
      debugPrint('Error creating board: $e');
      _showError('Failed to create board: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _showError(String message) {
    if (NavigationHelper.navigatorKey.currentContext != null) {
      ScaffoldMessenger.of(
        NavigationHelper.navigatorKey.currentContext!,
      ).showSnackBar(SnackBar(content: Text(message)));
    }
  }
}
