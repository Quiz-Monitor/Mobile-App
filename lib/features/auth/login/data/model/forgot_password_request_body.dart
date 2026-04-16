class ForgotPasswordRequestBody {
  final String email;

  const ForgotPasswordRequestBody({required this.email});

  Map<String, dynamic> toJson() {
    return <String, dynamic>{'email': email};
  }
}
