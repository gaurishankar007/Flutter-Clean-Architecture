class RefreshTokenRequest {
  const RefreshTokenRequest({required this.refreshToken});
  final String refreshToken;

  Map<String, String> toJson() => {'refresh': refreshToken};
}
