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
                gravity: ToastGravity.TOP_RIGHT,
                toastDuration: const Duration(seconds: 3),
              );
            }
          }
        });
      } else {
        fToast.showToast(
          child: MessageDisplayContainer('Unprocessable entity'),
          gravity: ToastGravity.TOP_RIGHT,
          toastDuration: const Duration(seconds: 3),
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
        gravity: ToastGravity.TOP_RIGHT,
        toastDuration: const Duration(seconds: 3),
      );
    }
  }
}
