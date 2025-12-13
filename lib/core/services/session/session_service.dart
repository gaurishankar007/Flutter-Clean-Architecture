import 'dart:convert';

import 'package:clean_architecture/core/constants/local_db_keys.dart';
import 'package:clean_architecture/core/domain/entities/user_data.dart';
import 'package:clean_architecture/core/services/database/local_database_service.dart';
import 'package:clean_architecture/core/services/navigation/navigation_service.dart';
import 'package:clean_architecture/features/auth/data/models/responses/user_data_response.dart';
import 'package:clean_architecture/routing/routes.gr.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

abstract interface class SessionService {
  bool get isLoggedIn;
  UserData get userData;
  String get refreshToken;
  String get accessToken;
  String get fullName;
  Future<void> checkForUserCredential();
  set setUserData(UserData model);
  Future<void> refreshAccessToken(String accessToken);
  void clearSessionData();
}

/// A class that stores user data
@LazySingleton(as: SessionService)
final class SessionServiceImpl implements SessionService {
  final LocalDatabaseService _localDatabase;
  final NavigationService _navigationService;

  SessionServiceImpl({
    required LocalDatabaseService localDatabase,
    required NavigationService navigationService,
  }) : _localDatabase = localDatabase,
       _navigationService = navigationService;

  UserData _userData = const UserData.empty();

  @override
  bool get isLoggedIn => _userData.accessToken.isNotEmpty;
  @override
  UserData get userData => _userData;
  @override
  String get refreshToken => _userData.refreshToken;
  @override
  String get accessToken => _userData.accessToken;
  @override
  String get fullName =>
      "${_userData.user.firstName} ${_userData.user.lastName}";

  /// Check user's logged in credentials and store it before starting the app
  @override
  Future<void> checkForUserCredential() async {
    final stored = _localDatabase.getString(LocalDbKeys.userData);
    if (stored != null && stored.isNotEmpty) {
      try {
        final map = jsonDecode(stored) as Map<String, dynamic>;
        final resp = UserDataResponse.fromJson(map);
        _userData = resp.toDomain();
      } catch (_) {
        _userData = const UserData.empty();
      }
    }
  }

  @override
  set setUserData(UserData model) => _userData = model;

  /// Store new access token if it is expired.
  @override
  Future<void> refreshAccessToken(String accessToken) async {
    setUserData = _userData.copyWith(accessToken: accessToken);
    final resp = UserDataResponse.fromDomain(_userData);
    await _localDatabase.setString(
      LocalDbKeys.userData,
      jsonEncode(resp.toJson()),
    );
  }

  @override
  void clearSessionData() {
    _userData = const UserData.empty();
    _localDatabase.remove(LocalDbKeys.userData);
    _navigationService.replaceAllRoute(const LoginRoute());
  }
}

/// A util class for accessing [SessionService]
abstract final class SessionUtil {
  /// Returns the registered instance of [SessionService] which is always the same
  static SessionService get I => GetIt.I<SessionService>();
}
