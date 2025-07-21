import 'package:navinotes/packages.dart';

class ErrorDisplayService {
  static void showError(BuildContext context, DioException err) {
    final fToast = FToast();
    fToast.init(context);
    if (err.response?.statusCode == 422) {
      final errorData = err.response?.data;
      if (errorData != null && errorData['errors'] is Map) {
        final errors = errorData['errors'] as Map;
        errors.forEach((field, messages) {
          if (messages is List) {
            if (messages.length > 2) {
              messages = messages.sublist(0, 2);
            }
            for (var message in messages) {
              fToast.showToast(
                child: MessageDisplayContainer(message),
                gravity: AppConstants.toastGravity,
                toastDuration: AppConstants.toastDuration,
              );
            }
          }
        });
      } else {
        fToast.showToast(
          child: MessageDisplayContainer('Unprocessable entity'),
          gravity: AppConstants.toastGravity,
          toastDuration: AppConstants.toastDuration,
        );
      }
    } else if (err.response?.statusCode != 200 &&
        err.response?.statusCode != 201) {
      String errMsg = '';
      if (err.response?.data is Map) {
        errMsg = err.response!.data['error'] ?? err.response!.data['message'];
      } else {
        errMsg = 'Something went wrong';
      }
      fToast.showToast(
        child: MessageDisplayContainer(errMsg),
        gravity: AppConstants.toastGravity,
        toastDuration: AppConstants.toastDuration,
      );
    }
  }

  static void showMessage(
    BuildContext context,
    String message, {
    bool isError = false,
  }) {
    final fToast = FToast();
    fToast.init(context);
    fToast.showToast(
      child: MessageDisplayContainer(message, isError: isError),
      gravity: AppConstants.toastGravity,
      toastDuration: AppConstants.toastDuration,
    );
  }

  static void showErrorMessage(BuildContext context, String message) {
    showMessage(isError: true, context, message);
  }

  static void showDefaultError(BuildContext context) {
    final fToast = FToast();
    fToast.init(context);
    fToast.showToast(
      child: MessageDisplayContainer('An error occurred!'),
      gravity: AppConstants.toastGravity,
      toastDuration: AppConstants.toastDuration,
    );
  }

  static void showFormInValidError(BuildContext context) {
    final fToast = FToast();
    fToast.init(context);
    fToast.showToast(
      child: MessageDisplayContainer('Please fill in all the required fields'),
      gravity: AppConstants.toastGravity,
      toastDuration: AppConstants.toastDuration,
    );
  }
}
