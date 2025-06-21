 import 'package:navinotes/packages.dart';
 
 void completeSignInAndRouteOut({required Map<String, dynamic> response,required  ApiServiceProvider apiServiceProvider }) {
    AuthApiResponse authApiResponse = AuthApiResponse.fromJson(response);
    apiServiceProvider.sessionManager.updateSession(
      user: authApiResponse.user,
      token: authApiResponse.token,
    );
    if (isNull(authApiResponse.user.emailVerifiedAt)) {
      NavigationHelper.pushAndRemoveUntil(Routes.verify);
      return;
    }
    if (isNull(authApiResponse.user.iam) &&
        isNull(authApiResponse.user.about) &&
        isNull(authApiResponse.user.schoolName) &&
        isNull(authApiResponse.user.schoolField) &&
        isNull(authApiResponse.user.schoolLevel)) {
      NavigationHelper.pushAndRemoveUntil(Routes.aboutMe);
      return;
    }
    NavigationHelper.pushAndRemoveUntil(Routes.dashboard);
  }