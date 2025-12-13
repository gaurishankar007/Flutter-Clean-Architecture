import 'package:clean_architecture/features/auth/domain/entities/authentication.dart';

class AuthenticationRequest {
  final String username;
  final String password;

  const AuthenticationRequest({required this.username, required this.password});

  factory AuthenticationRequest.fromDomain(Authentication authentication) =>
      AuthenticationRequest(
        username: authentication.username,
        password: authentication.password,
      );

  Map<String, String> toJson() => {"username": username, "password": password};
}
