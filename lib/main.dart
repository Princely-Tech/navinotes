import 'package:flutter/material.dart';
import 'package:navinotes/packages.dart';
import 'package:navinotes/providers/session.dart';
import 'package:navinotes/settings/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize session manager
  final sessionManager = SessionManager();
  await sessionManager.init();
  
  await dotenv.load(fileName: ".env");
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => sessionManager),
        // Add other providers here
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return CustomProviders(
      child: MaterialApp(
        title: AppStrings.appName,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(fontFamily: AppTheme.fontFamily),
        initialRoute: Routes.splash,
        // initialRoute: Routes.auth, //TODO uncomment
        routes: routes,
        navigatorKey: NavigationHelper.navigatorKey,
      ),
    );
  }
}
