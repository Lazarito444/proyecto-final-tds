class SystemTokens {
  final String accessToken;
  final String refreshToken;

  const SystemTokens({required this.accessToken, required this.refreshToken});

  factory SystemTokens.fromJson(Map<String, dynamic> json) {
    return SystemTokens(
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'accessToken': accessToken, 'refreshToken': refreshToken};
  }
}
