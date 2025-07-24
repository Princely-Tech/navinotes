import 'package:navinotes/packages.dart';

enum AuthType { login, signUp }

enum AuthSocialType { google, apple }

BorderSide defBorderSide = BorderSide(color: AppTheme.white.withAlpha(30));

class AuthVM extends ChangeNotifier {
  bool isLoading = false;
  ApiServiceProvider apiServiceProvider;
  BuildContext context;
  AuthVM({required this.context, required this.apiServiceProvider});
  AuthType authType = AuthType.login;
  Color inputFillColor = AppTheme.whiteSmoke;
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController refCodeController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    refCodeController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  AuthSocialType? loadingAuthType;

  void updateLoadingAuthType(AuthSocialType? type) {
    loadingAuthType = type;
    notifyListeners();
  }

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
      if (context.mounted) {
        MessageDisplayService.showDefaultError(context);
      }
      debugPrint(err.toString());
    }
    updateIsLoading(false);
  }

  void _completeSignIn(Map<String, dynamic> response) {
    completeSignInAndRouteOut(
      response: response,
      apiServiceProvider: apiServiceProvider,
    );
  }

  Future<void> socialLogin(AuthSocialType type) async {
    updateLoadingAuthType(type);
    if (type == AuthSocialType.google) {
      await signInWithGoogle(context);
    } else {}
    updateLoadingAuthType(null);
  }

  Future<void> signInWithGoogle(BuildContext context) async {
    final fToast = FToast();
    fToast.init(context);
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;
      if (isNotNull(googleUser) && isNotNull(googleAuth)) {
        final body = {
          "name": googleUser?.displayName,
          "email": googleUser?.email,
          'auth_provider': 'google',
          'token': googleAuth?.idToken,
        };
        final request = JsonRequest.post(
          AuthType.login == authType
              ? ApiEndpoints.authLoginProvider
              : ApiEndpoints.authRegisterProvider,
          body,
        );
        final response = await apiServiceProvider.apiService.sendJsonRequest(
          request,
        );
        _completeSignIn(response);
      } else {
        fToast.showToast(
          child: MessageDisplayContainer('Could not get user data'),
          gravity: AppConstants.toastGravity,
          toastDuration: AppConstants.toastDuration,
        );
      }
    } catch (e) {
      if (context.mounted) {
        MessageDisplayService.showDefaultError(context);
      }
      debugPrint(e.toString());
    }
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
      if (context.mounted) {
        MessageDisplayService.showDefaultError(context);
      }
      debugPrint(err.toString());
    }
    updateIsLoading(false);
  }
}

List<String> authFooterLinks = ['Privacy Policy', 'Terms', 'Help'];
