import 'package:navinotes/packages.dart';
import 'vm.dart';

class ChangePasswordScreen extends StatelessWidget {
  ChangePasswordScreen({super.key});
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return ScaffoldFrame(
      backgroundColor: AppTheme.white,
      body: ApiServiceComponent(
        child: Consumer<ApiServiceProvider>(
          builder: (_, apiServiceProvider, _) {
            return ChangeNotifierProvider(
              create:
                  (_) => ChangePasswordVm(
                    context: context,
                    apiServiceProvider: apiServiceProvider,
                  ),
              child: Consumer<ChangePasswordVm>(
                builder: (_, vm, _) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppHeaderOne(title: 'Change Password'),
                      ResponsivePadding(
                        mobile: const EdgeInsets.all(20),
                        child: Form(
                          key: formKey,
                          child: Column(
                            spacing: 24,
                            children: [
                              CustomInputField(
                                hintText: 'New Password',
                                label: 'New Password',
                                controller: vm.passwordController,
                                keyboardType: TextInputType.visiblePassword,
                                validator: passwordValidator,
                              ),
                              CustomInputField(
                                controller: vm.confirmPasswordController,
                                validator:
                                    (String? input) => confirmPasswordValidator(
                                      input,
                                      vm.passwordController.text,
                                    ),
                                label: 'Confirm Password',
                                hintText: 'Confirm Password',
                                keyboardType: TextInputType.visiblePassword,
                              ),
                              Column(
                                spacing: 10,
                                children: [
                                  AppButton(
                                    loading: vm.isLoading,
                                    text: 'Change Password',
                                    onTap: () {
                                      if (formKey.currentState!.validate()) {
                                        vm.submitForm();
                                      } else {
                                        MessageDisplayService.showFormInValidError(
                                          context,
                                        );
                                      }
                                    },
                                  ),
                                  AppButton.text(
                                    mainAxisSize: MainAxisSize.min,
                                    onTap:
                                        () =>
                                            NavigationHelper.push(Routes.auth),
                                    text: 'Back to Login',
                                  ),
                                ],
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
