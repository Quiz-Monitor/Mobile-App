class RefreshTokenResponse {
  final String? accessToken;
  final String? refreshToken;
  final String? message;

  const RefreshTokenResponse({
    this.accessToken,
    this.refreshToken,
    this.message,
  });

  factory RefreshTokenResponse.fromJson(Map<String, dynamic> json) {
    return RefreshTokenResponse(
      accessToken: json['accessToken']?.toString() ?? json['token']?.toString(),
      refreshToken: json['refreshToken']?.toString(),
      message: json['message']?.toString(),
    );
  }
}
