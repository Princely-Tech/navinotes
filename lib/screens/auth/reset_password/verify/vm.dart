import 'package:navinotes/packages.dart';

class VerifyVM extends ChangeNotifier with AppRepository {
  bool isLoading = false;
  BuildContext context;
  VerifyVM({required this.apiServiceProvider, required this.context});
  ApiServiceProvider apiServiceProvider;

  TextEditingController controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
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
        "otp": controller.text,
        'email': apiServiceProvider.sessionManager.getEmail(),
      };
      final request = JsonRequest.post(ApiEndpoints.passwordVerifyOtp, body);
      await apiServiceProvider.apiService.sendJsonRequest(request);
      apiServiceProvider.sessionManager.updateOtp(controller.text);
      NavigationHelper.push(Routes.changePassword);
    } catch (err) {
      if (context.mounted) {
        ErrorDisplayService.showDefaultError(context);
      }
      debugPrint(err.toString());
    }
    updateIsLoading(false);
  }
}
