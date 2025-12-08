abstract interface class Validators {
  static final RegExp emailRegex = RegExp(
    r"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'"
    r'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-'
    r'\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*'
    r'[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4]'
    r'[0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9]'
    r'[0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\'
    r'x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])',
  );
  static final RegExp alphabetRegex = RegExp(r'[a-zA-Z]');
  static final RegExp numberRegex = RegExp(r'[0-9]');
  static final RegExp specialCharactersRegex = RegExp(
    r'[!@#$%^&*(),.?":{}|<>]',
  );

  /// A form field is required with given label
  static String? require(String? value, {required String label}) {
    if (value == null || value.isEmpty) {
      return "$label is required.";
    }
    return null;
  }

  static String? username(String? value) => require(value, label: "Username");

  static String? password(String? value) => require(value, label: "Password");

  static String? token(String? value) => require(value, label: "Token");

  /// Validate email
  static String? email(String? value) {
    if (value == null || value.isEmpty) return "Email address is required.";
    if (!emailRegex.hasMatch(value)) return 'Enter a valid email address.';

    return null;
  }

  /// Validate integer and avoid zero from integer if needed
  static String? integer(
    String? value, {
    required String label,
    bool avoidZeroStart = false,
  }) {
    if (value == null || value.isEmpty) {
      return "$label is required.";
    } else if (double.tryParse(value) == null) {
      return "Invalid ${label.toLowerCase()}.";
    } else if (avoidZeroStart && value[0] == "0") {
      return "$label can not start with 0.";
    }
    return null;
  }
}
