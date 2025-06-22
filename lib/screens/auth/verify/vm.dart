import 'package:navinotes/packages.dart';

class VerifyVM extends ChangeNotifier with AppRepository {
  bool isLoading = false;

  VerifyVM({required this.apiServiceProvider});
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
      final body = {"otp": controller.text};
      final request = JsonRequest.post(ApiEndpoints.verifyEmail, body);
      final response = await apiServiceProvider.apiService.sendJsonRequest(
        request,
      );
      completeSignInAndRouteOut(
        response: response,
        apiServiceProvider: apiServiceProvider,
      );
    } catch (err) {
      debugPrint(err.toString());
    }
    updateIsLoading(false);
  }
}
