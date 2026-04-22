class RefreshTokenRequestBody {
  final String refreshToken;

  const RefreshTokenRequestBody({required this.refreshToken});

  Map<String, dynamic> toJson() => <String, dynamic>{
    'refreshToken': refreshToken,
  };
}
