import 'package:clean_architecture/core/domain/entities/user_data.dart';
import 'package:clean_architecture/features/auth/data/data_sources/session_local_data_source.dart';
import 'package:clean_architecture/features/auth/domain/repositories/session_repository.dart';
import 'package:injectable/injectable.dart';

/// A class that stores user data
@LazySingleton(as: SessionRepository)
final class SessionRepositoryImpl implements SessionRepository {
  SessionRepositoryImpl({required SessionLocalDataSource localDataSource})
    : _localDataSource = localDataSource;

  final SessionLocalDataSource _localDataSource;

  UserData _userData = const UserData.empty();

  @override
  bool get isLoggedIn => _userData.accessToken.isNotEmpty;

  @override
  UserData get userData => _userData;

  @override
  set setUserData(UserData model) => _userData = model;

  /// Check user's logged in credentials and store it before starting the app
  @override
  Future<void> checkForUserCredential() async {
    final response = await _localDataSource.getUserData();
    if (response != null) {
      _userData = response.toDomain();
    }
  }

  @override
  void clearSessionData() {
    _userData = const UserData.empty();
    _localDataSource.clearUserData();
  }
}
