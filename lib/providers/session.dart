import 'package:navinotes/packages.dart';

class SessionManager extends ChangeNotifier {
  User? user;
  String? token;

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

  void updateEmail(String email) {
    user?.updateEmail(email);
    notifyListeners();
  }

  void updateOtp(String otp) {
    user?.updateOtp(otp);
    notifyListeners();
  }

  String? getEmail() {
    return user?.email;
  }

  String? getOtp() {
    return user?.otp;
  }

  String? getName() {
    return user?.name;
  }
}
