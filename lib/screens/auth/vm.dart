import 'package:flutter/material.dart';
import 'package:navinotes/settings/apptheme.dart';
import 'package:navinotes/settings/navigation_helper.dart';
import 'package:navinotes/settings/routes.dart';

enum AuthType { login, signUp }

BorderSide defBorderSide = BorderSide(color: Apptheme.white.withAlpha(30));

class AuthVM extends ChangeNotifier {
  AuthType authType = AuthType.login;
  Color inputFillColor = Apptheme.white.withAlpha(30);
  BorderSide borderSide = defBorderSide;

  TextStyle inputStyle = Apptheme.text.copyWith(
    color: Apptheme.slateGray,
    fontSize: 16,
  );

  TextStyle btnTextStyle = Apptheme.text.copyWith(
    color: Apptheme.white,
    fontSize: 18,
    fontWeight: FontWeight.w700,
  );

  OutlineInputBorder inputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: defBorderSide,
  );

  updateAuthType(AuthType type) {
    authType = type;
    notifyListeners();
  }

  void login() {
    NavigationHelper.pushReplacement(Routes.aboutMe);
  }
}

List<String> authFooterLinks = ['Privacy Policy', 'Terms', 'Help'];
