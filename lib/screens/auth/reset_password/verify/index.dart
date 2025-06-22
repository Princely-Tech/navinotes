import 'package:navinotes/packages.dart';
import 'vm.dart';

class ResetPasswordVerifyScreen extends StatelessWidget {
  ResetPasswordVerifyScreen({super.key});
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    Color pinBgColor = Apptheme.whiteSmoke;
    int pinLength = 6;
    return ScaffoldFrame(
      backgroundColor: Apptheme.white,
      body: ApiServiceComponent(
        child: Consumer<ApiServiceProvider>(
          builder: (_, apiServiceProvider, __) {
            return ChangeNotifierProvider(
              create:
                  (_) => VerifyVM(
                    apiServiceProvider: apiServiceProvider,
                    context: context,
                  ),
              child: Consumer<VerifyVM>(
                builder: (_, vm, __) {
                  return AbsorbPointer(
                    absorbing: vm.isLoading,
                    child: Column(
                      children: [
                        AppHeaderOne(title: 'Verify Email'),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 20,
                          ),
                          child: Form(
                            key: formKey,
                            child: Column(
                              spacing: 20,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Enter the email sent to ${apiServiceProvider.sessionManager.getEmail()}',
                                  style: Apptheme.text.copyWith(
                                    color: Apptheme.stormGray,
                                    fontSize: 16.0,
                                    fontFamily: Apptheme.fontPoppins,
                                  ),
                                ),
                                PinCodeTextField(
                                  controller: vm.controller,
                                  autoDisposeControllers: false,
                                  appContext: context,
                                  length: pinLength,
                                  obscureText: false,
                                  animationType: AnimationType.fade,
                                  pinTheme: PinTheme(
                                    shape: PinCodeFieldShape.box,
                                    borderRadius: BorderRadius.circular(5),
                                    fieldHeight: 40,
                                    fieldWidth: 40,
                                    activeFillColor: pinBgColor,
                                    inactiveFillColor: pinBgColor,
                                    selectedFillColor: pinBgColor,
                                    activeColor: pinBgColor,
                                    inactiveColor: pinBgColor,
                                    selectedColor: Apptheme.primaryColor,
                                    borderWidth: 1,
                                  ),
                                  animationDuration: Duration(
                                    milliseconds: 300,
                                  ),
                                  backgroundColor: Colors.transparent,
                                  enableActiveFill: true,
                                  autoFocus: true,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  autoDismissKeyboard: false,
                                  onCompleted: (v) => submitForm(vm, context),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Please enter a code';
                                    }
                                    return null;
                                  },
                                ),
                                Column(
                                  spacing: 10,
                                  children: [
                                    AppButton(
                                      loading: vm.isLoading,
                                      onTap: () => submitForm(vm, context),
                                      text: 'Verify Email',
                                      suffix: Icon(
                                        Icons.arrow_forward,
                                        color: Apptheme.white,
                                      ),
                                    ),
                                    AppButton.text(
                                      onTap:
                                          () => NavigationHelper.push(
                                            Routes.auth,
                                          ),
                                      text: 'Back to Login',
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
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

  void submitForm(VerifyVM vm, BuildContext context) {
    if (formKey.currentState!.validate()) {
      vm.submitForm();
    } else {
      ErrorDisplayService.showFormInValidError(context);
    }
  }
}
