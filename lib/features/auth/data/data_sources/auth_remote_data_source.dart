import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/data_handling/data_handler.dart';
import '../../../../core/services/api/api_service.dart';
import '../../../../core/utils/type_defs.dart';
import '../models/requests/authentication_request.dart';
import '../models/responses/user_data_response.dart';

abstract interface class AuthRemoteDataSource {
  FutureData<UserDataResponse> login(AuthenticationRequest request);
  FutureBool checkAUth();
}

@LazySingleton(as: AuthRemoteDataSource)
final class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiService _dioClient;

  const AuthRemoteDataSourceImpl({required ApiService dioClient})
    : _dioClient = dioClient;

  @override
  FutureData<UserDataResponse> login(AuthenticationRequest request) {
    return DataHandler.safeApiCall(
      request: () => _dioClient.post(
        ApiEndpoints.login,
        data: request.toJson(),
        options: Options(
          validateStatus: (status) => status == 200 || status == 400,
        ),
      ),
      fromJson: UserDataResponse.fromJson,
    );
  }

  @override
  FutureBool checkAUth() {
    return DataHandler.safeApiCall(
      request: () => _dioClient.get(ApiEndpoints.checkAuth),
      fromJson: (json) => true,
    );
  }
}
