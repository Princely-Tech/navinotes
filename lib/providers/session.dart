import 'package:navinotes/packages.dart';

class SessionManager extends ChangeNotifier {
  User? user;
  String? token;
  String? email;
  String? otp;

  updateSession({User? user, String? token}) {
    this.user = user;
    this.token = token;
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
