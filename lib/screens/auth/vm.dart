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

  void clearAllController() {
    nameController.clear();
    emailController.clear();
    refCodeController.clear();
    passwordController.clear();
    notifyListeners();
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

  Future<void> socialLogin(AuthSocialType type) async {
    updateLoadingAuthType(type);
    if (type == AuthSocialType.google) {
      await signInWithGoogle(context);
    } else {
    }
    updateLoadingAuthType(null);
  }

  Future<void> signInWithGoogle(BuildContext context) async {
    final fToast = FToast();
    fToast.init(context);
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (isNotNull(googleUser)) {
        nameController.text = googleUser?.displayName ?? '';
        emailController.text = googleUser?.email ?? '';
        fToast.showToast(
          child: MessageDisplayContainer(
            'User Info gotten! Kindly enter a password and continue.',
            isError: false,
          ),
          gravity: ToastGravity.TOP_RIGHT,
          toastDuration: const Duration(seconds: 3),
        );
      } else {
        fToast.showToast(
          child: MessageDisplayContainer('Could not get user data'),
          gravity: ToastGravity.TOP_RIGHT,
          toastDuration: const Duration(seconds: 3),
        );
      }
      // final GoogleSignInAuthentication? googleAuth =
      //     await googleUser?.authentication;
      // final credential = GoogleAuthProvider.credential(
      //   accessToken: googleAuth?.accessToken,
      //   idToken: googleAuth?.idToken,
      // );
      print(googleUser);
      // UserCredential credentials = await _auth.signInWithCredential(credential);
      // handleCredential(credentials);
      // await goToFavStores();
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
