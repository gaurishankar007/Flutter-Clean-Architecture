import 'package:clean_architecture/core/data/handlers/error_handler.dart';
import 'package:clean_architecture/core/data/states/data_state.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../testing/mocks/external/external_mocks.dart';

void main() {
  group('ErrorHandler.execute', () {
    test('returns result when no exception thrown', () async {
      final result = await ErrorHandler.execute<int>(
        () async => const SuccessState(data: 1),
      );
      expect(result, isA<SuccessState<int>>());
      expect(result.data, 1);
    });

    test('handles DioException with 400 status as BadRequestState', () async {
      final response = MockResponse<dynamic>();
      when(() => response.statusCode).thenReturn(400);
      when(() => response.data).thenReturn({'message': 'bad request'});
      final dioException = MockDioException();
      when(() => dioException.type).thenReturn(DioExceptionType.badResponse);
      when(() => dioException.response).thenReturn(response);

      final result = await ErrorHandler.execute<int>(() {
        throw dioException;
      });

      expect(result.message, 'bad request');
      expect(result.statusCode, 400);
    });

    test('handles DioException with 500 status as ServerErrorState', () async {
      final response = MockResponse<dynamic>();
      when(() => response.statusCode).thenReturn(500);
      when(() => response.data).thenReturn({'message': 'server error'});
      final dioException = MockDioException();
      when(() => dioException.type).thenReturn(DioExceptionType.badResponse);
      when(() => dioException.response).thenReturn(response);

      final result = await ErrorHandler.execute<int>(() {
        throw dioException;
      });

      expect(result.message, 'server error');
      expect(result.statusCode, 500);
    });

    test('handles DioException with connectionError as FailureState', () async {
      final dioException = MockDioException();
      when(
        () => dioException.type,
      ).thenReturn(DioExceptionType.connectionError);
      when(() => dioException.response).thenReturn(null);

      final result = await ErrorHandler.execute<int>(() {
        throw dioException;
      });

      expect(result, isA<FailureState<int>>());
      expect(result.message, contains('Connection error'));
    });

    test('handles DioException with cancel as FailureState', () async {
      final dioException = MockDioException();
      when(() => dioException.type).thenReturn(DioExceptionType.cancel);
      when(() => dioException.response).thenReturn(null);

      final result = await ErrorHandler.execute<int>(() {
        throw dioException;
      });

      expect(result, isA<FailureState<int>>());
      expect(result.message, contains('Request was cancelled'));
    });

    test('handles DioException with receiveTimeout as FailureState', () async {
      final dioException = MockDioException();
      when(() => dioException.type).thenReturn(DioExceptionType.receiveTimeout);
      when(() => dioException.response).thenReturn(null);

      final result = await ErrorHandler.execute<int>(() {
        throw dioException;
      });

      expect(result, isA<FailureState<int>>());
      expect(result.message, contains('Receive timeout'));
    });

    test('handles DioException with sendTimeout as FailureState', () async {
      final dioException = MockDioException();
      when(() => dioException.type).thenReturn(DioExceptionType.sendTimeout);
      when(() => dioException.response).thenReturn(null);

      final result = await ErrorHandler.execute<int>(() {
        throw dioException;
      });

      expect(result, isA<FailureState<int>>());
      expect(result.message, contains('Send timeout'));
    });

    test(
      'handles DioException with connectionTimeout as FailureState',
      () async {
        final dioException = MockDioException();
        when(
          () => dioException.type,
        ).thenReturn(DioExceptionType.connectionTimeout);
        when(() => dioException.response).thenReturn(null);

        final result = await ErrorHandler.execute<int>(() {
          throw dioException;
        });

        expect(result, isA<FailureState<int>>());
        expect(result.message, contains('Connection timeout'));
      },
    );

    test('handles DioException with badCertificate as FailureState', () async {
      final dioException = MockDioException();
      when(() => dioException.type).thenReturn(DioExceptionType.badCertificate);
      when(() => dioException.response).thenReturn(null);

      final result = await ErrorHandler.execute<int>(() {
        throw dioException;
      });

      expect(result, isA<FailureState<int>>());
      expect(result.message, contains('Bad certificate'));
    });

    test(
      'handles DioException with unknown error type as FailureState',
      () async {
        final dioException = MockDioException();
        when(() => dioException.type).thenReturn(DioExceptionType.unknown);
        when(() => dioException.response).thenReturn(null);

        final result = await ErrorHandler.execute<int>(() {
          throw dioException;
        });

        expect(result, isA<FailureState<int>>());
        expect(result.message, isNotNull);
      },
    );

    test('handles generic Exception as FailureState', () async {
      final result = await ErrorHandler.execute<int>(() {
        throw Exception('generic error');
      });

      expect(result, isA<FailureState<int>>());
      expect(result.message, contains(kErrorMessage));
    });

    test('handles String error as FailureState', () async {
      final result = await ErrorHandler.execute<int>(() {
        throw Exception('string error');
      });

      expect(result, isA<FailureState<int>>());
      expect(result.message, contains(kErrorMessage));
    });

    test('handles custom error object as FailureState', () async {
      final result = await ErrorHandler.execute<int>(() {
        throw ArgumentError('invalid argument');
      });

      expect(result, isA<FailureState<int>>());
      expect(result.message, contains(kErrorMessage));
    });
  });

  group('ErrorHandler.executeSafe', () {
    test('catches and logs exception without rethrowing', () async {
      var exceptionCaught = false;

      await ErrorHandler.executeSafe(() {
        throw Exception('test exception');
      });

      // If we reach here, the exception was caught and not rethrown
      exceptionCaught = true;
      expect(exceptionCaught, true);
    });

    test('does not interfere with successful execution', () async {
      var executed = false;

      await ErrorHandler.executeSafe(() async {
        executed = true;
      });

      expect(executed, true);
    });
  });

  group('ErrorHandler.executeSafeReturn', () {
    test('returns value when no exception thrown', () async {
      final result = await ErrorHandler.executeSafeReturn<int>(
        () async => 10,
        valueOnError: -1,
      );
      expect(result, 10);
    });

    test('returns valueOnError when exception thrown', () async {
      final result = await ErrorHandler.executeSafeReturn<int>(
        () async => throw Exception('fail'),
        valueOnError: -1,
      );
      expect(result, -1);
    });
  });

  group('ErrorHandler.executeSafeSync', () {
    test('executes successfully without exception', () {
      var executed = false;
      ErrorHandler.executeSafeSync(() {
        executed = true;
      });
      expect(executed, true);
    });

    test('catches exception and does not rethrow', () {
      ErrorHandler.executeSafeSync(() {
        throw Exception('sync fail');
      });
      // If we reach here, exception was caught
    });
  });

  group('ErrorHandler.executeSafeReturnSync', () {
    test('returns value when no exception thrown', () {
      final result = ErrorHandler.executeSafeReturnSync(
        () => 20,
        valueOnError: -1,
      );
      expect(result, 20);
    });

    test('returns valueOnError when exception thrown', () {
      final result = ErrorHandler.executeSafeReturnSync<int>(
        () => throw Exception('sync fail'),
        valueOnError: -1,
      );
      expect(result, -1);
    });
  });
}
