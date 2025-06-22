import 'package:navinotes/packages.dart';

class ChangePasswordVm extends ChangeNotifier {
  TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  ApiServiceProvider apiServiceProvider;
  BuildContext context;
  ChangePasswordVm({required this.context, required this.apiServiceProvider});
  @override
  void dispose() {
    passwordController.dispose();
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
      await apiServiceProvider.apiService.sendJsonRequest(request);
      NavigationHelper.pushAndRemoveUntil(Routes.auth);
    } catch (err) {
      if (context.mounted) {
        ErrorDisplayService.showDefaultError(context);
      }
      debugPrint(err.toString());
    }
    updateIsLoading(false);
  }
}
