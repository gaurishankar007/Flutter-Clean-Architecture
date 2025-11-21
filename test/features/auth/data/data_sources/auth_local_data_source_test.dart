import 'dart:convert';

import 'package:clean_architecture/core/data/models/responses/user_response.dart';
import 'package:clean_architecture/core/data_states/data_state.dart';
import 'package:clean_architecture/features/auth/data/data_sources/auth_local_data_source.dart';
import 'package:clean_architecture/features/auth/data/models/responses/user_data_response.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../testing/mocks/service_mocks.dart';

void main() {
  late MockLocalDatabaseService mockLocalDatabase;
  late AuthLocalDataSourceImpl dataSource;

  setUp(() {
    mockLocalDatabase = MockLocalDatabaseService();
    dataSource = AuthLocalDataSourceImpl(localDatabase: mockLocalDatabase);
  });

  const tStorageKey = 'userData';

  const userModel = UserResponse(
    id: 1,
    firstName: 'Test',
    lastName: 'User',
    username: 'testuser',
    email: 'test@example.com',
    isActive: true,
  );

  // Assuming UserDataModel has a constructor like this and a toJson method.
  final tUserDataModel = UserDataResponse(
    user: userModel,
    accessToken: "access",
    refreshToken: "refresh",
  );

  final tUserDataJson = jsonEncode({
    'user': userModel.toJson(),
    'access': "access",
    'refresh': "refresh",
  });

  group('saveUserData', () {
    test(
      'should return SuccessState(true) when data is saved successfully',
      () async {
        // Arrange
        when(
          () => mockLocalDatabase.setString(any(), any()),
        ).thenAnswer((_) async => true);

        // Act
        final result = await dataSource.saveUserData(tUserDataModel);

        // Assert
        expect(result, isA<SuccessState<bool>>());
        expect(result.data, isTrue);
      },
    );

    test(
      'should return FailureState when saving throws an exception',
      () async {
        // Arrange
        final exception = Exception('Failed to save');
        when(
          () => mockLocalDatabase.setString(any(), any()),
        ).thenThrow(exception);

        // Act
        final result = await dataSource.saveUserData(tUserDataModel);

        // Assert
        expect(result, isA<FailureState>());
      },
    );
  });

  group('getUserData', () {
    test(
      'should return SuccessState with UserDataModel when data is found',
      () async {
        // Arrange
        when(
          () => mockLocalDatabase.getString(tStorageKey),
        ).thenAnswer((_) => tUserDataJson);

        // Act
        final result = await dataSource.getUserData();

        // Assert
        expect(result, isA<SuccessState<UserDataResponse>>());
        expect(result.data, isNotNull);
        expect(result.data!.user.id, userModel.id);
        expect(result.data!.accessToken, "access");
        verify(() => mockLocalDatabase.getString(tStorageKey)).called(1);
      },
    );

    test('should return FailureState when no data is found (null)', () async {
      // Arrange
      when(
        () => mockLocalDatabase.getString(tStorageKey),
      ).thenAnswer((_) => null);

      // Act
      final result = await dataSource.getUserData();

      // Assert
      expect(result, isA<FailureState<UserDataResponse>>());
    });

    test(
      'should return FailureState when getting data throws an exception',
      () async {
        // Arrange
        final exception = Exception('Failed to read');
        when(
          () => mockLocalDatabase.getString(tStorageKey),
        ).thenThrow(exception);

        // Act
        final result = await dataSource.getUserData();

        // Assert
        expect(result, isA<FailureState>());
      },
    );
  });

  group('removeUserData', () {
    test(
      'should return SuccessState(true) when data is removed successfully',
      () async {
        // Arrange
        when(
          () => mockLocalDatabase.remove(tStorageKey),
        ).thenAnswer((_) async => true);

        // Act
        final result = await dataSource.removeUserData();

        // Assert
        expect(result, isA<SuccessState<bool>>());
        expect(result.data, isTrue);
        verify(() => mockLocalDatabase.remove(tStorageKey)).called(1);
      },
    );

    test(
      'should return FailureState when removing data throws an exception',
      () async {
        // Arrange
        final exception = Exception('Failed to remove');
        when(() => mockLocalDatabase.remove(tStorageKey)).thenThrow(exception);

        // Act
        final result = await dataSource.removeUserData();

        // Assert
        expect(result, isA<FailureState>());
      },
    );
  });
}
