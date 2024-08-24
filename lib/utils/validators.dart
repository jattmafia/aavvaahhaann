import 'package:avahan/utils/extensions.dart';
import 'package:email_validator/email_validator.dart';

class Validators {
  static String? required(String? value) {
    return value == null || value.isEmpty ? "Required" : null;
  }

  static String? emailRequired(String? value) {
    return required(value) ??
        (EmailValidator.validate(value!) ? null : "Enter valid email");
  }

  static String? email(String? value) {
    return (value?.crim != null)
        ? (EmailValidator.validate(value!) ? null : "Enter valid email")
        : null;
  }

  static String? amount(String? value) {
    return required(value) ??
        (int.tryParse(value!) == null ? "Enter valid amount" : null);
  }
}
