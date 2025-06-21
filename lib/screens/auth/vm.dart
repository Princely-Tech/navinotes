import 'package:navinotes/packages.dart';

enum AuthType { login, signUp }

enum AuthSocialType { google, apple }

BorderSide defBorderSide = BorderSide(color: Apptheme.white.withAlpha(30));

class AuthVM extends ChangeNotifier with AppRepository {
  bool isLoading = false;
  ApiServiceProvider apiServiceProvider;
  BuildContext context;
  AuthVM({required this.context, required this.apiServiceProvider});
  AuthType authType = AuthType.login;
  Color inputFillColor = Apptheme.whiteSmoke;
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
        // googleUser.
        final body = {
          "name": googleUser?.displayName,
          "email": googleUser?.email,
          'auth_provider': 'google',
          'token': googleAuth?.idToken,
        };
        final request = JsonRequest.post(
          ApiEndpoints.authRegisterProvider,
          body,
        );
        final response = await apiServiceProvider.apiService.sendJsonRequest(
          request,
        );
        _completeSignIn(response);
      } else {
        fToast.showToast(
          child: MessageDisplayContainer('Could not get user data'),
          gravity: ToastGravity.TOP_RIGHT,
          toastDuration: const Duration(seconds: 3),
        );
      }
    } catch (e) {
      fToast.showToast(
        child: MessageDisplayContainer('Sign in failed'),
        gravity: ToastGravity.TOP_RIGHT,
        toastDuration: const Duration(seconds: 3),
      );
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
      debugPrint(err.toString());
    }
    updateIsLoading(false);
  }
}

List<String> authFooterLinks = ['Privacy Policy', 'Terms', 'Help'];
