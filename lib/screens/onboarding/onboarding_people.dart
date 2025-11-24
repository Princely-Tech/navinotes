import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_translator/google_translator.dart';
import 'package:malariax/services/helper.dart';
import 'package:malariax/services/navigation_service.dart';
import 'package:malariax/services/routes/routes.dart';
import 'package:malariax/settings/app_theme.dart';
import 'package:malariax/settings/url_constants.dart';
import 'package:url_launcher/url_launcher_string.dart';

class PeopleSplashScreen extends StatefulWidget {
  const PeopleSplashScreen({
    super.key,
    required this.title,
    required this.body,
    required this.index,
    required this.image,
  });
  final String title, body, image;
  final int index;
  @override
  State<PeopleSplashScreen> createState() => _PeopleSplashScreenState();
}

class _PeopleSplashScreenState extends State<PeopleSplashScreen> {
  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
    super.initState();
    Future.delayed(const Duration(seconds: 3), () async {
      //Navigator.pushReplacementNamed(context, Routes.foundationSplash);
    });
  }

  Color gradientColor() {
    switch (widget.index) {
      case 1:
        return HexColor('#eefac3');
      case 2:
        return HexColor('#f7cd75');
      default:
        return HexColor('#aae5d6');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.only(
              top: 40,
              // bottom: 40,
            ),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              color: AppTheme.greyColor,
              image: DecorationImage(
                image: AssetImage(widget.image),
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    gradientColor(),
                  ],
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Flexible(
                    child: SingleChildScrollView(
                      child: Container(
                        padding: EdgeInsets.only(
                            top: Helper().getHeight(35),
                            bottom: Helper().getHeight(40)),
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            // gradient: LinearGradient(
                            //   begin: Alignment.topCenter,
                            //   end: Alignment.bottomCenter,
                            //   colors: [
                            //     Colors.transparent,
                            //     gradientColor(),
                            //   ],
                            // ),
                            ),
                        child: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: Helper().getWidth(15),
                              ),
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.title,
                                    style: TextStyle(
                                      color: AppTheme.blackColor,
                                      // color: const Color(0xFF264740),
                                      fontSize: Helper().getFontSize(65),
                                      // fontSize: 69.70,
                                      fontFamily: 'Codec Pro',
                                      fontWeight: FontWeight.w500,
                                      height: 1.23,
                                      letterSpacing: 0.03,
                                    ),
                                  ).translate(widget.title),
                                  SizedBox(
                                    height: Helper().getHeight(9),
                                  ),
                                  Text(
                                    widget.body,
                                    style: TextStyle(
                                      // color: const Color(0xFF0E0B06),
                                      color: AppTheme.blackColor,
                                      fontSize: Helper().getFontSize(35),
                                      // fontSize: 36,
                                      fontFamily: 'Codec Pro',
                                      fontWeight: FontWeight.w300,
                                      height: 1.21,
                                    ),
                                  ).translate(widget.body)
                                ],
                              ),
                            ),
                            SizedBox(
                              height: Helper().getHeight(38),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: Helper().getWidth(15)),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                spacing: 15,
                                children: [
                                  Flexible(child: _currentIndicator()),
                                  SvgPicture.asset(
                                    "assets/icons/notification.svg",
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: Helper().getHeight(38),
                            ),
                            InkWell(
                              onTap: () {
                                NavigationService.instance
                                    .navigateTo(Routes.login);
                              },
                              child: Container(
                                width: Helper().getWidth(358),
                                height: Helper().getHeight(48),
                                decoration: BoxDecoration(
                                  color: AppTheme.darkGreenColor,
                                  // borderRadius: BorderRadius.circular(30),
                                ),
                                child: Center(
                                  child: Text(
                                    "Let's Go",
                                    style: TextStyle(
                                      color: const Color(0xFFF6F0E7),
                                      fontSize: Helper().getFontSize(29),
                                      fontWeight: FontWeight.w600,
                                      fontFamily: AppTheme.fontName,
                                    ),
                                  ).translate("Let's Go"),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: Helper().getHeight(10),
                            ),
                            SizedBox(
                              width: Helper().getWidth(358),
                              child: Divider(
                                thickness: 1.2,
                                color: AppTheme.blackColor,
                              ),
                            ),
                            // SizedBox(
                            //   height: Helper().getHeight(8),
                            // ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: Helper().getWidth(15),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      launchUrlString(UrlConstants.tAndC);
                                    },
                                    child: Text(
                                      "T & C",
                                      style: AppTheme.caption2.copyWith(
                                        color: AppTheme.blackColor,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                  // InkWell(
                                  //   onTap: () {
                                  //     launchUrlString(UrlConstants.survey);
                                  //   },
                                  //   child: Text(
                                  //     "Take a Survey",
                                  //     style: AppTheme.caption2
                                  //         .copyWith(color: AppTheme.blackColor),
                                  //   ).translate('Take a Survey'),
                                  // ),
                                  InkWell(
                                    onTap: () {
                                      launchUrlString(UrlConstants.help);
                                    },
                                    child: Text(
                                      "Help",
                                      style: AppTheme.caption2.copyWith(
                                        color: AppTheme.blackColor,
                                        fontSize: 15,
                                      ),
                                    ).translate('Help'),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: Helper().getHeight(500),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withAlpha(100),
                  Colors.transparent,
                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(bottom: Helper().getHeight(20), top: 40),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Image.asset(
                    "assets/icons/logo_green.png",
                    width: Helper().getFontSize(346),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _currentIndicator() {
    return Row(
      spacing: 10,
      children: List.generate(3, (index) {
        bool isActive = index + 1 == widget.index;
        double size = 13;
        return Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: isActive ? AppTheme.darkGreenColor : const Color(0x7F264740),
            shape: BoxShape.circle,
          ),
        );
      }),
    );
  }
}
