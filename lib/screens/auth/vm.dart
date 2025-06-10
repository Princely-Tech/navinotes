import 'package:flutter/material.dart';
import 'package:navinotes/settings/apptheme.dart';
import 'package:navinotes/settings/navigation_helper.dart';
import 'package:navinotes/settings/routes.dart';

enum AuthType { login, signUp }

BorderSide defBorderSide = BorderSide(color: Apptheme.white.withAlpha(30));

class AuthVM extends ChangeNotifier {
  AuthType authType = AuthType.login;
  Color inputFillColor = Apptheme.whiteSmoke;

  toggleAuthType() {
    authType = authType == AuthType.login ? AuthType.signUp : AuthType.login;
    notifyListeners();
  }
  // updateAuthType(AuthType type) {
  //   authType = type;
  //   notifyListeners();
  // }

  void login() {
    NavigationHelper.pushReplacement(Routes.aboutMe);
  }
}

List<String> authFooterLinks = ['Privacy Policy', 'Terms', 'Help'];
