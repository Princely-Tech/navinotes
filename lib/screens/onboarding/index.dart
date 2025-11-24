import 'package:navinotes/packages.dart';
import 'vm.dart';

class OnBoarding extends StatelessWidget {
  const OnBoarding({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => OnBoardingVM(),
      child: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          if (index == 4) {
            animateBack();
          } else if (index >= 2) {
            animateToNext();
          }
        },
        children: const [
          FoundationSplashScreen(),
          SponsorSplashScreen(),
          PeopleSplashScreen(
            title: 'Together for a Malaria-Free Africa.',
            body:
                'MalariaX connects communities, health workers, and program managers in one platform.',
            image: 'assets/images/onboarding/family.png',
            index: 1,
          ),
          PeopleSplashScreen(
            title: 'Faster Reporting. Stronger Protection.',
            body:
                'Track cases, report symptoms, and stay informed with real-time updates.',
            image: 'assets/images/onboarding/baby.png',
            index: 2,
          ),
          PeopleSplashScreen(
            title: 'Your Role Matters. Be Part of the Solution.',
            body:
                'Engage, volunteer, and support vaccination and prevention efforts easily.',
            image: 'assets/images/onboarding/woman.png',
            index: 3,
          ),
        ],
      ),
    );
  }
}
