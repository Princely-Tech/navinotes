import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:malariax/models/user/login_request/user.dart';
import 'package:malariax/services/helper.dart';
import 'package:malariax/services/routes/routes.dart';
import 'package:malariax/settings/app_settings.dart';
import 'package:malariax/settings/app_theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
    super.initState();
    Future.delayed(const Duration(seconds: 6), () async {
      goToNextScreen();
    });
  }

  goToNextScreen() async {
    if (await isFirstRun()) {
      Navigator.pushReplacementNamed(
          Helper().getContext(), Routes.onbordingSlider);
      return;
    }

    if (await isUserLoggedIn()) {
      return goHome();
    }

    //go to login
    goToLogin();
  }

  Future<bool> isFirstRun() async {
    await appSettings.getData();
    if (appSettings.firstRunAtDate == null) {
      var now = DateTime.now().toString();
      debugPrint('App running for the first time on: $now');

      appSettings.firstRunAtDate = now;

      appSettings.save();

      //add pop up for test users
      return true;
    }

    return false;
  }

  Future<bool> isUserLoggedIn() async {
    var data = await user.getData();
    await user.getToken();
    return data != null && data.id != 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkGreenColor,
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        // color: AppTheme.blackColor,
        child: Center(
          child: Image.asset(
            'assets/icons/logo_green.png',
            width: Helper().getFontSize(564),
          ),
          // child: SvgPicture.asset('assets/icons/logo.svg'),
        ),
      ),
    );
  }
}
