import '../constants/app_strings.dart';

class Validators {
  static String? required(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.requiredField;
    }
    return null;
  }

  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.requiredField;
    }
    final emailRegex = RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$');
    if (!emailRegex.hasMatch(value.trim())) {
      return AppStrings.invalidEmail;
    }
    return null;
  }

  static String? numeric(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.requiredField;
    }
    if (double.tryParse(value) == null) {
      return AppStrings.invalidNumber;
    }
    return null;
  }

  static String? Function(String?) minLengthValidator(int min) {
    return (value) {
      if (value == null || value.trim().length < min) {
        return AppStrings.minLength.replaceFirst('{min}', '$min');
      }
      return null;
    };
  }
}
