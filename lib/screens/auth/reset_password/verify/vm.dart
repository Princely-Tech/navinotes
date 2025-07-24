import 'package:navinotes/packages.dart';

class VerifyVM extends ChangeNotifier with AppRepository {
  bool isLoading = false;
  BuildContext context;
  VerifyVM({required this.apiServiceProvider, required this.context});
  ApiServiceProvider apiServiceProvider;

  updateIsLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  void submitForm(String? otp) async {
    if (isNull(otp)) {
      if (context.mounted) {
        MessageDisplayService.showFormInValidError(context);
      }
      return;
    }
    try {
      updateIsLoading(true);
      final body = {
        "otp": otp,
        'email': apiServiceProvider.sessionManager.getEmail(),
      };
      final request = JsonRequest.post(ApiEndpoints.passwordVerifyOtp, body);
      dynamic response = await apiServiceProvider.apiService.sendJsonRequest(
        request,
      );
      apiServiceProvider.sessionManager.updateOtp(response['code']);
      NavigationHelper.push(Routes.changePassword);
    } catch (err) {
      if (context.mounted) {
        MessageDisplayService.showDefaultError(context);
      }
      debugPrint(err.toString());
    }
    updateIsLoading(false);
  }

  Future<void> resendOtp() async {
    final body = {"email": apiServiceProvider.sessionManager.getEmail()};
    final request = JsonRequest.post(ApiEndpoints.passwordOtp, body);
    await apiServiceProvider.apiService.sendJsonRequest(request);
  }
}
