import 'package:navinotes/packages.dart';
import 'vm.dart';

class ResetPasswordVerifyScreen extends StatelessWidget {
  const ResetPasswordVerifyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldFrame(
      backgroundColor: AppTheme.white,
      body: ApiServiceComponent(
        child: Consumer<ApiServiceProvider>(
          builder: (_, apiServiceProvider, _) {
            return ChangeNotifierProvider(
              create:
                  (context) => VerifyVM(
                    context: context,
                    apiServiceProvider: apiServiceProvider,
                  ),
              child: Consumer<VerifyVM>(
                builder: (_, vm, _) {
                  return AbsorbPointer(
                    absorbing: vm.isLoading,
                    child: AuthFrame(
                      child: Column(
                        spacing: 30,
                        children: [AuthHeader(), _authCard(vm)],
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _authCard(VerifyVM vm) {
    return Consumer<ApiServiceProvider>(
      builder: (_, apiServiceProvider, _) {
        return ShadowCard(
          child: Column(
            spacing: 25,
            children: [
              HeaderSectionTwo(
                title: 'Verify your email',
                body:
                    'Enter the email sent to ${apiServiceProvider.sessionManager.getEmail()}',
              ),
              VerifyFormComponent(
                isLoading: vm.isLoading,
                submitHandler: (input) => vm.submitForm(input),
                resendOtpHandler: vm.resendOtp,
              ),
            ],
          ),
        );
      },
    );
  }
}
