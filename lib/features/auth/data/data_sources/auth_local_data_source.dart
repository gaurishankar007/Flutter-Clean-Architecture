import 'dart:convert';

import 'package:clean_architecture/core/clients/local/local_storage_client.dart';
import 'package:clean_architecture/core/constants/local_db_keys.dart';
import 'package:clean_architecture/core/data/states/data_state.dart';
import 'package:clean_architecture/core/errors/error_handler.dart';
import 'package:clean_architecture/core/types/types.dart';
import 'package:clean_architecture/features/auth/data/models/responses/user_data_response.dart';
import 'package:injectable/injectable.dart';

abstract interface class AuthLocalDataSource {
  FutureVoid saveUserData(UserDataResponse userDataModel);
  FutureData<UserDataResponse> getUserData();
  FutureVoid removeUserData();
}

@LazySingleton(as: AuthLocalDataSource)
final class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  const AuthLocalDataSourceImpl({
    required ErrorHandler errorHandler,
    required LocalStorageClient localDatabase,
  }) : _errorHandler = errorHandler,
       _localDatabase = localDatabase;

  final ErrorHandler _errorHandler;
  final LocalStorageClient _localDatabase;

  @override
  FutureVoid saveUserData(UserDataResponse userDataModel) {
    return _errorHandler.execute(() async {
      await _localDatabase.setString(
        LocalDbKeys.userData,
        jsonEncode(userDataModel.toJson()),
      );
      return SuccessState.nil;
    });
  }

  @override
  FutureData<UserDataResponse> getUserData() {
    return _errorHandler.execute(() async {
      final String userData =
          _localDatabase.getString(LocalDbKeys.userData) ?? '';

      if (userData.isNotEmpty) {
        final userDataModel = UserDataResponse.fromJson(
          jsonDecode(userData) as JsonMap,
        );
        return SuccessState(data: userDataModel);
      }
      return const FailureState<UserDataResponse>(
        message: 'User data not found.',
      );
    });
  }

  @override
  FutureVoid removeUserData() {
    return _errorHandler.execute(() async {
      await _localDatabase.remove(LocalDbKeys.userData);
      return SuccessState.nil;
    });
  }
}
