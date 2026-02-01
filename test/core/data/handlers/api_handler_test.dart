import 'package:clean_architecture/core/data/handlers/api_handler.dart';
import 'package:clean_architecture/core/data/states/data_state.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockResponse<T> extends Mock implements Response<T> {}

void main() {
  group('ApiHandler.call', () {
    test('returns SuccessState on valid standard response', () async {
      final mockResponse = MockResponse<dynamic>();
      when(() => mockResponse.data).thenReturn({
        'data': {'id': 1},
        'message': 'ok',
      });
      when(() => mockResponse.statusCode).thenReturn(200);

      final result =
          await ApiHandler.call<Map<String, dynamic>, Map<String, dynamic>>(
            () async => mockResponse,
            fromJson: (json) => json,
          );

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
            await ApiHandler.call<Map<String, dynamic>, Map<String, dynamic>>(
              () async => mockResponse,
              fromJson: (json) => json,
            );

        expect(result, isA<FailureState<Map<String, dynamic>>>());
        expect(result.error, contains('Response missing expected key'));
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
          await ApiHandler.call<
            List<Map<String, dynamic>>,
            Map<String, dynamic>
          >(() async => mockResponse, fromJson: (json) => json);

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
          await ApiHandler.call<Map<String, dynamic>, Map<String, dynamic>>(
            () async => mockResponse,
            fromJson: (json) => json,
          );

      expect(result, isA<FailureState<Map<String, dynamic>>>());
      expect(result.error, contains('Bad response format'));
    });

    test('handles non-standard response structure', () async {
      final mockResponse = MockResponse<dynamic>();
      when(() => mockResponse.data).thenReturn({'id': 1, 'name': 'test'});
      when(() => mockResponse.statusCode).thenReturn(200);

      final result =
          await ApiHandler.call<Map<String, dynamic>, Map<String, dynamic>>(
            () async => mockResponse,
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

      final result = await ApiHandler.call<String, String>(
        () async => mockResponse,
        isStandardResponse: false,
      );

      expect(result, isA<SuccessState<String>>());
      expect(result.data, 'raw_string');
    });

    test('returns type mismatch error for incompatible types', () async {
      final mockResponse = MockResponse<dynamic>();
      when(() => mockResponse.data).thenReturn({'id': 1});
      when(() => mockResponse.statusCode).thenReturn(200);

      final result = await ApiHandler.call<String, String>(
        () async => mockResponse,
        isStandardResponse: false,
      );

      expect(result, isA<FailureState<String>>());
      expect(result.error, contains('Type mismatch'));
    });
  });

  group('ApiHandler.voidCall', () {
    test('returns SuccessState<void> on successful request', () async {
      final mockResponse = MockResponse<dynamic>();
      when(() => mockResponse.data).thenReturn({'message': 'deleted'});
      when(() => mockResponse.statusCode).thenReturn(204);

      final result = await ApiHandler.voidCall(() async => mockResponse);

      expect(result, isA<SuccessState<void>>());
      expect(result.message, 'deleted');
      expect(result.statusCode, 204);
    });
  });

  group('ApiHandler.staticCall', () {
    test('returns success with static data', () async {
      final mockResponse = MockResponse<dynamic>();
      when(() => mockResponse.data).thenReturn({'message': 'ok'});
      when(() => mockResponse.statusCode).thenReturn(200);

      final result = await ApiHandler.staticCall<bool>(
        () async => mockResponse,
        staticData: true,
      );

      expect(result, isA<SuccessState<bool>>());
      expect(result.data, true);
      expect(result.message, 'ok');
    });
  });
}
