import 'package:navinotes/packages.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.8, curve: Curves.easeInOut),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 1.0, curve: Curves.easeInOutBack),
      ),
    );

    _controller.forward();

    // Navigate after animation completes
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _nextHandler();
      }
    });
  }

  Future<void> _navigateToNextScreen() async {
    final sessionManager = context.read<SessionManager>();
    final isLoggedIn = sessionManager.isLoggedIn();
    final hasSeenOnboarding = sessionManager.hasSeenOnboarding();

    // Small delay to ensure smooth transition
    await Future.delayed(const Duration(milliseconds: 500));

    if (mounted) {
      String route;
      if (isLoggedIn) {
        route = Routes.dashboard;
      } else if (hasSeenOnboarding) {
        route = Routes.auth;
      } else {
        route = Routes.onboarding;
      }

      Navigator.of(context).pushReplacementNamed(route);
    }
  }

  Future<void> _nextHandler() async {
    // Ensure session is loaded before checking login status
    await context.read<SessionManager>().init();
    if (mounted) {
      //TODO uncomment
      return _navigateToNextScreen();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.white,
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Opacity(
              opacity: _fadeAnimation.value,
              child: Transform.scale(
                scale: _scaleAnimation.value,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Replace with your app logo
                    Image.asset(
                      'assets/images/logo.png', // Update with your logo path
                      height: 120,
                      width: 120,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'NaviNotes',
                      style: AppTheme.text.copyWith(
                        fontSize: 32.0,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Your intelligent study companion',
                      style: AppTheme.text.copyWith(
                        fontSize: 16.0,
                        color: AppTheme.stormGray,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
