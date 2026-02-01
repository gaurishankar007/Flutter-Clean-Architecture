import 'package:clean_architecture/core/data/models/domain_convertible.dart';
import 'package:clean_architecture/core/data/models/responses/user_response.dart';
import 'package:clean_architecture/core/domain/entities/user_data.dart';
import 'package:equatable/equatable.dart';

class UserDataResponse extends Equatable
    implements DomainConvertible<UserData> {
  const UserDataResponse({
    required this.user,
    required this.accessToken,
    required this.refreshToken,
  });

  factory UserDataResponse.fromJson(Map<String, dynamic> json) {
    return UserDataResponse(
      user: UserResponse.fromJson(json['user'] as Map<String, dynamic>? ?? {}),
      accessToken: json['access'] as String? ?? '',
      refreshToken: json['refresh'] as String? ?? '',
    );
  }

  factory UserDataResponse.fromDomain(UserData domain) {
    return UserDataResponse(
      user: UserResponse.fromDomain(domain.user),
      accessToken: domain.accessToken,
      refreshToken: domain.refreshToken,
    );
  }
  final UserResponse user;
  final String accessToken;
  final String refreshToken;

  Map<String, dynamic> toJson() => {
    'user': user.toJson(),
    'access': accessToken,
    'refresh': refreshToken,
  };

  @override
  UserData toDomain() {
    return UserData(
      user: user.toDomain(),
      accessToken: accessToken,
      refreshToken: refreshToken,
    );
  }

  @override
  List<Object?> get props => [user, accessToken, refreshToken];
}
