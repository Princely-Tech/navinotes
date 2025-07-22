import 'package:navinotes/packages.dart';

class CustomProviders extends StatelessWidget {
  const CustomProviders({
    super.key,
    required this.child,
    required this.sessionManager,
  });

  final Widget child;
  final SessionManager sessionManager;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create:
              (_) => LayoutProviderVm(
                deviceType: getDeviceType(screenWidth(context)),
                context: context,
              ),
        ),
        ChangeNotifierProvider(create: (_) => sessionManager),
        ChangeNotifierProvider(create: (_) => PomodoroTimer()),
      ],
      child: Builder(
        builder: (context) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.read<LayoutProviderVm>().updateDeviceType();
          });
          return child;
        },
      ),
    );
  }
}


class ApiServiceComponent extends StatelessWidget {
  const ApiServiceComponent({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProxyProvider<SessionManager, ApiServiceProvider>(
      create:
          (context) => ApiServiceProvider(
            sessionManager: context.read<SessionManager>(),
            // sessionManager: SessionManager(),
            context: context,
          ),
      update:
          (context, sessionManager, __) => ApiServiceProvider(
            sessionManager: sessionManager,
            context: context,
          ),
      child: child,
    );
  }
}
