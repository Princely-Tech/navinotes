import 'package:flutter/material.dart';
import 'package:navinotes/screens/auth/index.dart';
import 'package:navinotes/screens/aboutMe/index.dart';
import 'package:navinotes/screens/main/dashboard/index.dart';
import 'package:navinotes/screens/main/choose_board/index.dart';

Map<String, WidgetBuilder> routes = {
  Routes.auth: (context) => const AuthScreen(),
  Routes.aboutMe: (context) => const AboutMeScreen(),
  Routes.dashboard: (context) => DashboardScreen(),
  Routes.chooseBoard: (context) => ChooseBoardScreen(),
};

class Routes {
  Routes._();
  static const auth = 'auth';
  static const aboutMe = 'aboutMe';
  static const dashboard = 'dashboard';
  static const chooseBoard = 'chooseBoard';
}
