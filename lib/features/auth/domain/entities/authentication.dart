class Authentication {
  const Authentication({required this.username, required this.password});
  final String username;
  final String password;

  Authentication copyWith({
    required String fmcToken,
    required String deviceType,
  }) => Authentication(username: username, password: password);

  @override
  bool operator ==(covariant Authentication other) {
    if (identical(this, other)) {
      return true;
    }

    return other.username == username && other.password == password;
  }

  @override
  int get hashCode {
    return username.hashCode ^ password.hashCode;
  }
}
