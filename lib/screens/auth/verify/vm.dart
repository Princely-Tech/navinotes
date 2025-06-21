import 'package:navinotes/packages.dart';

enum AuthType { login, signUp }

BorderSide defBorderSide = BorderSide(color: Apptheme.white.withAlpha(30));

class VerifyVM extends ChangeNotifier with AppRepository {
  bool isLoading = false;
 
  VerifyVM({ required this.apiServiceProvider});
  ApiServiceProvider apiServiceProvider;
  AuthType authType = AuthType.login;
  Color inputFillColor = Apptheme.whiteSmoke;

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController refCodeController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  //TODO discuss the location info

  toggleAuthType() {
    authType = authType == AuthType.login ? AuthType.signUp : AuthType.login;
    notifyListeners();
  }

  updateIsLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  void login() async {
    try {
      updateIsLoading(true);
      final body = {
        "email": emailController.text,
        "password": passwordController.text,
      };
      final request = JsonRequest.post(ApiEndpoints.authLogin, body);
      final response = await apiServiceProvider.apiService.sendJsonRequest(
        request,
      );
      _completeSignIn(response);
    } catch (err) {
      debugPrint(err.toString());
    }
    updateIsLoading(false);
  }

  void clearAllController() {
    nameController.clear();
    emailController.clear();
    refCodeController.clear();
    passwordController.clear();
  }

  void _completeSignIn(Map<String, dynamic> response) {
    AuthApiResponse authApiResponse = AuthApiResponse.fromJson(response);
    apiServiceProvider.sessionManager.updateSession(
      user: authApiResponse.user,
      token: authApiResponse.token,
    );
    clearAllController();
    NavigationHelper.pushReplacement(Routes.aboutMe);
    //TODO ask about verify account
  }

  void signUp() async {
    try {
      updateIsLoading(true);
      final body = {
        "name": nameController.text,
        "email": emailController.text,
        "password": passwordController.text,
        "referral_code": refCodeController.text,
      };
      final request = JsonRequest.post(ApiEndpoints.authRegister, body);
      final response = await apiServiceProvider.apiService.sendJsonRequest(
        request,
      );
      _completeSignIn(response);
    } catch (err) {
      debugPrint(err.toString());
    }
    updateIsLoading(false);
  }
}

List<String> authFooterLinks = ['Privacy Policy', 'Terms', 'Help'];
