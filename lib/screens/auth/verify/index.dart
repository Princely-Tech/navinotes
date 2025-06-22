import 'package:navinotes/packages.dart';
import 'vm.dart';

class VerifyBody extends StatelessWidget {
  VerifyBody({super.key});
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    Color pinBgColor = Apptheme.whiteSmoke;
    int pinLength = 6;
    final vm = Provider.of<VerifyVM>(context);
    final apiServiceProvider = Provider.of<ApiServiceProvider>(context);
    return ScaffoldFrame(
      backgroundColor: Apptheme.white,
      body: AbsorbPointer(
        absorbing: vm.isLoading,
        child: Column(
          spacing: 20,
          children: [
            AppHeaderOne(title: 'Verify email'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
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
                      animationDuration: Duration(milliseconds: 300),
                      backgroundColor: Colors.transparent,
                      enableActiveFill: true,
                      autoFocus: true,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      autoDismissKeyboard: false,
                      onCompleted: (v) => submitForm(vm),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a code';
                        }
                        return null;
                      },
                    ),
                    AppButton(
                      loading: vm.isLoading,
                      onTap: () => submitForm(vm),
                      text: 'Verify Email',
                      suffix: Icon(Icons.arrow_forward, color: Apptheme.white),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void submitForm(VerifyVM vm) {
    if (formKey.currentState!.validate()) {
      vm.submitForm();
    }
  }
}

class VerifyScreen extends StatelessWidget {
  const VerifyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ApiServiceComponent(
      child: Consumer<ApiServiceProvider>(
        builder: (_, apiServiceProvider, __) {
          return ChangeNotifierProvider(
            create: (_) => VerifyVM(apiServiceProvider: apiServiceProvider),
            child: VerifyBody(),
          );
        },
      ),
    );
  }
}
