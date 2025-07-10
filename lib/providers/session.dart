import 'package:navinotes/packages.dart';

class SessionManager extends ChangeNotifier {
  static const String _tokenKey = 'user_token';
  static const String _userKey = 'user_data';

  User? user;
  String? token;
  String? email;
  String? otp;
  List<Board> userBoards = [];
  SharedPreferences? _prefs;
  bool _isInitialized = false;

  // Initialize SessionManager with SharedPreferences
  Future<void> init() async {
    if (_isInitialized) return;
    _prefs = await SharedPreferences.getInstance();
    _isInitialized = true;
    await _loadSession();
  }

  // Ensure prefs is initialized before use
  Future<void> _ensureInitialized() async {
    if (!_isInitialized) {
      await init();
    }
  }

  // Load saved session from SharedPreferences
  Future<void> _loadSession() async {
    await _ensureInitialized();
    debugPrint("Loading token from prefs");
    token = _prefs!.getString(_tokenKey);
    debugPrint("Prefs: $token");

    debugPrint("Loading user from prefs");
    final userJson = _prefs!.getString(_userKey);
    debugPrint("User: $userJson");

    if (userJson != null) {
      user = User.fromJson(jsonDecode(userJson));
      email = user?.email;
    }
    notifyListeners();
  }

  // Check if user is logged in
  bool isLoggedIn() {
    // If we're not initialized yet, we can't be logged in
    if (!_isInitialized) {
      debugPrint("Session not initialized yet");
      return false;
    }
    
    final loggedIn = token != null && user != null;
    debugPrint("isLoggedIn check - Token: ${token != null}, User: ${user != null}");
    return loggedIn;
  }

  // Clear all session data
  Future<void> clearSession() async {
    await _ensureInitialized();
    await _prefs!.remove(_tokenKey);
    await _prefs!.remove(_userKey);
    user = null;
    token = null;
    email = null;
    otp = null;
    userBoards = [];
    notifyListeners();
  }

  // Update session with new user data and token
  Future<void> updateSession({User? user, String? token}) async {
    await _ensureInitialized();
    this.user = user;
    this.token = token;

    if (token != null) {
      debugPrint("storing token to prefs");
      _prefs!.setString(_tokenKey, token);
    }

    if (user != null) {
      debugPrint("storing user to prefs");
      _prefs!.setString(_userKey, jsonEncode(user.toJson()));
    }

    initializeUserValues();
    notifyListeners();
  }

  void initializeUserValues() {
    //
  }

  Future<void> getAllBoard() async {
    await _ensureInitialized();
    List<Board> boards = await DatabaseHelper.instance.getAllBoards();
    userBoards = boards;
    notifyListeners();
  }

  Map<String, String> sessionHeaders() {
    final headers = {'Content-Type': 'application/json'};
    headers['Accept'] = 'application/json';
    headers['Authorization'] = 'Bearer $token';
    return headers;
  }

  void updateEmail(String value) {
    email = value;
    user?.updateEmail(value);
    notifyListeners();
  }

  void updateOtp(String value) {
    otp = value;
    user?.updateOtp(value);
    notifyListeners();
  }

  String? getEmail() => user?.email ?? email;
  String? getOtp() => user?.otp ?? otp;
  String? getName() => user?.name;
}
