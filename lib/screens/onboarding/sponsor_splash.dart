import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_translator/google_translator.dart';
import 'package:malariax/services/helper.dart';
import 'package:malariax/settings/app_theme.dart';

class SponsorSplashScreen extends StatefulWidget {
  const SponsorSplashScreen({super.key});

  @override
  State<SponsorSplashScreen> createState() => _SponsorSplashScreenState();
}

class _SponsorSplashScreenState extends State<SponsorSplashScreen> {
  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
    super.initState();
  }

  var radius = 12.0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkGreenColor,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.all(2),
              height: radius,
              width: radius,
              decoration: BoxDecoration(
                color: AppTheme.whiteColor.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
            ),
            Container(
              margin: const EdgeInsets.all(2),
              height: radius,
              width: radius,
              decoration: BoxDecoration(
                color: AppTheme.whiteColor,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Supported By:',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: Helper().getFontSize(41),
                            fontStyle: FontStyle.italic,
                            fontFamily: 'Times New Roman',
                            fontWeight: FontWeight.w400,
                            height: 1.02,
                            letterSpacing: -1.36,
                          ),
                        ).translate("Supported By:"),
                        SizedBox(
                          height: Helper().getHeight(30),
                        ),
                        SizedBox(
                          width: Helper().getWidth(300),
                          child: Center(
                            child: Image.asset(
                              'assets/images/sponsors.png',
                              width: 400,
                              // height: 600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
