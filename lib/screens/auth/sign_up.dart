import 'package:flutter/material.dart';
import 'package:navinotes/screens/auth/vm.dart';
import 'package:navinotes/settings/apptheme.dart';
import 'package:navinotes/widgets/buttons.dart';
import 'package:navinotes/widgets/inputs.dart';
import 'package:provider/provider.dart';

class SignUpForm extends StatelessWidget {
  const SignUpForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthVM>(
      builder: (_, vm, _) {
        return Form(
          child: Column(
            spacing: 20,
            children: [
              CustomInputField(
                hintText: 'Philip Derek',
                label: 'Full Name',
                fillColor: vm.inputFillColor,
              ),
              CustomInputField(
                hintText: 'your.email@school.edu',
                label: 'Email',
                keyboardType: TextInputType.emailAddress,
                fillColor: vm.inputFillColor,
              ),
              CustomInputField(
                hintText: 'Password',
                label: 'Password',
                labelRight: AppButton.text(
                  onTap: () {},
                  text: 'Forgot Password?',
                ),
                keyboardType: TextInputType.visiblePassword,
                fillColor: vm.inputFillColor,
              ),
              AppButton(
                onTap: vm.login,
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
