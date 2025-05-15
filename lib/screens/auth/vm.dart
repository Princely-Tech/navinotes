import 'package:flutter/material.dart';
import 'package:navinotes/settings/navigation_helper.dart';
import 'package:navinotes/settings/routes.dart';

enum AuthType { login, signUp }

class AuthVM extends ChangeNotifier {
  AuthType authType = AuthType.login;

  updateAuthType(AuthType type) {
    authType = type;
    notifyListeners();
  }

  void login() {
    NavigationHelper.pushReplacement(Routes.aboutMe);
  }
}

List<String> authFooterLinks = ['Privacy Policy', 'Terms', 'Help'];