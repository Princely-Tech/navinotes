class ApiEndpoints {
  ApiEndpoints._();
  static const String authRegister = '/auth/register';
  static const String authRegisterProvider = '/auth/register-with-provider';
  static const String authLoginProvider = '/auth/login-with-provider';
  static const String authLogin = '/auth/login';
  static const String verifyEmail = '/profile/verify-email';
  static const String profile = '/profile';
  static const String profileImage = '/profile/picture';
  static const String passwordOtp = '/auth/password/recovery-otp';
  static const String passwordVerifyOtp = '/auth/password/verify-otp';
  static const String passwordChange = '/auth/password/reset';
}