import 'package:flutter/material.dart';
import 'package:navinotes/screens/auth/vm.dart';
import 'package:navinotes/settings/apptheme.dart';
import 'package:navinotes/widgets/buttons.dart';
import 'package:navinotes/widgets/inputs.dart';
import 'package:provider/provider.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    // BorderSide borderSide = BorderSide(color: Apptheme.white.withAlpha(30));

    return Consumer<AuthVM>(
      builder: (_, vm, _) {
        return Form(
          child: Column(
            spacing: 40,
            children: [
              Column(
                spacing: 15,
                children: [
                  CustomInputField(
                    hintText: 'Email or Username',
                    keyboardType: TextInputType.emailAddress,
                    fillColor: vm.inputFillColor,
                    style: vm.inputStyle.copyWith(color: Apptheme.aquaGreen),
                    hintStyle: vm.inputStyle,
                    border: vm.inputBorder,
                  ),
                  CustomInputField(
                    hintText: 'Password',
                    keyboardType: TextInputType.visiblePassword,
                    fillColor: vm.inputFillColor,
                    style: vm.inputStyle.copyWith(color: Apptheme.aquaGreen),
                    hintStyle: vm.inputStyle,
                    border: vm.inputBorder,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Flexible(
                        child: Text(
                          'Forgot Password?',
                          style: Apptheme.text.copyWith(
                            color: Apptheme.mintGreen,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              Column(
                spacing: 15,
                children: [
                  AppButton(
                    onTap: vm.login,
                    text: 'Login',
                    gradient: LinearGradient(
                      begin: Alignment(0.00, 0.50),
                      end: Alignment(1.00, 0.50),
                      colors: [Apptheme.vividBlue, Apptheme.aquaGreen],
                    ),
                    style: vm.btnTextStyle,
                  ),
                  AppButton.text(
                    onTap: () => vm.updateAuthType(AuthType.signUp),
                    text: 'Don’t have an account? Create one now',
                    color: Apptheme.mintGreen,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
