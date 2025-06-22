import 'package:navinotes/packages.dart';

String? noNullValidator({
  String? value,
  String message = 'This field is required',
}) {
  if (value == null || value.isEmpty) {
    return message;
  }
  return null;
}

String? passwordValidator(String? value) {
  String? err = noNullValidator(message: 'Enter Password', value: value);
  if (isNotNull(err)) {
    return err;
  }
  if (value!.length < 8) {
    return 'Password must be at least 8 characters long';
  }
  return null;
}

String? confirmPasswordValidator(String? value, String password) {
  String? err = noNullValidator(message: 'Enter Password', value: value);
  if (isNotNull(err)) {
    return err;
  }
  if (value != password) {
    return 'Passwords do not match';
  }
  return null;
}

String? emailValidator(String? value) {
  String? err = noNullValidator(message: 'Email is required', value: value);
  if (isNotNull(err)) {
    return err;
  }
  return EmailValidator.validate(value!) == true ? null : 'Enter a valid email';
}
