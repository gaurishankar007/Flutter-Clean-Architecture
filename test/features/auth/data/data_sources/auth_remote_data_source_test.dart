import 'package:clean_architecture/core/constants/api_endpoints.dart';
import 'package:clean_architecture/core/data/states/data_state.dart';
import 'package:clean_architecture/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:clean_architecture/features/auth/data/models/requests/authentication_request.dart';
import 'package:clean_architecture/features/auth/data/models/responses/user_data_response.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../testing/mocks/client_mocks.dart';

// A mock for Options is needed for `captureAny` with mocktail
class MockOptions extends Mock implements Options {}

void main() {
  late MockHttpClient mockHttpClient;
  late AuthRemoteDataSourceImpl dataSource;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = AuthRemoteDataSourceImpl(dioClient: mockHttpClient);
    registerFallbackValue(MockOptions());
  });

  group('login', () {
    const tAuthenticationRequest = AuthenticationRequest(
      username: 'test',
      password: 'password',
    );

    // Assuming AuthenticationRequest has a toJson method like this
    final tAuthenticationRequestJson = tAuthenticationRequest.toJson();

    final tSuccessResponseJson = {
      'data': {
        'user': {
          'id': 1,
          'first_name': 'Test',
          'last_name': 'User',
          'username': 'test user',
          'email': 'test@example.com',
          'is_active': true,
        },
        'access': 'access',
        'refresh': 'refresh',
      },
      'message': 'Login successful',
    };

    test(
      'should return SuccessState with UserDataModel when API call is successful (200)',
      () async {
        // Arrange
        when(
          () => mockHttpClient.post<dynamic>(
            any(),
            data: any(named: 'data'),
            options: any(named: 'options'),
          ),
        ).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(path: ApiEndpoints.login),
            data: tSuccessResponseJson,
            statusCode: 200,
          ),
        );

        // Act
        final result = await dataSource.login(tAuthenticationRequest);

        // Assert
        expect(result, isA<SuccessState<UserDataResponse>>());
        expect(result.data, isNotNull);
        expect(result.data!.user.id, 1);
        expect(result.data!.accessToken, 'access');
        expect(result.data!.refreshToken, 'refresh');

        final captured = verify(
          () => mockHttpClient.post<dynamic>(
            ApiEndpoints.login,
            data: captureAny(named: 'data'),
            options: captureAny(named: 'options'),
          ),
        ).captured;

        expect(captured[0], tAuthenticationRequestJson);
        final options = captured[1] as Options;
        expect(options.validateStatus!(200), isTrue);
        expect(options.validateStatus!(400), isTrue);
      },
    );

    test('should return FailureState when API returns 400', () async {
      // Arrange
      // This response is missing the 'data' key, which DataHandler will flag as an error.
      final tErrorResponseJson = {'message': 'Invalid credentials'};
      when(
        () => mockHttpClient.post<dynamic>(
          any(),
          data: any(named: 'data'),
          options: any(named: 'options'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: ApiEndpoints.login),
          data: tErrorResponseJson,
          statusCode: 400,
        ),
      );

      // Act
      final result = await dataSource.login(tAuthenticationRequest);

      // Assert
      expect(result, isA<FailureState<UserDataResponse>>());
    });

    test(
      'should return FailureState when API call throws a DioException',
      () async {
        // Arrange
        final dioException = DioException(
          requestOptions: RequestOptions(path: ApiEndpoints.login),
          message: 'Connection failed',
        );
        when(
          () => mockHttpClient.post<dynamic>(
            any(),
            data: any(named: 'data'),
            options: any(named: 'options'),
          ),
        ).thenThrow(dioException);

        // Act
        final result = await dataSource.login(tAuthenticationRequest);

        // Assert
        expect(result, isA<FailureState<UserDataResponse>>());
      },
    );
  });

  group('checkAuth', () {
    test(
      'should return SuccessState with true when API call is successful',
      () async {
        // Arrange
        when(() => mockHttpClient.get<dynamic>(any())).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(path: ApiEndpoints.checkAuth),
            data: {
              'data': {'ab': true},
              'message': 'Authenticated',
            },
            statusCode: 200,
          ),
        );

        // Act
        final result = await dataSource.checkAUth();

        // Assert
        expect(result, isA<SuccessState<bool>>());
        expect(result.data, isTrue);
        verify(
          () => mockHttpClient.get<dynamic>(ApiEndpoints.checkAuth),
        ).called(1);
      },
    );

    test(
      'should return FailureState when API call throws a DioException',
      () async {
        // Arrange
        final dioException = DioException(
          requestOptions: RequestOptions(path: ApiEndpoints.checkAuth),
          message: 'Not authenticated',
        );
        when(() => mockHttpClient.get<dynamic>(any())).thenThrow(dioException);

        // Act
        final result = await dataSource.checkAUth();

        // Assert
        expect(result, isA<FailureState<bool>>());
      },
    );
  });
}
