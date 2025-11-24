import 'package:navinotes/packages.dart';

class OnBoardingVM extends ChangeNotifier {
  final PageController _pageController = PageController();
  void animateToNext() {
    Future.delayed(const Duration(seconds: 5), () {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  void animateBack() {
    Future.delayed(const Duration(seconds: 5), () {
      _pageController.animateToPage(
        2,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
