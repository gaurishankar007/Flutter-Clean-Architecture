import 'package:clean_architecture/core/data/handlers/data_handler.dart';
import 'package:clean_architecture/core/data/models/domain_convertible.dart';
import 'package:clean_architecture/core/data/states/data_state.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockResponse<T> extends Mock implements Response<T> {}

class FakeDto implements DomainConvertible<String> {
  FakeDto(this.value);
  final int value;

  @override
  String toDomain() => 'Mapped: $value';
}

void main() {
  group('DataHandler.fetchWithFallback', () {
    test('returns remote data when online', () async {
      final result = await DataHandler.fetchWithFallback<int>(
        isInternetConnected: true,
        remoteCallback: () async => const SuccessState(data: 42),
      );
      expect(result, isA<SuccessState<int>>());
      expect(result.data, 42);
    });

    test('calls onRemoteSuccess when data is present', () async {
      int? callbackValue;
      await DataHandler.fetchWithFallback<int>(
        isInternetConnected: true,
        remoteCallback: () async => const SuccessState(data: 99),
        onRemoteSuccess: (data) => callbackValue = data,
      );
      expect(callbackValue, 99);
    });

    test('does not call onRemoteSuccess when data is null', () async {
      var wasCalled = false;
      await DataHandler.fetchWithFallback<int>(
        isInternetConnected: true,
        remoteCallback: () async => const SuccessState(data: null),
        onRemoteSuccess: (data) => wasCalled = true,
      );
      expect(wasCalled, false);
    });

    test(
      'returns local data when offline and localCallback is provided',
      () async {
        final result = await DataHandler.fetchWithFallback<String>(
          isInternetConnected: false,
          remoteCallback: () async => const SuccessState(data: 'remote'),
          localCallback: () async => const SuccessState(data: 'local'),
        );
        expect(result, isA<SuccessState<String>>());
        expect(result.data, 'local');
      },
    );

    test('returns NoInternetState when offline and no localCallback', () async {
      final result = await DataHandler.fetchWithFallback<double>(
        isInternetConnected: false,
        remoteCallback: () async => const SuccessState(data: 1),
      );
      expect(result.errorType, ErrorType.internetError);
    });

    test('returns remote failure state when remote call fails', () async {
      final result = await DataHandler.fetchWithFallback<String>(
        isInternetConnected: true,
        remoteCallback: () async => const FailureState(message: 'Remote error'),
      );
      expect(result, isA<FailureState<String>>());
      expect(result.message, 'Remote error');
    });
  });

  group('DataHandler.fetchWithFallbackAndMap', () {
    test('maps remote data successfully when online', () async {
      final result = await DataHandler.fetchWithFallbackAndMap<FakeDto, String>(
        isInternetConnected: true,
        remoteCallback: () async => SuccessState(data: FakeDto(42)),
      );
      expect(result, isA<SuccessState<String>>());
      expect(result.data, 'Mapped: 42');
    });

    test('calls onRemoteSuccess with raw data before mapping', () async {
      FakeDto? rawData;
      final result = await DataHandler.fetchWithFallbackAndMap<FakeDto, String>(
        isInternetConnected: true,
        remoteCallback: () async => SuccessState(data: FakeDto(99)),
        onRemoteSuccess: (data) => rawData = data,
      );
      expect(rawData?.value, 99);
      expect(result.data, 'Mapped: 99');
    });

    test('maps local data when offline', () async {
      final result = await DataHandler.fetchWithFallbackAndMap<FakeDto, String>(
        isInternetConnected: false,
        remoteCallback: () async => SuccessState(data: FakeDto(100)),
        localCallback: () async => SuccessState(data: FakeDto(50)),
      );
      expect(result, isA<SuccessState<String>>());
      expect(result.data, 'Mapped: 50');
    });

    test('returns failure state when both remote and local fail', () async {
      final result = await DataHandler.fetchWithFallbackAndMap<FakeDto, String>(
        isInternetConnected: false,
        remoteCallback: () async => const FailureState(message: 'Remote error'),
        localCallback: () async => const FailureState(message: 'Local error'),
      );
      expect(result, isA<FailureState<String>>());
      expect(result.message, 'Local error');
    });
  });

  group('DataHandler.fetchWithFallbackAndMapList', () {
    test('maps remote list data successfully when online', () async {
      final result =
          await DataHandler.fetchWithFallbackAndMapList<FakeDto, String>(
            isInternetConnected: true,
            remoteCallback: () async =>
                SuccessState(data: [FakeDto(1), FakeDto(2)]),
          );
      expect(result, isA<SuccessState<List<String>>>());
      expect(result.data, ['Mapped: 1', 'Mapped: 2']);
    });

    test('calls onRemoteSuccess with raw list before mapping', () async {
      List<FakeDto>? rawData;
      final result =
          await DataHandler.fetchWithFallbackAndMapList<FakeDto, String>(
            isInternetConnected: true,
            remoteCallback: () async => SuccessState(data: [FakeDto(3)]),
            onRemoteSuccess: (data) => rawData = data,
          );
      expect(rawData?.length, 1);
      expect(rawData?.first.value, 3);
      expect(result.data, ['Mapped: 3']);
    });

    test('maps local list data when offline', () async {
      final result =
          await DataHandler.fetchWithFallbackAndMapList<FakeDto, String>(
            isInternetConnected: false,
            remoteCallback: () async => SuccessState(data: [FakeDto(10)]),
            localCallback: () async =>
                SuccessState(data: [FakeDto(20), FakeDto(21)]),
          );
      expect(result, isA<SuccessState<List<String>>>());
      expect(result.data, ['Mapped: 20', 'Mapped: 21']);
    });

    test('returns failure state when both remote and local fail', () async {
      final result =
          await DataHandler.fetchWithFallbackAndMapList<FakeDto, String>(
            isInternetConnected: false,
            remoteCallback: () async =>
                const FailureState(message: 'Remote error'),
            localCallback: () async =>
                const FailureState(message: 'Local error'),
          );
      expect(result, isA<FailureState<List<String>>>());
      expect(result.message, 'Local error');
    });
  });

  group('DataHandler.fetchFromLocalAndMap', () {
    test('maps local data successfully', () async {
      final result = await DataHandler.fetchFromLocalAndMap<FakeDto, String>(
        localCallback: () async => SuccessState(data: FakeDto(123)),
      );
      expect(result, isA<SuccessState<String>>());
      expect(result.data, 'Mapped: 123');
    });

    test('propagates local failure state', () async {
      final result = await DataHandler.fetchFromLocalAndMap<FakeDto, String>(
        localCallback: () async =>
            const FailureState(message: 'Local storage error'),
      );
      expect(result, isA<FailureState<String>>());
      expect(result.message, 'Local storage error');
    });
  });

  group('DataHandler.fetchFromLocalAndMapList', () {
    test('maps local list data successfully', () async {
      final result =
          await DataHandler.fetchFromLocalAndMapList<FakeDto, String>(
            localCallback: () async =>
                SuccessState(data: [FakeDto(5), FakeDto(6)]),
          );
      expect(result, isA<SuccessState<List<String>>>());
      expect(result.data, ['Mapped: 5', 'Mapped: 6']);
    });

    test('propagates local failure state for list', () async {
      final result =
          await DataHandler.fetchFromLocalAndMapList<FakeDto, String>(
            localCallback: () async =>
                const FailureState(message: 'Local list error'),
          );
      expect(result, isA<FailureState<List<String>>>());
      expect(result.message, 'Local list error');
    });
  });

  group('DataHandler.safeApiCall', () {
    test('returns SuccessState on valid standard response', () async {
      final mockResponse = MockResponse<dynamic>();
      when(() => mockResponse.data).thenReturn({
        'data': {'id': 1},
        'message': 'ok',
      });
      when(() => mockResponse.statusCode).thenReturn(200);

      final result =
          await DataHandler.safeApiCall<
            Map<String, dynamic>,
            Map<String, dynamic>
          >(request: () async => mockResponse, fromJson: (json) => json);

      expect(result, isA<SuccessState<Map<String, dynamic>>>());
      expect(result.data, {'id': 1});
      expect(result.message, 'ok');
      expect(result.statusCode, 200);
    });

    test(
      'returns FailureState on missing data key in standard response',
      () async {
        final mockResponse = MockResponse<dynamic>();
        when(() => mockResponse.data).thenReturn({'foo': 'bar'});
        when(() => mockResponse.statusCode).thenReturn(200);

        final result =
            await DataHandler.safeApiCall<
              Map<String, dynamic>,
              Map<String, dynamic>
            >(request: () async => mockResponse, fromJson: (json) => json);

        expect(result, isA<FailureState<Map<String, dynamic>>>());
        expect(result.errorType, ErrorType.responseError);
      },
    );

    test(
      'handles static data return with useStaticDataAsNull = true',
      () async {
        final mockResponse = MockResponse<dynamic>();
        when(() => mockResponse.data).thenReturn({'data': 'ignored'});
        when(() => mockResponse.statusCode).thenReturn(200);

        final result = await DataHandler.safeApiCall<String, String>(
          request: () async => mockResponse,
        );

        expect(result, isA<SuccessState<String>>());
      },
    );

    test(
      'handles static data return with useStaticDataAsNull = false',
      () async {
        final mockResponse = MockResponse<dynamic>();
        when(() => mockResponse.data).thenReturn({'data': 'from_api'});
        when(() => mockResponse.statusCode).thenReturn(200);

        final result = await DataHandler.safeApiCall<String, String>(
          request: () async => mockResponse,
          staticData: 'static_value',
        );

        expect(result, isA<SuccessState<String>>());
        expect(result.data, 'static_value');
      },
    );

    test('handles list deserialization correctly', () async {
      final mockResponse = MockResponse<dynamic>();
      when(() => mockResponse.data).thenReturn({
        'data': [
          {'id': 1},
          {'id': 2},
        ],
        'message': 'list ok',
      });
      when(() => mockResponse.statusCode).thenReturn(200);

      final result =
          await DataHandler.safeApiCall<
            List<Map<String, dynamic>>,
            Map<String, dynamic>
          >(request: () async => mockResponse, fromJson: (json) => json);

      expect(result, isA<SuccessState<List<Map<String, dynamic>>>>());
      expect(result.data, [
        {'id': 1},
        {'id': 2},
      ]);
      expect(result.message, 'list ok');
    });

    test('returns format error for unexpected response type', () async {
      final mockResponse = MockResponse<dynamic>();
      when(() => mockResponse.data).thenReturn('invalid_string_data');
      when(() => mockResponse.statusCode).thenReturn(200);

      final result =
          await DataHandler.safeApiCall<
            Map<String, dynamic>,
            Map<String, dynamic>
          >(request: () async => mockResponse, fromJson: (json) => json);

      expect(result, isA<FailureState<Map<String, dynamic>>>());
      expect(result.errorType, ErrorType.responseError);
    });

    test('handles non-standard response structure', () async {
      final mockResponse = MockResponse<dynamic>();
      when(() => mockResponse.data).thenReturn({'id': 1, 'name': 'test'});
      when(() => mockResponse.statusCode).thenReturn(200);

      final result =
          await DataHandler.safeApiCall<
            Map<String, dynamic>,
            Map<String, dynamic>
          >(
            request: () async => mockResponse,
            fromJson: (json) => json,
            isStandardResponse: false,
          );

      expect(result, isA<SuccessState<Map<String, dynamic>>>());
      expect(result.data, {'id': 1, 'name': 'test'});
    });

    test('handles raw data without deserialization', () async {
      final mockResponse = MockResponse<dynamic>();
      when(() => mockResponse.data).thenReturn('raw_string');
      when(() => mockResponse.statusCode).thenReturn(200);

      final result = await DataHandler.safeApiCall<String, String>(
        request: () async => mockResponse,
        isStandardResponse: false,
      );

      expect(result, isA<SuccessState<String>>());
      expect(result.data, 'raw_string');
    });

    test('returns type mismatch error for incompatible types', () async {
      final mockResponse = MockResponse<dynamic>();
      when(() => mockResponse.data).thenReturn({'id': 1});
      when(() => mockResponse.statusCode).thenReturn(200);

      final result = await DataHandler.safeApiCall<String, String>(
        request: () async => mockResponse,
        isStandardResponse: false,
      );

      expect(result, isA<FailureState<String>>());
      expect(result.errorType, ErrorType.formatError);
    });
  });
}
