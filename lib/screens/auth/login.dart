import 'package:navinotes/packages.dart';
import 'vm.dart';

class LoginForm extends StatelessWidget {
  LoginForm({super.key});
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthVM>(
      builder: (_, vm, _) {
        return Form(
          key: formKey,
          child: Column(
            spacing: 20,
            children: [
              CustomInputField(
                hintText: 'your.email@school.edu',
                label: 'Email',
                keyboardType: TextInputType.emailAddress,
                fillColor: vm.inputFillColor,
                validator: emailValidator,
                controller: vm.emailController,
              ),
              CustomInputField(
                hintText: 'Password',
                label: 'Password',
                controller: vm.passwordController,
                labelRight: AppButton.text(
                  onTap: () {},
                  text: 'Forgot Password?',
                ),
                keyboardType: TextInputType.visiblePassword,
                fillColor: vm.inputFillColor,
              ),
              AppButton(
                loading: vm.isLoading,
                onTap: () {
                  if (formKey.currentState!.validate()) {
                    vm.login();
                  }
                },
                text: 'Sign In',
                suffix: Icon(Icons.arrow_forward, color: Apptheme.white),
              ),
            ],
          ),
        );
      },
    );
  }
}
