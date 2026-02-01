import 'package:clean_architecture/core/clients/remote/http/http_client.dart';
import 'package:clean_architecture/core/constants/api_endpoints.dart';
import 'package:clean_architecture/core/data/handlers/api_handler.dart';
import 'package:clean_architecture/core/utils/type_defs.dart';
import 'package:clean_architecture/features/auth/data/models/requests/authentication_request.dart';
import 'package:clean_architecture/features/auth/data/models/responses/user_data_response.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

abstract interface class AuthRemoteDataSource {
  FutureData<UserDataResponse> login(AuthenticationRequest request);
  FutureBool checkAUth();
}

@LazySingleton(as: AuthRemoteDataSource)
final class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  const AuthRemoteDataSourceImpl({required HttpClient dioClient})
    : _dioClient = dioClient;
  final HttpClient _dioClient;

  @override
  FutureData<UserDataResponse> login(AuthenticationRequest request) {
    return ApiHandler.call(
      () => _dioClient.post(
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
    return ApiHandler.call(
      () => _dioClient.get(ApiEndpoints.checkAuth),
      fromJson: (json) => true,
    );
  }
}
