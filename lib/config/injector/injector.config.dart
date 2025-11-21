// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:clean_architecture/config/app_config.dart' as _i37;
import 'package:clean_architecture/core/services/api/api_service.dart' as _i885;
import 'package:clean_architecture/core/services/database/local_database_service.dart'
    as _i87;
import 'package:clean_architecture/core/services/image_picker/image_picker_service.dart'
    as _i257;
import 'package:clean_architecture/core/services/internet/internet_service.dart'
    as _i662;
import 'package:clean_architecture/core/services/navigation/navigation_service.dart'
    as _i1005;
import 'package:clean_architecture/core/services/session/session_service.dart'
    as _i497;
import 'package:clean_architecture/features/auth/data/data_sources/auth_local_data_source.dart'
    as _i322;
import 'package:clean_architecture/features/auth/data/data_sources/auth_remote_data_source.dart'
    as _i141;
import 'package:clean_architecture/features/auth/data/repositories/auth_repository_impl.dart'
    as _i526;
import 'package:clean_architecture/features/auth/domain/repositories/auth_repository.dart'
    as _i1003;
import 'package:clean_architecture/features/auth/domain/use_cases/check_authentication_use_case.dart'
    as _i481;
import 'package:clean_architecture/features/auth/domain/use_cases/get_user_data_use_case.dart'
    as _i817;
import 'package:clean_architecture/features/auth/domain/use_cases/login_use_case.dart'
    as _i68;
import 'package:clean_architecture/features/auth/domain/use_cases/save_user_data_use_case.dart'
    as _i661;
import 'package:clean_architecture/features/auth/presentation/cubits/login/login_cubit.dart'
    as _i912;
import 'package:clean_architecture/features/auth/presentation/cubits/login/login_cubit_use_cases.dart'
    as _i123;
import 'package:clean_architecture/features/dashboard/presentation/cubits/dashboard/dashboard_cubit.dart'
    as _i278;
import 'package:clean_architecture/features/dashboard/presentation/cubits/dashboard/dashboard_cubit_use_cases.dart'
    as _i134;
import 'package:clean_architecture/routing/routes.dart' as _i671;
import 'package:clean_architecture/shared_ui/cubits/screen_observer/screen_observer_cubit.dart'
    as _i640;
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:image_picker/image_picker.dart' as _i183;
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
    final localDatabaseServiceModule = _$LocalDatabaseServiceModule();
    final apiServiceModule = _$ApiServiceModule();
    final navigationServiceModule = _$NavigationServiceModule();
    final imagePickerServiceModule = _$ImagePickerServiceModule();
    final internetServiceModule = _$InternetServiceModule();
    gh.factory<_i640.ScreenObserverCubit>(() => _i640.ScreenObserverCubit());
    await gh.factoryAsync<_i460.SharedPreferences>(
      () => localDatabaseServiceModule.sharedPreferences,
      preResolve: true,
    );
    gh.factory<bool>(() => apiServiceModule.addInterceptors);
    gh.lazySingleton<_i671.AppRouter>(() => navigationServiceModule.appRouter);
    gh.lazySingleton<_i183.ImagePicker>(
      () => imagePickerServiceModule.imagePicker,
    );
    gh.lazySingleton<_i161.InternetConnection>(
      () => internetServiceModule.internetConnection,
    );
    gh.lazySingleton<_i361.Dio>(() => apiServiceModule.dio);
    gh.lazySingleton<_i885.AuthInterceptor>(() => _i885.AuthInterceptor());
    gh.lazySingleton<_i257.ImagePickerService>(
      () => _i257.ImagePickerServiceImpl(imagePicker: gh<_i183.ImagePicker>()),
    );
    gh.lazySingleton<_i37.AppConfig>(
      () => _i37.AppConfigStg(),
      registerFor: {_staging},
    );
    gh.lazySingleton<_i1005.NavigationService>(
      () => _i1005.NavigationServiceImpl(appRouter: gh<_i671.AppRouter>()),
    );
    gh.lazySingleton<_i662.InternetService>(
      () => _i662.InternetServiceImpl(
        internetConnection: gh<_i161.InternetConnection>(),
      ),
    );
    gh.lazySingleton<_i37.AppConfig>(
      () => _i37.AppConfigDev(),
      registerFor: {_development},
    );
    gh.lazySingleton<_i87.LocalDatabaseService>(
      () => _i87.LocalDatabaseServiceImpl(
        sharedPreferences: gh<_i460.SharedPreferences>(),
      ),
    );
    gh.lazySingleton<_i37.AppConfig>(
      () => _i37.AppConfigProd(),
      registerFor: {_production},
    );
    gh.lazySingleton<_i497.SessionService>(
      () => _i497.SessionServiceImpl(
        localDatabase: gh<_i87.LocalDatabaseService>(),
        navigationService: gh<_i1005.NavigationService>(),
      ),
    );
    gh.lazySingleton<_i322.AuthLocalDataSource>(
      () => _i322.AuthLocalDataSourceImpl(
        localDatabase: gh<_i87.LocalDatabaseService>(),
      ),
    );
    gh.lazySingleton<_i885.ApiService>(
      () => _i885.ApiServiceImpl(
        dio: gh<_i361.Dio>(),
        appConfig: gh<_i37.AppConfig>(),
        authInterceptor: gh<_i885.AuthInterceptor>(),
        navigationService: gh<_i1005.NavigationService>(),
        addInterceptors: gh<bool>(),
      ),
    );
    gh.lazySingleton<_i141.AuthRemoteDataSource>(
      () => _i141.AuthRemoteDataSourceImpl(dioClient: gh<_i885.ApiService>()),
    );
    gh.lazySingleton<_i1003.AuthRepository>(
      () => _i526.AuthRepositoryImpl(
        internet: gh<_i662.InternetService>(),
        remoteDataSource: gh<_i141.AuthRemoteDataSource>(),
        localDataSource: gh<_i322.AuthLocalDataSource>(),
      ),
    );
    gh.lazySingleton<_i817.GetUserDataUseCase>(
      () =>
          _i817.GetUserDataUseCase(authRepository: gh<_i1003.AuthRepository>()),
    );
    gh.lazySingleton<_i661.SaveUserDataUseCase>(
      () => _i661.SaveUserDataUseCase(
        authRepository: gh<_i1003.AuthRepository>(),
      ),
    );
    gh.lazySingleton<_i481.CheckAuthenticationUseCase>(
      () => _i481.CheckAuthenticationUseCase(
        authRepository: gh<_i1003.AuthRepository>(),
      ),
    );
    gh.lazySingleton<_i68.LoginUseCase>(
      () => _i68.LoginUseCase(authRepository: gh<_i1003.AuthRepository>()),
    );
    gh.lazySingleton<_i134.DashboardCubitUseCases>(
      () => _i134.DashboardCubitUseCases(
        checkAuthentication: gh<_i481.CheckAuthenticationUseCase>(),
      ),
    );
    gh.lazySingleton<_i123.LoginCubitUseCases>(
      () => _i123.LoginCubitUseCases(
        login: gh<_i68.LoginUseCase>(),
        saveUserData: gh<_i661.SaveUserDataUseCase>(),
      ),
    );
    gh.factory<_i278.DashboardCubit>(
      () => _i278.DashboardCubit(useCases: gh<_i134.DashboardCubitUseCases>()),
    );
    gh.factory<_i912.LoginCubit>(
      () => _i912.LoginCubit(
        sessionService: gh<_i497.SessionService>(),
        useCases: gh<_i123.LoginCubitUseCases>(),
      ),
    );
    return this;
  }
}

class _$LocalDatabaseServiceModule extends _i87.LocalDatabaseServiceModule {}

class _$ApiServiceModule extends _i885.ApiServiceModule {}

class _$NavigationServiceModule extends _i1005.NavigationServiceModule {}

class _$ImagePickerServiceModule extends _i257.ImagePickerServiceModule {}

class _$InternetServiceModule extends _i662.InternetServiceModule {}
