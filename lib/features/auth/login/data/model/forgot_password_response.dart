class ForgotPasswordResponse {
  final String message;

  const ForgotPasswordResponse({required this.message});

  factory ForgotPasswordResponse.fromJson(Map<String, dynamic>? json) {
    return ForgotPasswordResponse(
      message:
          (json?['message'] as String?) ??
          'If the email exists, reset instructions will be sent.',
    );
  }
}
