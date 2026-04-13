/// Centralised form validators — reuse across Login, Signup, ForgotPassword screens.
class AppValidators {
  static String? email(String? value) {
    if (value == null || value.isEmpty) return 'Please enter your email';
    if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) return 'Please enter your password';
    if (value.length < 6) return 'Password must be at least 6 characters';
    return null;
  }

  static String? confirmPassword(String? value, String original) {
    if (value == null || value.isEmpty) return 'Please confirm your password';
    if (value != original) return 'Passwords do not match';
    return null;
  }

  static String? fullName(String? value) {
    if (value == null || value.isEmpty) return 'Please enter your full name';
    return null;
  }

  static String? required(String? value, {String field = 'This field'}) {
    if (value == null || value.isEmpty) return '$field is required';
    return null;
  }
}
