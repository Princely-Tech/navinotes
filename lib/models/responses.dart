import 'package:navinotes/packages.dart';

class AuthApiResponse {
  final String message;
  final User user;
  final String token;

  AuthApiResponse({required this.message, required this.user, required this.token});

  factory AuthApiResponse.fromJson(Map<String, dynamic> json) {
    return AuthApiResponse(
      message: json['message'],
      user: User.fromJson(json['user']),
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'message': message, 'user': user.toJson(), 'token': token};
  }
}
