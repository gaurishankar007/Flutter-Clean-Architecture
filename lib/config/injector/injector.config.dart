// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:clean_architecture/config/app_config.dart' as _i37;
import 'package:clean_architecture/core/clients/local/local_storage_client.dart'
    as _i1009;
import 'package:clean_architecture/core/clients/remote/http/http_client.dart'
    as _i244;
import 'package:clean_architecture/core/clients/remote/internet_client.dart'
    as _i9;
import 'package:clean_architecture/features/auth/data/data_sources/auth_local_data_source.dart'
    as _i322;
import 'package:clean_architecture/features/auth/data/data_sources/auth_remote_data_source.dart'
    as _i141;
import 'package:clean_architecture/features/auth/data/data_sources/session_local_data_source.dart'
    as _i16;
import 'package:clean_architecture/features/auth/data/repositories/auth_repository_impl.dart'
    as _i526;
import 'package:clean_architecture/features/auth/data/repositories/session_repository_impl.dart'
    as _i943;
import 'package:clean_architecture/features/auth/domain/repositories/auth_repository.dart'
    as _i1003;
import 'package:clean_architecture/features/auth/domain/repositories/session_repository.dart'
    as _i150;
import 'package:clean_architecture/features/auth/domain/use_cases/check_authentication_use_case.dart'
    as _i481;
import 'package:clean_architecture/features/auth/domain/use_cases/get_user_data_use_case.dart'
    as _i817;
import 'package:clean_architecture/features/auth/domain/use_cases/log_out_use_case.dart'
    as _i294;
import 'package:clean_architecture/features/auth/domain/use_cases/login_use_case.dart'
    as _i68;
import 'package:clean_architecture/features/auth/domain/use_cases/save_user_data_use_case.dart'
    as _i661;
import 'package:clean_architecture/features/auth/domain/use_cases/set_session_use_case.dart'
    as _i636;
import 'package:clean_architecture/features/auth/presentation/cubits/login/login_cubit.dart'
    as _i912;
import 'package:clean_architecture/features/auth/presentation/cubits/login/login_cubit_use_cases.dart'
    as _i123;
import 'package:clean_architecture/features/dashboard/presentation/cubits/dashboard/dashboard_cubit.dart'
    as _i278;
import 'package:clean_architecture/features/dashboard/presentation/cubits/dashboard/dashboard_cubit_use_cases.dart'
    as _i134;
import 'package:clean_architecture/routing/helper/navigation_client.dart'
    as _i389;
import 'package:clean_architecture/routing/routes.dart' as _i671;
import 'package:clean_architecture/shared_ui/cubits/screen_observer/screen_observer_cubit.dart'
    as _i640;
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart'
    as _i161;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

const String _staging = 'staging';
const String _development = 'development';
const String _production = 'production';

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> initialize({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final localStorageClientModule = _$LocalStorageClientModule();
    final httpClientModule = _$HttpClientModule();
    final internetClientModule = _$InternetClientModule();
    final navigationClientModule = _$NavigationClientModule();
    await gh.factoryAsync<_i460.SharedPreferences>(
      () => localStorageClientModule.sharedPreferences,
      preResolve: true,
    );
    gh.factory<bool>(() => httpClientModule.addInterceptors);
    gh.factory<_i640.ScreenObserverCubit>(() => _i640.ScreenObserverCubit());
    gh.lazySingleton<_i361.Dio>(() => httpClientModule.dio);
    gh.lazySingleton<_i244.HttpAuthInterceptor>(
      () => _i244.HttpAuthInterceptor(),
    );
    gh.lazySingleton<_i161.InternetConnection>(
      () => internetClientModule.internetConnection,
    );
    gh.lazySingleton<_i671.AppRouter>(() => navigationClientModule.appRouter);
    gh.lazySingleton<_i389.NavigationClient>(
      () => _i389.NavigationClientImpl(appRouter: gh<_i671.AppRouter>()),
    );
    gh.lazySingleton<_i37.AppConfig>(
      () => _i37.AppConfigStg(),
      registerFor: {_staging},
    );
    gh.lazySingleton<_i37.AppConfig>(
      () => _i37.AppConfigDev(),
      registerFor: {_development},
    );
    gh.lazySingleton<_i1009.LocalStorageClient>(
      () => _i1009.LocalStorageClientImpl(
        sharedPreferences: gh<_i460.SharedPreferences>(),
      ),
    );
    gh.lazySingleton<_i322.AuthLocalDataSource>(
      () => _i322.AuthLocalDataSourceImpl(
        localDatabase: gh<_i1009.LocalStorageClient>(),
      ),
    );
    gh.lazySingleton<_i37.AppConfig>(
      () => _i37.AppConfigProd(),
      registerFor: {_production},
    );
    gh.lazySingleton<_i9.InternetClient>(
      () => _i9.InternetClientImpl(
        internetConnection: gh<_i161.InternetConnection>(),
      ),
    );
    gh.lazySingleton<_i16.SessionLocalDataSource>(
      () => _i16.SessionLocalDataSourceImpl(gh<_i1009.LocalStorageClient>()),
    );
    gh.lazySingleton<_i244.HttpClient>(
      () => _i244.HttpClientImpl(
        dio: gh<_i361.Dio>(),
        appConfig: gh<_i37.AppConfig>(),
        authInterceptor: gh<_i244.HttpAuthInterceptor>(),
        navigationClient: gh<_i389.NavigationClient>(),
        addInterceptors: gh<bool>(),
      ),
    );
    gh.lazySingleton<_i141.AuthRemoteDataSource>(
      () => _i141.AuthRemoteDataSourceImpl(dioClient: gh<_i244.HttpClient>()),
    );
    gh.lazySingleton<_i150.SessionRepository>(
      () => _i943.SessionRepositoryImpl(
        localDataSource: gh<_i16.SessionLocalDataSource>(),
      ),
    );
    gh.lazySingleton<_i294.LogOutUseCase>(
      () => _i294.LogOutUseCase(gh<_i150.SessionRepository>()),
    );
    gh.lazySingleton<_i636.SetSessionUseCase>(
      () => _i636.SetSessionUseCase(gh<_i150.SessionRepository>()),
    );
    gh.lazySingleton<_i1003.AuthRepository>(
      () => _i526.AuthRepositoryImpl(
        internet: gh<_i9.InternetClient>(),
        remoteDataSource: gh<_i141.AuthRemoteDataSource>(),
        localDataSource: gh<_i322.AuthLocalDataSource>(),
      ),
    );
    gh.lazySingleton<_i481.CheckAuthenticationUseCase>(
      () => _i481.CheckAuthenticationUseCase(
        authRepository: gh<_i1003.AuthRepository>(),
      ),
    );
    gh.lazySingleton<_i817.GetUserDataUseCase>(
      () =>
          _i817.GetUserDataUseCase(authRepository: gh<_i1003.AuthRepository>()),
    );
    gh.lazySingleton<_i68.LoginUseCase>(
      () => _i68.LoginUseCase(authRepository: gh<_i1003.AuthRepository>()),
    );
    gh.lazySingleton<_i661.SaveUserDataUseCase>(
      () => _i661.SaveUserDataUseCase(
        authRepository: gh<_i1003.AuthRepository>(),
      ),
    );
    gh.lazySingleton<_i134.DashboardCubitUseCases>(
      () => _i134.DashboardCubitUseCases(
        checkAuthentication: gh<_i481.CheckAuthenticationUseCase>(),
        logOut: gh<_i294.LogOutUseCase>(),
      ),
    );
    gh.lazySingleton<_i123.LoginCubitUseCases>(
      () => _i123.LoginCubitUseCases(
        login: gh<_i68.LoginUseCase>(),
        saveUserData: gh<_i661.SaveUserDataUseCase>(),
        setSession: gh<_i636.SetSessionUseCase>(),
        logOut: gh<_i294.LogOutUseCase>(),
      ),
    );
    gh.factory<_i912.LoginCubit>(
      () => _i912.LoginCubit(useCases: gh<_i123.LoginCubitUseCases>()),
    );
    gh.factory<_i278.DashboardCubit>(
      () => _i278.DashboardCubit(useCases: gh<_i134.DashboardCubitUseCases>()),
    );
    return this;
  }
}

class _$LocalStorageClientModule extends _i1009.LocalStorageClientModule {}

class _$HttpClientModule extends _i244.HttpClientModule {}

class _$InternetClientModule extends _i9.InternetClientModule {}

class _$NavigationClientModule extends _i389.NavigationClientModule {}
