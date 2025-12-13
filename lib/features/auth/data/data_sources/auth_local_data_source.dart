import 'dart:convert';

import 'package:clean_architecture/core/constants/local_db_keys.dart';
import 'package:clean_architecture/core/data_handling/data_handler.dart';
import 'package:clean_architecture/core/data_states/data_state.dart';
import 'package:clean_architecture/core/services/database/local_database_service.dart';
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
  final LocalDatabaseService _localDatabase;

  const AuthLocalDataSourceImpl({required LocalDatabaseService localDatabase})
    : _localDatabase = localDatabase;

  @override
  FutureBool saveUserData(UserDataResponse userDataModel) async {
    return ErrorHandler.handleException(() async {
      _localDatabase.setString(
        LocalDbKeys.userData,
        jsonEncode(userDataModel.toJson()),
      );
      return const SuccessState(data: true);
    });
  }

  @override
  FutureData<UserDataResponse> getUserData() async {
    return ErrorHandler.handleException(() async {
      String userData = _localDatabase.getString(LocalDbKeys.userData) ?? "";

      if (userData.isNotEmpty) {
        final userDataModel = UserDataResponse.fromJson(jsonDecode(userData));
        return SuccessState(data: userDataModel);
      }
      return const FailureState<UserDataResponse>(
        message: "User data not found.",
      );
    });
  }

  @override
  FutureBool removeUserData() {
    return ErrorHandler.handleException(() async {
      await _localDatabase.remove(LocalDbKeys.userData);
      return const SuccessState(data: true);
    });
  }
}
