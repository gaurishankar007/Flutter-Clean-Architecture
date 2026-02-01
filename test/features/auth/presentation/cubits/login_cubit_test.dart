import 'package:bloc_test/bloc_test.dart';
import 'package:clean_architecture/core/data/states/data_state.dart';
import 'package:clean_architecture/core/domain/entities/user.dart';
import 'package:clean_architecture/core/domain/entities/user_data.dart';
import 'package:clean_architecture/features/auth/domain/entities/authentication.dart';
import 'package:clean_architecture/features/auth/domain/repositories/session_repository.dart';
import 'package:clean_architecture/features/auth/domain/use_cases/log_out_use_case.dart';
import 'package:clean_architecture/features/auth/domain/use_cases/login_use_case.dart';
import 'package:clean_architecture/features/auth/domain/use_cases/save_user_data_use_case.dart';
import 'package:clean_architecture/features/auth/domain/use_cases/set_session_use_case.dart';
import 'package:clean_architecture/features/auth/presentation/cubits/login/login_cubit.dart';
import 'package:clean_architecture/features/auth/presentation/cubits/login/login_cubit_use_cases.dart';
import 'package:clean_architecture/routing/helper/navigation_client.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../testing/mocks/client_mocks.dart';
import '../../../../../testing/mocks/external/router_mocks.dart';
import '../../../../../testing/mocks/repository_mocks.dart';
import '../../../../../testing/mocks/use_case_mocks.dart';

final locator = GetIt.I;

void main() {
  late MockLoginUseCase mockLoginUseCase;
  late MockSaveUserDataUseCase mockSaveUserDataUseCase;
  late MockSetSessionUseCase mockSetSessionUseCase;
  late MockLogOutUseCase mockLogOutUseCase;
  late MockSessionRepository mockSessionRepository;
  late MockNavigationClient mockNavigationClient;
  late LoginCubit loginCubit;
  late UserData userData;

  setUpAll(() {
    userData = const UserData(
      user: User(
        id: 0,
        firstName: '',
        lastName: '',
        username: '',
        email: '',
        isActive: true,
      ),
      accessToken: '',
      refreshToken: '',
    );
    registerFallbackValue(const Authentication(username: '', password: ''));
    registerFallbackValue(const MockPageRouteInfo());
    registerFallbackValue(userData);
  });

  setUp(() {
    mockSetSessionUseCase = MockSetSessionUseCase();
    mockLoginUseCase = MockLoginUseCase();
    mockSaveUserDataUseCase = MockSaveUserDataUseCase();
    mockLogOutUseCase = MockLogOutUseCase();
    mockSessionRepository = MockSessionRepository();
    mockNavigationClient = MockNavigationClient();

    locator
      ..registerSingleton<LoginUseCase>(mockLoginUseCase)
      ..registerSingleton<SaveUserDataUseCase>(mockSaveUserDataUseCase)
      ..registerSingleton<SetSessionUseCase>(mockSetSessionUseCase)
      ..registerSingleton<LogOutUseCase>(mockLogOutUseCase)
      ..registerSingleton<SessionRepository>(mockSessionRepository)
      ..registerSingleton<NavigationClient>(mockNavigationClient);

    final useCases = LoginCubitUseCases(
      login: mockLoginUseCase,
      saveUserData: mockSaveUserDataUseCase,
      setSession: mockSetSessionUseCase,
      logOut: mockLogOutUseCase,
    );
    loginCubit = LoginCubit(useCases: useCases);
  });

  tearDown(locator.reset);

  blocTest<LoginCubit, LoginState>(
    'togglePasswordVisibility should flip passwordVisibility state',
    build: () => loginCubit,
    act: (cubit) => cubit.togglePasswordVisibility(),
    expect: () => [
      const LoginState(passwordVisibility: true, saveUserCredential: false),
    ],
  );

  blocTest<LoginCubit, LoginState>(
    'toggleUserCredentialSaving should flip saveUserCredential state',
    build: () => loginCubit,
    act: (cubit) => cubit.toggleUserCredentialSaving(),
    expect: () => [
      const LoginState(passwordVisibility: false, saveUserCredential: true),
    ],
  );

  blocTest<LoginCubit, LoginState>(
    'login should call login use case and navigate without saving user data',
    build: () {
      // Arrange
      when(() => mockSetSessionUseCase.call(userData)).thenAnswer((_) {});
      when(() => mockNavigationClient.replaceAllRoute(any())).thenAnswer((
        _,
      ) async {
        return;
      });
      when(
        () => mockLoginUseCase.call(any()),
      ).thenAnswer((_) async => SuccessState(data: userData));

      return loginCubit;
    },
    act: (cubit) async {
      // Act
      await cubit.login(username: 'test', password: '123');
    },
    verify: (_) {
      // Assert
      verify(() => mockLoginUseCase.call(any())).called(1);
      verify(() => mockSetSessionUseCase.call(any())).called(1);
      verify(() => mockNavigationClient.replaceAllRoute(any())).called(1);
      verifyNever(() => mockSaveUserDataUseCase.call(any()));
    },
  );

  blocTest<LoginCubit, LoginState>(
    'login should save user data when saveUserCredential = true',
    build: () {
      // Arrange
      when(() => mockSetSessionUseCase.call(userData)).thenAnswer((_) {});
      when(() => mockNavigationClient.replaceAllRoute(any())).thenAnswer((
        _,
      ) async {
        return;
      });
      when(
        () => mockLoginUseCase.call(any()),
      ).thenAnswer((_) async => SuccessState(data: userData));
      when(
        () => mockSaveUserDataUseCase.call(any()),
      ).thenAnswer((_) async => const SuccessState(data: true));

      return loginCubit;
    },
    act: (cubit) async {
      // Act
      cubit.toggleUserCredentialSaving();
      await cubit.login(username: 'test', password: '123');
    },
    verify: (_) {
      // Assert
      verify(() => mockLoginUseCase.call(any())).called(1);
      verify(() => mockSetSessionUseCase.call(any())).called(1);
      verify(() => mockSaveUserDataUseCase.call(any())).called(1);
      verify(() => mockNavigationClient.replaceAllRoute(any())).called(1);
    },
  );
}
