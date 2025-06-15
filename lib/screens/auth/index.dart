import 'package:flutter/gestures.dart';
import 'package:navinotes/packages.dart';
import 'package:navinotes/screens/auth/login.dart';
import 'package:navinotes/screens/auth/sign_up.dart';
import 'package:navinotes/screens/auth/vm.dart';

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
                          _authCard(vm),
                          _freeTrial(),
                          _authTypeSwitch(vm),
                          _testimonial(),
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

  Widget _testimonial() {
    return Column(
      spacing: 15,
      children: [
        ImagePlaceHolder(imagePath: Images.testimonial),
        Text(
          textAlign: TextAlign.center,
          '"NaviNotes transformed how I study. My grades improved within weeks!"',
          style: Apptheme.text.copyWith(color: Apptheme.black, fontSize: 12.0),
        ),
      ],
    );
  }

  Widget _freeTrial() {
    return Stack(
      children: [
        Positioned(
          top: 0,
          right: 0,
          bottom: 0,
          left: 0,
          child: SvgPicture.asset(Images.authCardBg, fit: BoxFit.fill),
        ),
        ResponsivePadding(
          mobile: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          laptop: const EdgeInsets.all(30),
          child: Column(
            spacing: 15,
            children: [
              Text(
                'New to NaviNotes?',
                textAlign: TextAlign.center,
                style: Apptheme.text.copyWith(
                  color: Apptheme.white,
                  fontSize: 20.0,
                  fontFamily: Apptheme.fontPoppins,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                'Experience everything NaviNotes offers - 7 days free, no commitment',
                textAlign: TextAlign.center,
                style: Apptheme.text.copyWith(
                  color: Apptheme.white.withAlpha(229),
                  fontSize: 16.0,
                  fontFamily: Apptheme.fontPoppins,
                ),
              ),

              AppButton(
                mainAxisSize: MainAxisSize.min,
                text: 'Start Free Trial',
                onTap: () {},
                color: Apptheme.white,
                style: Apptheme.text.copyWith(
                  color: Apptheme.amber,
                  fontSize: 16.0,
                  fontFamily: Apptheme.fontPoppins,
                  fontWeight: getFontWeight(600),
                ),
              ),
            ],
          ),
        ),
      ],
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
            style: Apptheme.text.copyWith(
              color: Apptheme.stormGray,
              fontSize: 16.0,
              fontFamily: Apptheme.fontPoppins,
            ),
          ),
          TextSpan(
            recognizer: TapGestureRecognizer()..onTap = vm.toggleAuthType,
            text: isLogin ? 'Create Account' : 'Login',
            style: Apptheme.text.copyWith(
              color: Apptheme.vividRose,
              fontSize: 16.0,
              fontFamily: Apptheme.fontPoppins,
              fontWeight: getFontWeight(500),
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
          side: BorderSide(color: Apptheme.lightGray),
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
                  style: Apptheme.text.copyWith(
                    fontSize: 24.0,
                    fontFamily: Apptheme.fontPoppins,
                    fontWeight: getFontWeight(600),
                  ),
                ),
                Text(
                  'Pick up right where you left off',
                  textAlign: TextAlign.center,
                  style: Apptheme.text.copyWith(
                    color: Apptheme.stormGray,
                    fontSize: 16.0,
                    fontFamily: Apptheme.fontPoppins,
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
      style: Apptheme.text.copyWith(
        color: Apptheme.darkSlateGray,
        fontFamily: Apptheme.fontPoppins,
        fontWeight: getFontWeight(500),
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
          style: Apptheme.text.copyWith(
            color: Apptheme.steelMist,
            fontFamily: Apptheme.fontPoppins,
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
          style: Apptheme.text.copyWith(
            color: Apptheme.vividRose,
            fontSize: 30.0,
            fontFamily: Apptheme.fontPoppins,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          'Your supportive study companion',
          textAlign: TextAlign.center,
          style: Apptheme.text.copyWith(
            color: Apptheme.stormGray,
            fontSize: 16.0,
            fontFamily: Apptheme.fontPoppins,
          ),
        ),
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
