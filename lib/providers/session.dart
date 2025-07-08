import 'dart:convert';
import 'package:navinotes/packages.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SessionManager extends ChangeNotifier {
  static const String _tokenKey = 'user_token';
  static const String _userKey = 'user_data';
  
  User? user;
  String? token;
  String? email;
  String? otp;
  List<Board> userBoards = [];
  late final SharedPreferences _prefs;

  // Initialize SessionManager with SharedPreferences
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    await _loadSession();
  }

  // Load saved session from SharedPreferences
  Future<void> _loadSession() async {
    token = _prefs.getString(_tokenKey);
    final userJson = _prefs.getString(_userKey);
    if (userJson != null) {
      user = User.fromJson(jsonDecode(userJson));
      email = user?.email;
    }
    notifyListeners();
  }

  // Check if user is logged in
  bool isLoggedIn() {
    return token != null && user != null;
  }

  // Clear all session data
  Future<void> clearSession() async {
    await _prefs.remove(_tokenKey);
    await _prefs.remove(_userKey);
    user = null;
    token = null;
    email = null;
    otp = null;
    userBoards = [];
    notifyListeners();
  }

  // Update session with new user data and token
  Future<void> updateSession({User? user, String? token}) async {
    this.user = user;
    this.token = token;
    
    if (token != null) {
      await _prefs.setString(_tokenKey, token);
    }
    
    if (user != null) {
      await _prefs.setString(_userKey, jsonEncode(user.toJson()));
    }
    
    initializeUserValues();
    notifyListeners();
  }

  void initializeUserValues() {
    //
  }

  Future<void> getAllBoard() async {
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
