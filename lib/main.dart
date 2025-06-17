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
        theme: ThemeData(fontFamily: Apptheme.fontFamily),
        initialRoute: Routes.boardNatureEdit,
        // initialRoute: Routes.auth, //TODO uncomment
        routes: routes,
        navigatorKey: NavigationHelper.navigatorKey,
      ),
    );
  }
}
