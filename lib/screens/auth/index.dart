import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:navinotes/screens/auth/vm.dart';
import 'package:navinotes/settings/app_strings.dart';
import 'package:navinotes/settings/apptheme.dart';
import 'package:navinotes/settings/images.dart';
import 'package:navinotes/settings/ui_helpers.dart';
import 'package:navinotes/widgets/buttons.dart';
import 'package:navinotes/widgets/components.dart';
import 'package:navinotes/widgets/frames.dart';
import 'package:navinotes/widgets/inputs.dart';
import 'package:provider/provider.dart';

Color inputFillColor = Apptheme.white.withAlpha(30);

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
    TextStyle inputStyle = Apptheme.text.copyWith(
      color: Apptheme.slateGray,
      fontSize: 16,
    );

    TextStyle btnTextStyle = Apptheme.text.copyWith(
      color: Apptheme.white,
      fontSize: 18,
      fontWeight: FontWeight.w700,
    );

    List<BoxShadow> boxShadows = [
      BoxShadow(
        color: Apptheme.black.withAlpha(0x3F),
        blurRadius: 50,
        offset: Offset(0, 25),
        spreadRadius: 5,
      ),
    ];
    BorderSide borderSide = BorderSide(color: Apptheme.white.withAlpha(30));
    OutlineInputBorder inputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: borderSide,
    );
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
                      side: borderSide,
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

                        Form(
                          child: Column(
                            spacing: 25,
                            children: [
                              Column(
                                spacing: 15,
                                children: [
                                  CustomInputField(
                                    hintText: 'Email or Username',
                                    keyboardType: TextInputType.emailAddress,
                                    fillColor: inputFillColor,
                                    style: inputStyle.copyWith(
                                      color: Apptheme.aquaGreen,
                                    ),
                                    hintStyle: inputStyle,
                                    border: inputBorder,
                                  ),
                                  CustomInputField(
                                    hintText: 'Password',
                                    keyboardType: TextInputType.visiblePassword,
                                    fillColor: inputFillColor,
                                    style: inputStyle.copyWith(
                                      color: Apptheme.aquaGreen,
                                    ),
                                    hintStyle: inputStyle,
                                    border: inputBorder,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Flexible(
                                        child: Text(
                                          'Forgot Password?',
                                          style: Apptheme.text.copyWith(
                                            color: Apptheme.mintGreen,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),

                              Column(
                                spacing: 15,
                                children: [
                                  AppButton(
                                    onTap: vm.login,
                                    text: 'Login',
                                    gradient: LinearGradient(
                                      begin: Alignment(0.00, 0.50),
                                      end: Alignment(1.00, 0.50),
                                      colors: [
                                        Apptheme.vividBlue,
                                        Apptheme.aquaGreen,
                                      ],
                                    ),
                                    style: btnTextStyle,
                                  ),
                                  AppButton(
                                    onTap: vm.login,
                                    text: 'Sign Up',
                                    color: inputFillColor,
                                    style: btnTextStyle,
                                  ),
                                  Text(
                                    'Start Your 7 Day Free Trial',
                                    textAlign: TextAlign.center,
                                    style: Apptheme.text.copyWith(
                                      color: Apptheme.mintGreen,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          spacing: 20,
                          children: [
                            _socialBtn(Images.google),
                            _socialBtn(Images.apple),
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

  Widget _socialBtn(String assetName) {
    return SizedBox(
      width: 50,
      height: 50,
      child: AppButton(
        color: inputFillColor,
        onTap: () {},
        shape: CircleBorder(),
        child: SvgPicture.asset(assetName, height: 20, width: 20),
      ),
    );
  }

  Widget _background(BuildContext context) {
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
        widthFactor: 0.85,
        heightFactor: 0.85,
        child: Opacity(
          opacity: 0.1,
          child: Image.asset(Images.brain, fit: BoxFit.cover),
        ),
      ),
    );
  }
}
