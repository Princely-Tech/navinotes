import 'package:flutter/material.dart';
import 'package:navinotes/providers/index.dart';
import 'package:navinotes/settings/app_strings.dart';
import 'package:navinotes/settings/navigation_helper.dart';
import 'package:navinotes/settings/routes.dart';
import 'package:navinotes/settings/apptheme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return CustomProviders(
      child: MaterialApp(
        title: AppStrings.appName,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(fontFamily: Apptheme.fontFamily),
        initialRoute: Routes.dashboard,
        // initialRoute: Routes.auth, //TODO uncomment
        routes: routes,
        navigatorKey: NavigationHelper.navigatorKey,
      ),
    );
  }
}
