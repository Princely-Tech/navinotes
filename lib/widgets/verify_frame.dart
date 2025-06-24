import 'package:navinotes/packages.dart';

class VerifyFormComponent extends StatefulWidget {
  const VerifyFormComponent({
    super.key,
    required this.submitHandler,
    required this.isLoading,
    required this.resendOtpHandler,
  });
  final Function(String?) submitHandler;
  final Future<void> Function() resendOtpHandler;
  final bool isLoading;
  @override
  State<VerifyFormComponent> createState() => _VerifyFormComponentState();
}

class _VerifyFormComponentState extends State<VerifyFormComponent> {
  final formKey = GlobalKey<FormState>();
  late TextEditingController controller;
  int resendCooldown = 60;
  Timer? _resendTimer;
  bool isResendEnabled = false;

  @override
  void dispose() {
    controller.dispose();
    _resendTimer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
    startResendTimer();
  }

  void startResendTimer() {
    setState(() {
      isResendEnabled = false;
      resendCooldown = 60;
    });

    _resendTimer?.cancel();
    _resendTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (resendCooldown == 1) {
        timer.cancel();
        setState(() {
          isResendEnabled = true;
        });
      } else {
        setState(() {
          resendCooldown--;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Color pinBgColor = AppTheme.mintyAqua;
    int pinLength = 6;
    return Consumer<ApiServiceProvider>(
      builder: (context, apiServiceProvider, _) {
        return Form(
          key: formKey,
          child: Column(
            spacing: 20,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              PinCodeTextField(
                controller: controller,
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
                  selectedColor: AppTheme.primaryColor,
                  borderWidth: 1,
                ),
                animationDuration: Duration(milliseconds: 300),
                backgroundColor: Colors.transparent,
                enableActiveFill: true,
                autoFocus: true,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                autoDismissKeyboard: false,
                onCompleted: submitForm,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a code';
                  }
                  return null;
                },
              ),
              AppButton(
                loading: widget.isLoading,
                onTap: () => submitForm(controller.text),
                text: 'Verify Email',
                suffix: Icon(Icons.arrow_forward, color: AppTheme.white),
              ),
              AppButton.secondary(
                // loading: widget.isLoading,
                onTap: () => NavigationHelper.push(Routes.auth),
                text: 'Back to Login',
              ),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'Didn\'t get an email? ',
                      style: AppTheme.text.copyWith(
                        color: AppTheme.stormGray,
                        fontSize: 16.0,
                        fontFamily: AppTheme.fontPoppins,
                      ),
                    ),
                    isResendEnabled
                        ? TextSpan(
                          recognizer:
                              TapGestureRecognizer()
                                ..onTap = () async {
                                  await widget.resendOtpHandler();
                                  startResendTimer(); // restart timer
                                },
                          text: 'Resend',
                          style: AppTheme.text.copyWith(
                            color: AppTheme.vividRose,
                            fontSize: 16.0,
                            fontFamily: AppTheme.fontPoppins,
                            fontWeight: getFontWeight(500),
                          ),
                        )
                        : TextSpan(
                          text: 'Resend in $resendCooldown',
                          style: AppTheme.text.copyWith(
                            color: AppTheme.stormGray,
                            fontSize: 16.0,
                            fontFamily: AppTheme.fontPoppins,
                          ),
                        ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }

  void submitForm(String text) {
    if (formKey.currentState!.validate()) {
      widget.submitHandler(text);
    }
  }
}
