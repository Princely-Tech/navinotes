import 'package:navinotes/packages.dart';

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
        theme: ThemeData(fontFamily: AppTheme.fontFamily),
        initialRoute: Routes.boardNatureMindMap,
        // initialRoute: Routes.auth, //TODO uncomment
        routes: routes,
        navigatorKey: NavigationHelper.navigatorKey,
      ),
    );
  }
}
