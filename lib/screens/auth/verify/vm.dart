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
    if(isNull(otp)){
        if (context.mounted) {
        ErrorDisplayService.showFormInValidError(context);
      }
      return;
    }
    try {
      updateIsLoading(true);
      final body = {"otp": otp};
      final request = JsonRequest.post(ApiEndpoints.verifyEmail, body);
      final response = await apiServiceProvider.apiService.sendJsonRequest(
        request,
      );
      completeSignInAndRouteOut(
        response: response,
        apiServiceProvider: apiServiceProvider,
      );
    } catch (err) {
      if (context.mounted) {
        ErrorDisplayService.showDefaultError(context);
      }
      debugPrint(err.toString());
    }
    updateIsLoading(false);
  }
   Future<void> resendOtp() async {
    Map<String, dynamic> body = {};
    final request = JsonRequest.post(ApiEndpoints.getVerifyOtp, body);
    await apiServiceProvider.apiService.sendJsonRequest(request);
  }
}
