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

  getEmail() {
    return user?.email;
  }
}
