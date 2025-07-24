import 'package:navinotes/packages.dart';
import 'vm.dart';

class ForgotPasswordScreen extends StatelessWidget {
  ForgotPasswordScreen({super.key});
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return ScaffoldFrame(
      body: ApiServiceComponent(
        child: Consumer<ApiServiceProvider>(
          builder: (_, apiServiceProvider, _) {
            return ChangeNotifierProvider(
              create:
                  (_) => ChangePasswordVm(
                    apiServiceProvider: apiServiceProvider,
                    context: context,
                  ),
              child: Consumer<ChangePasswordVm>(
                builder: (_, vm, _) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppHeaderOne(
                        title: 'Forgot Password',
                        isBackButton: true,
                      ),
                      Expanded(
                        child: ScrollableController(
                          mobilePadding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 20,
                          ),
                          laptopPadding: const EdgeInsets.all(20),
                          child: CustomCard(
                            child: Form(
                              key: formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                spacing: 20,
                                children: [
                                  WidthLimiter(
                                    mobile: 500,
                                    child: Text(
                                      'Enter your email address and we will send you a code to reset your password.',
                                      style: AppTheme.text.copyWith(
                                        color: AppTheme.stormGray,
                                        fontSize: 16.0,
                                      ),
                                    ),
                                  ),
                                  CustomInputField(
                                    controller: vm.emailController,
                                    hintText: 'your.email@school.edu',
                                    label: 'Email',
                                    keyboardType: TextInputType.emailAddress,
                                    validator: emailValidator,
                                  ),
                                  AppButton(
                                    text: 'Continue',
                                    loading: vm.isLoading,
                                    onTap: () {
                                      if (formKey.currentState!.validate()) {
                                        vm.submit();
                                      } else {
                                        MessageDisplayService.showFormInValidError(
                                          context,
                                        );
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
