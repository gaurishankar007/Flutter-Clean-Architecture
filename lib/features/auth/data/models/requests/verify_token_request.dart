import 'package:clean_architecture/features/auth/domain/entities/verify_token.dart';

class VerifyTokenRequest {
  final String token;
  final String userId;

  const VerifyTokenRequest({required this.token, required this.userId});

  factory VerifyTokenRequest.fromDomain(VerifyToken verifyToken) =>
      VerifyTokenRequest(token: verifyToken.token, userId: verifyToken.userId);

  Map<String, dynamic> toJson() => {"token": token, "user_id": userId};
}
