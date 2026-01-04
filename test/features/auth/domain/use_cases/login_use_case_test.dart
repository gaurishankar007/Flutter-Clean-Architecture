import 'package:clean_architecture/core/data/states/data_state.dart';
import 'package:clean_architecture/core/domain/entities/user.dart';
import 'package:clean_architecture/core/domain/entities/user_data.dart';
import 'package:clean_architecture/features/auth/domain/entities/authentication.dart';
import 'package:clean_architecture/features/auth/domain/use_cases/login_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../testing/mocks/repository_mocks.dart';

void main() {
  late LoginUseCase useCase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    useCase = LoginUseCase(authRepository: mockAuthRepository);
    registerFallbackValue(const Authentication(username: '', password: ''));
  });

  const tAuthentication = Authentication(
    username: 'test',
    password: 'password',
  );
  const tUser = User(
    id: 1,
    firstName: 'Test',
    lastName: 'User',
    username: 'testuser',
    email: 'test@example.com',
    isActive: true,
  );
  const tUserData = UserData(
    user: tUser,
    accessToken: 'access',
    refreshToken: 'refresh',
  );

  test(
    'should call authRepository.login and return user data on success',
    () async {
      // Arrange
      when(
        () => mockAuthRepository.login(any()),
      ).thenAnswer((_) async => const SuccessState(data: tUserData));

      // Act
      final result = await useCase(tAuthentication);

      // Assert
      expect(result, isA<SuccessState<UserData>>());
      expect(result.data, tUserData);
      verify(() => mockAuthRepository.login(tAuthentication)).called(1);
      verifyNoMoreInteractions(mockAuthRepository);
    },
  );

  test('should return a FailureState when the repository call fails', () async {
    // Arrange
    const tFailureState = FailureState<UserData>(message: 'Login Failed');
    when(
      () => mockAuthRepository.login(any()),
    ).thenAnswer((_) async => tFailureState);

    // Act
    final result = await useCase(tAuthentication);

    // Assert
    expect(result, isA<FailureState<UserData>>());
    expect(result.message, 'Login Failed');
    verify(() => mockAuthRepository.login(tAuthentication)).called(1);
    verifyNoMoreInteractions(mockAuthRepository);
  });
}
