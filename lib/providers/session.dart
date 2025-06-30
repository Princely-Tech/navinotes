import 'package:navinotes/packages.dart';

class SessionManager extends ChangeNotifier {
  User? user;
  String? token;
  String? email;
  String? otp;
  List<Board> userBoards = [];

  void initializeUserValues() {
    //
  }

  Future<void> getAllBoard() async {
    List<Board> boards = await DatabaseHelper.instance.getAllBoards();
    userBoards = boards;
    notifyListeners();
  }

  updateSession({User? user, String? token}) {
    this.user = user;
    this.token = token;
    initializeUserValues();
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

  String? getEmail() {
    return user?.email ?? email;
  }

  String? getOtp() {
    return user?.otp ?? otp;
  }

  String? getName() {
    return user?.name;
  }
}
