import 'package:navinotes/packages.dart';
import 'package:navinotes/screens/onboarding/frame.dart';
import 'vm.dart';

List<Widget> onboardingFrames = [
  OnBoardingFrame(
    title: 'Together for a Malaria-Free Africa.',
    body:
        'MalariaX connects communities, health workers, and program managers in one platform.',
    image: Images.groupLaugh,
    index: 1,
  ),
  OnBoardingFrame(
    title: 'Faster Reporting. Stronger Protection.',
    body:
        'Track cases, report symptoms, and stay informed with real-time updates.',
    image: Images.groupLaugh,
    index: 2,
  ),
  OnBoardingFrame(
    title: 'Your Role Matters. Be Part of the Solution.',
    body:
        'Engage, volunteer, and support vaccination and prevention efforts easily.',
    image: Images.groupLaugh,
    index: 3,
  ),
];

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) {
        final vm = OnBoardingVM();
        vm.initialize();
        return vm;
      },
      child: Consumer<OnBoardingVM>(
        builder: (_, vm, _) {
          return PageView(
            controller: vm.pageController,
            onPageChanged: (index) {
              if (index == onboardingFrames.length - 1) {
                vm.animateBack();
              } else {
                vm.animateToNext();
              }
            },
            children: onboardingFrames,
          );
        },
      ),
    );
  }
}
