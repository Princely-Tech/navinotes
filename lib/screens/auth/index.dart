import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:navinotes/packages.dart';
import 'package:navinotes/screens/auth/login.dart';
import 'package:navinotes/screens/auth/sign_up.dart';
import 'package:navinotes/screens/auth/vm.dart';
import 'package:navinotes/settings/app_strings.dart';
import 'package:navinotes/settings/apptheme.dart';
import 'package:navinotes/settings/images.dart';
import 'package:navinotes/settings/ui_helpers.dart';
import 'package:navinotes/widgets/components.dart';
import 'package:navinotes/widgets/frames.dart';
import 'package:navinotes/widgets/responsive_widgets.dart';
import 'package:provider/provider.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldFrame(
      backgroundColor: Apptheme.white,
      body: ChangeNotifierProvider(
        create: (context) => AuthVM(),
        child: Consumer<AuthVM>(
          builder: (context, vm, child) {
            return _main(vm);
          },
        ),
      ),
    );
  }

  Widget _main(AuthVM vm) {
    return Builder(
      builder: (context) {
        return SizedBox(
          width: screenWidth(context),
          height: screenHeight(context),
          child: ResponsivePadding(
            mobile: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            laptop: const EdgeInsets.all(20),
            child: Center(
              child: WidthLimiter(
                mobile: 500,
                child: SingleChildScrollView(
                  child: Column(
                    spacing: 50,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        spacing: 30,
                        children: [
                          _header(),
                          _authCard(vm), _authTypeSwitch(vm),
                          //
                        ],
                      ),
                      _footerLinks(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _authTypeSwitch(AuthVM vm) {
    bool isLogin = vm.authType == AuthType.login;
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text:
                isLogin
                    ? 'Don\'t have an account? '
                    : 'Already have an account? ',
            style: TextStyle(
              color: const Color(0xFF4B5563),
              fontSize: 16,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
              height: 1,
            ),
          ),
          TextSpan(
            recognizer: TapGestureRecognizer()..onTap = vm.toggleAuthType,
            text: isLogin ? 'Create Account' : 'Login',
            style: TextStyle(
              color: const Color(0xFF00555A),
              fontSize: 16,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
              height: 1,
            ),
          ),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _authCard(AuthVM vm) {
    return Container(
      width: double.infinity,
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: const Color(0xFFE5E7EB)),
          borderRadius: BorderRadius.circular(16),
        ),
        shadows: [
          BoxShadow(
            color: Apptheme.black.withAlpha(0x19),
            blurRadius: 6,
            offset: Offset(0, 4),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Apptheme.black.withAlpha(0x19),
            blurRadius: 4,
            offset: Offset(0, 2),
            spreadRadius: 0,
          ),
        ],
      ),
      child: ResponsivePadding(
        mobile: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        laptop: const EdgeInsets.all(30),
        child: Column(
          spacing: 25,
          children: [
            Column(
              spacing: 10,
              children: [
                Text(
                  'Welcome back to your study space',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: const Color(0xFF1F2937),
                    fontSize: 24,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    height: 1,
                  ),
                ),
                Text(
                  'Pick up right where you left off',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: const Color(0xFF4B5563),
                    fontSize: 16,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                    height: 1,
                  ),
                ),
              ],
            ),
            if (vm.authType == AuthType.login) LoginForm() else SignUpForm(),
            _continueWith(),
            Row(
              spacing: 12,
              children: [_socialBtn(Images.google), _socialBtn(Images.apple)],
            ),
          ],
        ),
      ),
    );
  }

  Widget _socialBtn(String assetName) {
    String name = 'Google';
    switch (assetName) {
      case Images.apple:
        name = 'Apple';
        break;
    }
    return AppButton.secondary(
      wrapWithFlexible: true,
      color: Apptheme.lightGray,
      onTap: () {},
      text: name,
      prefix: SVGImagePlaceHolder(
        imagePath: assetName,
        size: 20,
        color: Apptheme.darkSlateGray,
      ),
      style: TextStyle(
        color: const Color(0xFF374151),
        fontSize: 14,
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _continueWith() {
    return Row(
      spacing: 5,
      children: [
        _divider(),
        Text(
          'or continue with',
          style: TextStyle(
            color: const Color(0xFF6B7280),
            fontSize: 14,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w400,
          ),
        ),
        _divider(),
      ],
    );
  }

  Widget _divider() {
    return Expanded(
      child: Divider(color: Apptheme.lightGray, thickness: 1, height: 1),
    );
  }

  Widget _header() {
    return Column(
      spacing: 10,
      children: [
        SVGImagePlaceHolder(imagePath: Images.logo, size: 80),
        Text(
          'NaviNotes',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: const Color(0xFF00555A),
            fontSize: 30,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w700,
            height: 1,
          ),
        ),
        Text(
          'Your supportive study companion',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: const Color(0xFF4B5563),
            fontSize: 16,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w400,
            height: 1,
          ),
        ),

        //
      ],
    );
  }

  Widget _footerLinks() {
    return ScrollableRow(
      children:
          authFooterLinks
              .map(
                (str) => Text(
                  str,
                  style: Apptheme.text.copyWith(color: Apptheme.vividRose),
                ),
              )
              .toList(),
    );
  }
}
