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
import 'package:clean_architecture/shared_ui/cubits/base/base_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../testing/mocks/repository_mocks.dart';
import '../../../../../testing/mocks/use_case_mocks.dart';

final locator = GetIt.I;

void main() {
  late MockLoginUseCase mockLoginUseCase;
  late MockSaveUserDataUseCase mockSaveUserDataUseCase;
  late MockSetSessionUseCase mockSetSessionUseCase;
  late MockLogOutUseCase mockLogOutUseCase;
  late MockSessionRepository mockSessionRepository;
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
    registerFallbackValue(userData);
  });

  setUp(() {
    mockSetSessionUseCase = MockSetSessionUseCase();
    mockLoginUseCase = MockLoginUseCase();
    mockSaveUserDataUseCase = MockSaveUserDataUseCase();
    mockLogOutUseCase = MockLogOutUseCase();
    mockSessionRepository = MockSessionRepository();

    locator
      ..registerSingleton<LoginUseCase>(mockLoginUseCase)
      ..registerSingleton<SaveUserDataUseCase>(mockSaveUserDataUseCase)
      ..registerSingleton<SetSessionUseCase>(mockSetSessionUseCase)
      ..registerSingleton<LogOutUseCase>(mockLogOutUseCase)
      ..registerSingleton<SessionRepository>(mockSessionRepository);

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

  group('login', () {
    late bool loginResult;

    blocTest<LoginCubit, LoginState>(
      'returns true and does not save user data by default, without '
      'setting a state message',
      build: () {
        // Arrange
        when(() => mockSetSessionUseCase.call(userData)).thenAnswer((_) {});
        when(
          () => mockLoginUseCase.call(any()),
        ).thenAnswer((_) async => SuccessState(data: userData));

        return loginCubit;
      },
      act: (cubit) async {
        // Act
        loginResult = await cubit.login(username: 'test', password: '123');
      },
      expect: () => [
        const LoginState(passwordVisibility: false, saveUserCredential: false),
      ],
      verify: (_) {
        // Assert
        expect(loginResult, isTrue);
        verify(() => mockLoginUseCase.call(any())).called(1);
        verify(() => mockSetSessionUseCase.call(any())).called(1);
        verifyNever(() => mockSaveUserDataUseCase.call(any()));
      },
    );

    blocTest<LoginCubit, LoginState>(
      'saves user data when saveUserCredential = true',
      build: () {
        // Arrange
        when(() => mockSetSessionUseCase.call(userData)).thenAnswer((_) {});
        when(
          () => mockLoginUseCase.call(any()),
        ).thenAnswer((_) async => SuccessState(data: userData));
        when(
          () => mockSaveUserDataUseCase.call(any()),
        ).thenAnswer((_) async => SuccessState.nil);

        return loginCubit;
      },
      act: (cubit) async {
        // Act
        cubit.toggleUserCredentialSaving();
        loginResult = await cubit.login(username: 'test', password: '123');
      },
      verify: (_) {
        // Assert
        expect(loginResult, isTrue);
        verify(() => mockLoginUseCase.call(any())).called(1);
        verify(() => mockSetSessionUseCase.call(any())).called(1);
        verify(() => mockSaveUserDataUseCase.call(any())).called(1);
      },
    );

    blocTest<LoginCubit, LoginState>(
      'returns false and sets an error message when the login use case '
      'fails, without touching the session',
      build: () {
        // Arrange
        when(() => mockLoginUseCase.call(any())).thenAnswer(
          (_) async => const FailureState(message: 'Invalid credentials'),
        );

        return loginCubit;
      },
      act: (cubit) async {
        // Act
        loginResult = await cubit.login(username: 'test', password: '123');
      },
      expect: () => [
        const LoginState(
          passwordVisibility: false,
          saveUserCredential: false,
          message: ErrorMessage('Invalid credentials'),
        ),
      ],
      verify: (_) {
        // Assert
        expect(loginResult, isFalse);
        verify(() => mockLoginUseCase.call(any())).called(1);
        verifyNever(() => mockSetSessionUseCase.call(any()));
        verifyNever(() => mockSaveUserDataUseCase.call(any()));
      },
    );
  });
}
