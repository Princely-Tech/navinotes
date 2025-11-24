import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_translator/google_translator.dart';
import 'package:malariax/services/navigation_service.dart';
import 'package:malariax/services/routes/routes.dart';
import 'package:malariax/settings/app_theme.dart';

class PermissionScreen extends StatefulWidget {
  const PermissionScreen({super.key});

  @override
  State<PermissionScreen> createState() => _PermissionScreenState();
}

class _PermissionScreenState extends State<PermissionScreen> {
  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
    super.initState();
    Future.delayed(const Duration(seconds: 3), () async {
      //Navigator.pushReplacementNamed(context, Routes.foundationSplash);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
        width: MediaQuery.of(context).size.width,
        color: AppTheme.blackColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 46, vertical: 88),
                child: Column(
                  children: [
                    SizedBox(
                      width: 175,
                      child: Center(
                        child: SvgPicture.asset('assets/icons/logo.svg'),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      decoration: BoxDecoration(
                        color: AppTheme.whiteColor,
                        borderRadius: BorderRadius.circular(38),
                      ),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Text(
                                "Allow Malaria X to access this device’s location?",
                                style: AppTheme.body
                                    .copyWith(color: AppTheme.redColor),
                                textAlign: TextAlign.center,
                              ).translate(
                                  "Allow Malaria X to access this device’s location?"),
                            ),
                            const SizedBox(height: 40),
                            consentRow(ConsentType.whileUsing),
                            Container(
                                color:
                                    HexColor('#D9D9D9').withOpacity(40 / 100),
                                height: 6),
                            consentRow(ConsentType.onlyThisTime),
                            Container(
                                color:
                                    HexColor('#D9D9D9').withOpacity(40 / 100),
                                height: 6),
                            consentRow(ConsentType.deny),
                          ]),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget consentRow(ConsentType type) {
    var text = "Deny";
    if (type == ConsentType.whileUsing) {
      text = "While using the app";
    } else if (type == ConsentType.onlyThisTime) {
      text = "Only this time";
    }
    return InkWell(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(8),
        color: HexColor('#D9D9D9').withOpacity(20 / 100),
        child: Text(
          text,
          style: AppTheme.body,
          textAlign: TextAlign.center,
        ).translate(text),
      ),
      onTap: () {
        NavigationService.instance.navigateTo(Routes.peopleSplash);
      },
    );
  }
}

enum ConsentType { whileUsing, onlyThisTime, deny }
