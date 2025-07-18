import 'package:navinotes/packages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize session manager
  final sessionManager = SessionManager();
  await sessionManager.init();

  await dotenv.load(fileName: ".env");

  runApp(
    CustomProviders(
      sessionManager: sessionManager,
      child: MaterialApp(
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          FlutterQuillLocalizations.delegate,
        ],
        title: AppStrings.appName,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(fontFamily: AppTheme.fontFamily),
        initialRoute: Routes.noteTemplate,
        // initialRoute: Routes.splash, //TODO uncomment
        routes: routes,
        navigatorKey: NavigationHelper.navigatorKey,
      ),
    ),
  );
}