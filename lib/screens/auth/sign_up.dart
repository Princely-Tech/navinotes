import 'package:navinotes/packages.dart';
import 'vm.dart';

class SignUpForm extends StatelessWidget {
  SignUpForm({super.key});
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
                controller: vm.nameController,
                hintText: 'Philip Derek',
                label: 'Full Name',
                fillColor: vm.inputFillColor,
                validator:
                    (input) => noNullValidator(
                      value: input,
                      message: 'Enter your name',
                    ),
              ),
              CustomInputField(
                controller: vm.emailController,
                hintText: 'your.email@school.edu',
                label: 'Email',
                keyboardType: TextInputType.emailAddress,
                fillColor: vm.inputFillColor,
                validator: emailValidator,
              ),
              CustomInputField(
                controller: vm.passwordController,
                hintText: 'Password',
                label: 'Password',
                labelRight: AppButton.text(
                  onTap: () {},
                  text: 'Forgot Password?',
                ),
                keyboardType: TextInputType.visiblePassword,
                fillColor: vm.inputFillColor,
                validator: passwordValidator,
              ),
              CustomInputField(
                controller: vm.refCodeController,
                hintText: 'Referral Code',
                label: 'Referral Code',
                fillColor: vm.inputFillColor,
                optional: true,
              ),
              AppButton(
                loading: vm.isLoading,
                onTap: () {
                  if (formKey.currentState!.validate()) {
                    vm.signUp(); 
                  }
                },
                text: 'Create Account',
                suffix: Icon(Icons.arrow_forward, color: Apptheme.white),
              ),
            ],
          ),
        );
      },
    );
  }
}
