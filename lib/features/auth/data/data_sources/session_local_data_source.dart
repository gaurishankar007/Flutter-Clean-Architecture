import 'dart:convert';

import 'package:clean_architecture/core/clients/local/local_storage_client.dart';
import 'package:clean_architecture/core/constants/local_db_keys.dart';
import 'package:clean_architecture/features/auth/data/models/responses/user_data_response.dart';
import 'package:injectable/injectable.dart';

abstract interface class SessionLocalDataSource {
  Future<UserDataResponse?> getUserData();

  Future<void> saveUserData(UserDataResponse userData);

  Future<void> clearUserData();
}

@LazySingleton(as: SessionLocalDataSource)
final class SessionLocalDataSourceImpl implements SessionLocalDataSource {
  SessionLocalDataSourceImpl(this._localStorageClient);
  final LocalStorageClient _localStorageClient;

  @override
  Future<UserDataResponse?> getUserData() async {
    final stored = _localStorageClient.getString(LocalDbKeys.userData);
    if (stored != null && stored.isNotEmpty) {
      try {
        final map = jsonDecode(stored) as Map<String, dynamic>;
        return UserDataResponse.fromJson(map);
      } catch (_) {
        return null;
      }
    }
    return null;
  }

  @override
  Future<void> saveUserData(UserDataResponse userData) async {
    await _localStorageClient.setString(
      LocalDbKeys.userData,
      jsonEncode(userData.toJson()),
    );
  }

  @override
  Future<void> clearUserData() async {
    await _localStorageClient.remove(LocalDbKeys.userData);
  }
}
