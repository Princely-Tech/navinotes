import 'package:flutter/material.dart';
import 'package:navinotes/providers/index.dart';
import 'package:navinotes/settings/app_strings.dart';
import 'package:navinotes/settings/navigation_helper.dart';
import 'package:navinotes/settings/routes.dart';
import 'package:navinotes/settings/apptheme.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return CustomProviders(
      child: MaterialApp(
        title: AppStrings.appName,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(fontFamily: Apptheme.fontFamily),
        initialRoute: Routes.auth,
        // initialRoute: Routes.auth, //TODO uncomment
        routes: routes,
        navigatorKey: NavigationHelper.navigatorKey,
      ),
    );
  }
}
