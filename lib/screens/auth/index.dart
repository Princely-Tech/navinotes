import 'package:navinotes/packages.dart';
import 'package:navinotes/screens/auth/login.dart';
import 'package:navinotes/screens/auth/sign_up.dart';
import 'package:navinotes/screens/auth/vm.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldFrame(
      backgroundColor: AppTheme.white,
      body: ApiServiceComponent(
        child: Consumer<ApiServiceProvider>(
          builder: (_, apiServiceProvider, _) {
            return ChangeNotifierProvider(
              create:
                  (context) => AuthVM(
                    context: context,
                    apiServiceProvider: apiServiceProvider,
                  ),
              child: Consumer<AuthVM>(
                builder: (_, vm, _) {
                  return _main(vm);
                },
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _main(AuthVM vm) {
    return Builder(
      builder: (context) {
        return AbsorbPointer(
          absorbing: vm.isLoading || isNotNull(vm.loadingAuthType),
          child: AuthFrame(
            child: Column(
              spacing: 50,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  spacing: 30,
                  children: [
                    AuthHeader(),
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
          style: AppTheme.text.copyWith(color: AppTheme.black, fontSize: 12.0),
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
                style: AppTheme.text.copyWith(
                  color: AppTheme.white,
                  fontSize: 20.0,
                  fontFamily: AppTheme.fontPoppins,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                'Experience everything NaviNotes offers - 7 days free, no commitment',
                textAlign: TextAlign.center,
                style: AppTheme.text.copyWith(
                  color: AppTheme.white.withAlpha(229),
                  fontSize: 16.0,
                  fontFamily: AppTheme.fontPoppins,
                ),
              ),

              AppButton(
                mainAxisSize: MainAxisSize.min,
                text: 'Start Free Trial',
                onTap: () {},
                color: AppTheme.white,
                style: AppTheme.text.copyWith(
                  color: AppTheme.amber,
                  fontSize: 16.0,
                  fontFamily: AppTheme.fontPoppins,
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
            style: AppTheme.text.copyWith(
              color: AppTheme.stormGray,
              fontSize: 16.0,
              fontFamily: AppTheme.fontPoppins,
            ),
          ),
          TextSpan(
            recognizer: TapGestureRecognizer()..onTap = vm.toggleAuthType,
            text: isLogin ? 'Create Account' : 'Login',
            style: AppTheme.text.copyWith(
              color: AppTheme.vividRose,
              fontSize: 16.0,
              fontFamily: AppTheme.fontPoppins,
              fontWeight: getFontWeight(500),
            ),
          ),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _authCard(AuthVM vm) {
    return ShadowCard(
      child: Column(
        spacing: 25,
        children: [
          HeaderSectionTwo(
            title: 'Welcome back to your study space',
            body: 'Pick up right where you left off',
          ),
          if (vm.authType == AuthType.login) LoginForm() else SignUpForm(),
          _continueWith(),
          Row(
            spacing: 12,
            children: [
              _socialBtn(Images.google, vm),
              _socialBtn(Images.apple, vm),
            ],
          ),
        ],
      ),
    );
  }

  Widget _socialBtn(String assetName, AuthVM vm) {
    String name = 'Google';
    AuthSocialType type = AuthSocialType.google;
    switch (assetName) {
      case Images.apple:
        name = 'Apple';
        type = AuthSocialType.apple;
        break;
    }
    return AppButton.secondary(
      wrapWithFlexible: true,
      color: AppTheme.lightGray,
      onTap: () => vm.socialLogin(type),
      text: name,
      loading: vm.loadingAuthType == type,
      prefix: SVGImagePlaceHolder(
        imagePath: assetName,
        size: 20,
        color: AppTheme.darkSlateGray,
      ),
      style: AppTheme.text.copyWith(
        color: AppTheme.darkSlateGray,
        fontFamily: AppTheme.fontPoppins,
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
          style: AppTheme.text.copyWith(
            color: AppTheme.steelMist,
            fontFamily: AppTheme.fontPoppins,
          ),
        ),
        _divider(),
      ],
    );
  }

  Widget _divider() {
    return Expanded(
      child: Divider(color: AppTheme.lightGray, thickness: 1, height: 1),
    );
  }

  Widget _footerLinks() {
    return ScrollableRow(
      children:
          authFooterLinks
              .map(
                (str) => Text(
                  str,
                  style: AppTheme.text.copyWith(color: AppTheme.vividRose),
                ),
              )
              .toList(),
    );
  }
}
