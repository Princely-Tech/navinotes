import 'package:navinotes/packages.dart';

class ChangePasswordVm extends ChangeNotifier {
  bool isLoading = false;
  ApiServiceProvider apiServiceProvider;
  BuildContext context;
  ChangePasswordVm({required this.context, required this.apiServiceProvider});
  TextEditingController emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  updateIsLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  void submit() async {
    try {
      updateIsLoading(true);
      final body = {"email": emailController.text};
      final request = JsonRequest.post(ApiEndpoints.passwordOtp, body);
      await apiServiceProvider.apiService.sendJsonRequest(request);
      apiServiceProvider.sessionManager.updateEmail(emailController.text);
      NavigationHelper.push(Routes.resetPasswordVerify);
    } catch (err) {
      if (context.mounted) {
        MessageDisplayService.showDefaultError(context);
      }
      debugPrint(err.toString());
    }
    updateIsLoading(false);
  }
}
