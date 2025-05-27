import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:navinotes/screens/auth/login.dart';
import 'package:navinotes/screens/auth/sign_up.dart';
import 'package:navinotes/screens/auth/vm.dart';
import 'package:navinotes/settings/app_strings.dart';
import 'package:navinotes/settings/apptheme.dart';
import 'package:navinotes/settings/images.dart';
import 'package:navinotes/settings/ui_helpers.dart';
import 'package:navinotes/widgets/components.dart';
import 'package:navinotes/widgets/frames.dart';
import 'package:provider/provider.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldFrame(
      body: ChangeNotifierProvider(
        create: (context) => AuthVM(),
        child: Consumer<AuthVM>(
          builder: (context, vm, child) {
            return Stack(children: [_background(context), _main(context, vm)]);
          },
        ),
      ),
    );
  }

  Widget _main(BuildContext context, AuthVM vm) {
    double maxWidth = 500;
    double deviceWidth = screenWidth(context);
    double minWidth = deviceWidth < maxWidth ? deviceWidth : maxWidth;

    List<BoxShadow> boxShadows = [
      BoxShadow(
        color: Apptheme.black.withAlpha(0x3F),
        blurRadius: 50,
        offset: Offset(0, 25),
        spreadRadius: 5,
      ),
    ];

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        spacing: 20,
        children: [
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxHeight: screenHeight(context) - 100,
                maxWidth: maxWidth,
                minWidth: minWidth,
              ),
              child: Center(
                child: Container(
                  padding: EdgeInsets.all(40),
                  decoration: ShapeDecoration(
                    color: Apptheme.white.withAlpha(20),
                    shape: RoundedRectangleBorder(
                      side: vm.borderSide,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    shadows: boxShadows,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      spacing: 35,
                      children: [
                        Column(
                          spacing: 20,
                          children: [
                            SVGImagePlaceHolder(
                              imagePath: Images.logoRounded,
                              size: 64,
                            ),
                            Text(
                              AppStrings.appName,
                              textAlign: TextAlign.center,
                              style: Apptheme.text.copyWith(
                                color: Apptheme.white,
                                fontSize: 36,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              'Connect Your Thoughts, Expand Your Mind',
                              textAlign: TextAlign.center,
                              style: Apptheme.text.copyWith(
                                color: Apptheme.mintyAqua,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                        if (vm.authType == AuthType.login)
                          LoginForm()
                        else
                          SignUpForm(),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          spacing: 20,
                          children: [
                            _socialBtn(Images.google, vm),
                            _socialBtn(Images.apple, vm),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          Row(
            spacing: 20,
            mainAxisAlignment: MainAxisAlignment.center,
            children:
                authFooterLinks
                    .map(
                      (str) => Text(
                        str,
                        style: Apptheme.text.copyWith(
                          color: Apptheme.pastelBlue,
                        ),
                      ),
                    )
                    .toList(),
          ),
        ],
      ),
    );
  }

  Widget _socialBtn(String assetName, AuthVM vm) {
    return InkWell(
      onTap: () {},
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: vm.inputFillColor,
        ),
        child: Center(
          child: SvgPicture.asset(assetName, height: 20, width: 20),
        ),
      ),
    );
  }

  Widget _background(BuildContext context) {
    double factor = 0.85;
    return Container(
      width: screenWidth(context),
      height: screenHeight(context),
      decoration: ShapeDecoration(
        gradient: LinearGradient(
          begin: Alignment(0.00, 0.50),
          end: Alignment(1.00, 0.50),
          colors: [Apptheme.royalBlue, Apptheme.persianBlue, Apptheme.deepTeel],
        ),
        shape: RoundedRectangleBorder(),
      ),
      child: FractionallySizedBox(
        widthFactor: factor,
        heightFactor: factor,
        child: Opacity(
          opacity: 0.1,
          child: Image.asset(Images.brain, fit: BoxFit.cover),
        ),
      ),
    );
  }
}
