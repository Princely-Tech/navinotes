import 'package:navinotes/packages.dart';

class ChangePasswordVm extends ChangeNotifier {
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  bool isLoading = false;
  ApiServiceProvider apiServiceProvider;
  BuildContext context;
  ChangePasswordVm({required this.context, required this.apiServiceProvider});
  @override
  void dispose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  updateIsLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  void submitForm() async {
    try {
      updateIsLoading(true);
      final body = {
        "new_password": passwordController.text,
        "otp": apiServiceProvider.sessionManager.getOtp(),
        'email': apiServiceProvider.sessionManager.getEmail(),
      };
      final request = JsonRequest.post(ApiEndpoints.passwordChange, body);
      dynamic response = await apiServiceProvider.apiService.sendJsonRequest(
        request,
      );
      if (context.mounted) {
        MessageDisplayService.showMessage(
          context,
          response['message'] ??
              'Password changed successfully. Login with your new password',
        );
      }
      NavigationHelper.pushAndRemoveUntil(Routes.auth);
    } catch (err) {
      if (context.mounted) {
        MessageDisplayService.showDefaultError(context);
      }
      debugPrint(err.toString());
    }
    updateIsLoading(false);
  }
}
