import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_translator/google_translator.dart';
import 'package:malariax/services/helper.dart';
import 'package:malariax/settings/app_theme.dart';

class FoundationSplashScreen extends StatefulWidget {
  const FoundationSplashScreen({super.key});

  @override
  State<FoundationSplashScreen> createState() => _FoundationSplashScreenState();
}

class _FoundationSplashScreenState extends State<FoundationSplashScreen> {
  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
    super.initState();
  }

  var radius = 12.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                color: AppTheme.blackColor,
                shape: BoxShape.circle,
              ),
            ),
            Container(
              margin: const EdgeInsets.all(2),
              height: radius,
              width: radius,
              decoration: BoxDecoration(
                color: AppTheme.blackColor.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
            ),
            // Container(
            //   margin: const EdgeInsets.all(2),
            //   height: radius,
            //   width: radius,
            //   decoration: BoxDecoration(
            //     color: Colors.white.withOpacity(0.5),
            //     shape: BoxShape.circle,
            //   ),
            // ),
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: AppTheme.yellowColor,

          // image: const DecorationImage(
          //   image: AssetImage("assets/images/splash_bg.png"),
          //   fit: BoxFit.cover,
          // ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 30),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Under The",
                      style: TextStyle(
                        color: AppTheme.blackColor,
                        fontSize: 13,
                        fontWeight: FontWeight.w300,
                      ),
                    ).translate("Under The"),
                    SizedBox(
                      height: Helper().getHeight(8),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        "PRINCE NED NWOKO \nAFRICA MALARIA \nELIMINATION PROJECT",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: AppTheme.blackColor,
                            fontSize: 19,
                            height: 1.2,
                            fontWeight: FontWeight.w300),
                      ),
                    ),
                    SizedBox(
                      height: Helper().getHeight(100),
                    ),
                    Text(
                      "Brought to you by:",
                      style: TextStyle(
                        color: AppTheme.blackColor,
                        fontSize: 20,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w400,
                      ),
                    ).translate("Brought to you by"),
                    SizedBox(
                      height: Helper().getHeight(20),
                    ),
                    Center(
                      child: Center(
                        child: Image.asset(
                            width: 174,
                            height: 174,
                            'assets/images/onboarding/foundation.png'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
