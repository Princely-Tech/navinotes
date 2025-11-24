import 'package:navinotes/packages.dart';
import 'package:navinotes/screens/onboarding/frame.dart';
import 'vm.dart';

List<Widget> onboardingFrames = [
  OnBoardingFrame(
    title: 'Collaborate & Learn Together',
    body: 'Connect with classmates, share notes, and ace your exams together.',
    image: Images.groupLaugh,
    index: 1,
  ),
  OnBoardingFrame(
    title: 'Master Your Studies',
    body:
        'Organize your notes, track your progress, and stay focused on your goals.',
    image: Images.studyAlone,
    index: 2,
  ),
  OnBoardingFrame(
    title: 'Achieve Academic Excellence',
    body: 'Access resources, join study groups, and reach your full potential.',
    image: Images.studyGroup,
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
