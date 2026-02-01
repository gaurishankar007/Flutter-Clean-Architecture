import 'dart:convert';

import 'package:clean_architecture/core/clients/local/local_storage_client.dart';
import 'package:clean_architecture/core/constants/local_db_keys.dart';
import 'package:clean_architecture/core/data/handlers/error_handler.dart';
import 'package:clean_architecture/core/data/states/data_state.dart';
import 'package:clean_architecture/core/utils/type_defs.dart';
import 'package:clean_architecture/features/auth/data/models/responses/user_data_response.dart';
import 'package:injectable/injectable.dart';

abstract interface class AuthLocalDataSource {
  FutureBool saveUserData(UserDataResponse userDataModel);
  FutureData<UserDataResponse> getUserData();
  FutureBool removeUserData();
}

@LazySingleton(as: AuthLocalDataSource)
final class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  const AuthLocalDataSourceImpl({required LocalStorageClient localDatabase})
    : _localDatabase = localDatabase;
  final LocalStorageClient _localDatabase;

  @override
  FutureBool saveUserData(UserDataResponse userDataModel) {
    return ErrorHandler.execute(() async {
      await _localDatabase.setString(
        LocalDbKeys.userData,
        jsonEncode(userDataModel.toJson()),
      );
      return const SuccessState(data: true);
    });
  }

  @override
  FutureData<UserDataResponse> getUserData() {
    return ErrorHandler.execute(() async {
      final String userData =
          _localDatabase.getString(LocalDbKeys.userData) ?? '';

      if (userData.isNotEmpty) {
        final userDataModel = UserDataResponse.fromJson(
          jsonDecode(userData) as MapDynamic,
        );
        return SuccessState(data: userDataModel);
      }
      return const FailureState<UserDataResponse>(
        message: 'User data not found.',
      );
    });
  }

  @override
  FutureBool removeUserData() {
    return ErrorHandler.execute(() async {
      await _localDatabase.remove(LocalDbKeys.userData);
      return const SuccessState(data: true);
    });
  }
}
