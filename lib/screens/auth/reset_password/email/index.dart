import 'package:navinotes/packages.dart';
import 'vm.dart';

class ForgotPasswordScreen extends StatelessWidget {
  ForgotPasswordScreen({super.key});
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return ScaffoldFrame(
      backgroundColor: Apptheme.white,
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
                  return Column(crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppHeaderOne(
                        title: 'Forgot Password',
                        isBackButton: true,
                      ),
                      ResponsivePadding(
                        mobile: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 20,
                        ),
                        laptop: const EdgeInsets.all(20),
                        child: Form(
                          key: formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: 20,
                            children: [
                              Text(
                                'Enter your email address and we will send you a code to reset your password.',
                                style: Apptheme.text.copyWith(
                                  color: Apptheme.graphite,
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
                                    ErrorDisplayService.showFormInValidError(
                                      context,
                                    );
                                  }
                                },
                              ),
                            ],
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
