class Validators {
  Validators._();

  static final _email = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
  static final _hhmm = RegExp(r'^([01]\d|2[0-3]):[0-5]\d$');

  static String? required(String? value, {String field = 'This field'}) {
    if (value == null || value.trim().isEmpty) return '$field is required';
    return null;
  }

  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) return 'Email is required';
    if (!_email.hasMatch(value.trim())) return 'Enter a valid email';
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) return 'Password is required';
    if (value.length < 8) return 'At least 8 characters';
    return null;
  }

  static String? confirmPassword(String? value, String original) {
    if (value == null || value.isEmpty) return 'Please confirm the password';
    if (value != original) return 'Passwords do not match';
    return null;
  }

  /// Departure time in HH:mm (rule R11).
  static String? time(String? value) {
    if (value == null || value.trim().isEmpty) return 'Time is required';
    if (!_hhmm.hasMatch(value.trim())) return 'Use HH:mm, for example 07:45';
    return null;
  }
}
