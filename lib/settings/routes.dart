import 'package:flutter/material.dart';
import 'package:navinotes/screens/auth/index.dart';
import 'package:navinotes/screens/aboutMe/index.dart';

Map<String, WidgetBuilder> routes = {
  Routes.auth: (context) => const AuthScreen(),
  Routes.aboutMe: (context) => const AboutMeScreen(),
};

class Routes {
  Routes._();
  static const auth = 'auth';
  static const aboutMe = 'aboutMe';
}
