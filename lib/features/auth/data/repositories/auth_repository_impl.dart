import 'package:clean_architecture/core/data_handling/data_handler.dart';
import 'package:clean_architecture/core/domain/entities/user_data.dart';
import 'package:clean_architecture/core/services/internet/internet_service.dart';
import 'package:clean_architecture/core/utils/type_defs.dart';
import 'package:clean_architecture/features/auth/data/data_sources/auth_local_data_source.dart';
import 'package:clean_architecture/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:clean_architecture/features/auth/data/models/requests/authentication_request.dart';
import 'package:clean_architecture/features/auth/data/models/responses/user_data_response.dart';
import 'package:clean_architecture/features/auth/domain/entities/authentication.dart';
import 'package:clean_architecture/features/auth/domain/repositories/auth_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: AuthRepository)
final class AuthRepositoryImpl implements AuthRepository {
  final InternetService _internet;
  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;

  AuthRepositoryImpl({
    required InternetService internet,
    required AuthRemoteDataSource remoteDataSource,
    required AuthLocalDataSource localDataSource,
  }) : _localDataSource = localDataSource,
       _remoteDataSource = remoteDataSource,
       _internet = internet;

  @override
  FutureData<UserData> login(Authentication authentication) {
    return DataHandler.fetchWithFallbackAndMap(
      _internet.isConnected,
      remoteCallback: () => _remoteDataSource.login(
        AuthenticationRequest.fromDomain(authentication),
      ),
    );
  }

  @override
  FutureBool saveUserData(UserData userData) =>
      _localDataSource.saveUserData(UserDataResponse.fromDomain(userData));

  @override
  FutureData<UserData> getUserData() {
    return DataHandler.fetchFromLocalAndMap(
      localCallback: _localDataSource.getUserData,
    );
  }

  @override
  FutureBool checkAuth() {
    return DataHandler.fetchWithFallback(
      _internet.isConnected,
      remoteCallback: () => _remoteDataSource.checkAUth(),
    );
  }

  @override
  FutureBool removeUserData() => _localDataSource.removeUserData();
}
