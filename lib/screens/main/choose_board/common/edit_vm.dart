import 'package:navinotes/packages.dart';

class BoardEditVm extends ChangeNotifier {
  Board? _board;
  bool _isLoading = true;
  String? _error;
  bool _showSuccess = false;
  String? _successMessage;

  Board? get board => _board;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get showSuccess => _showSuccess;
  String? get successMessage => _successMessage;

  // Initialize the ViewModel with board data
  Future<void> initialize(int boardId, {bool showSuccess = false, String? message}) async {
    _showSuccess = showSuccess;
    _successMessage = message;
    
    if (boardId > 0) {
      await _loadBoard(boardId);
    } else {
      _error = 'Your board cannot be loaded at this time. Please try again';
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _loadBoard(int boardId) async {
    try {
      _isLoading = true;
      _error = null;
      _board = null; // Clear previous board data
      notifyListeners();

      final dbHelper = DatabaseHelper.instance;
      final boards = await dbHelper.getAllBoards();
      final board = boards.firstWhere(
        (b) => b.id == boardId,
        orElse: () => throw Exception('Board not found'),
      );

      _board = board;
      _error = null;
    } catch (e) {
      debugPrint('Error loading board: $e');
      _error = 'Failed to load board: ${e.toString()}';
      _board = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void dismissSuccess() {
    _showSuccess = false;
    _successMessage = null;
    notifyListeners();
  }

  @override
  void dispose() {
    // Clean up any resources if needed
    super.dispose();
  }
}
