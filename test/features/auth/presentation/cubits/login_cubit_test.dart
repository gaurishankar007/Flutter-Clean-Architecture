import 'package:bloc_test/bloc_test.dart';
import 'package:clean_architecture/core/data_states/data_state.dart';
import 'package:clean_architecture/core/domain/entities/user.dart';
import 'package:clean_architecture/core/domain/entities/user_data.dart';
import 'package:clean_architecture/core/services/image_picker/image_picker_service.dart';
import 'package:clean_architecture/core/services/navigation/navigation_service.dart';
import 'package:clean_architecture/core/services/session/session_service.dart';
import 'package:clean_architecture/features/auth/domain/entities/authentication.dart';
import 'package:clean_architecture/features/auth/domain/use_cases/login_use_case.dart';
import 'package:clean_architecture/features/auth/domain/use_cases/save_user_data_use_case.dart';
import 'package:clean_architecture/features/auth/presentation/cubits/login/login_cubit.dart';
import 'package:clean_architecture/features/auth/presentation/cubits/login/login_cubit_use_cases.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../testing/mocks/external/router_mocks.dart';
import '../../../../../testing/mocks/service_mocks.dart';
import '../../../../../testing/mocks/use_case_mocks.dart';

final locator = GetIt.I;

void main() {
  late MockLoginUseCase mockLoginUseCase;
  late MockSaveUserDataUseCase mockSaveUserDataUseCase;
  late MockSessionService mockSessionService;
  late MockNavigationService mockNavigationService;
  late MockImagePickerService mockImagePickerService;
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
    mockLoginUseCase = MockLoginUseCase();
    mockSaveUserDataUseCase = MockSaveUserDataUseCase();
    mockSessionService = MockSessionService();
    mockNavigationService = MockNavigationService();
    mockImagePickerService = MockImagePickerService();

    locator
      ..registerSingleton<LoginUseCase>(mockLoginUseCase)
      ..registerSingleton<SaveUserDataUseCase>(mockSaveUserDataUseCase)
      ..registerSingleton<SessionService>(mockSessionService)
      ..registerSingleton<NavigationService>(mockNavigationService)
      ..registerSingleton<ImagePickerService>(mockImagePickerService);

    final useCases = LoginCubitUseCases(
      login: mockLoginUseCase,
      saveUserData: mockSaveUserDataUseCase,
    );
    loginCubit = LoginCubit(
      sessionService: GetIt.I<SessionService>(),
      useCases: useCases,
    );
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
      when(
        () => mockSessionService.setUserData = userData,
      ).thenAnswer((_) => userData);
      when(
        () => mockNavigationService.replaceAllRoute(any()),
      ).thenAnswer((_) async {});
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
      verify(() => mockSessionService.setUserData = any()).called(1);
      verify(() => mockNavigationService.replaceAllRoute(any())).called(1);
      verifyNever(() => mockSaveUserDataUseCase.call(any()));
    },
  );

  blocTest<LoginCubit, LoginState>(
    'login should save user data when saveUserCredential = true',
    build: () {
      // Arrange
      when(
        () => mockSessionService.setUserData = userData,
      ).thenAnswer((_) => userData);
      when(
        () => mockNavigationService.replaceAllRoute(any()),
      ).thenAnswer((_) async {});
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
      verify(() => mockSessionService.setUserData = any()).called(1);
      verify(() => mockSaveUserDataUseCase.call(any())).called(1);
      verify(() => mockNavigationService.replaceAllRoute(any())).called(1);
    },
  );
}
