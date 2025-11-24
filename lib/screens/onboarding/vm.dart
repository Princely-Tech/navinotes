import 'package:navinotes/packages.dart';

class OnBoardingVM extends ChangeNotifier {
  final PageController pageController = PageController();

  void initialize() {
    animateToNext();
  }

  void animateToNext() {
    Future.delayed(const Duration(seconds: 5), () {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  void animateBack() {
    Future.delayed(const Duration(seconds: 5), () {
      pageController.animateToPage(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }
}
