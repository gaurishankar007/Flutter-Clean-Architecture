import 'package:clean_architecture/core/data_handling/data_handler.dart';
import 'package:clean_architecture/core/data_states/data_state.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockDioException extends Mock implements DioException {}

class MockResponse extends Mock implements Response {}

void main() {
  group('ErrorHandler.handleException', () {
    test('returns result when no exception thrown', () async {
      final result = await ErrorHandler.handleException<int>(
        () async => const SuccessState(data: 1),
      );
      expect(result, isA<SuccessState<int>>());
      expect(result.data, 1);
    });

    test('handles DioException with 400 status as BadRequestState', () async {
      final response = MockResponse();
      when(() => response.statusCode).thenReturn(400);
      when(() => response.data).thenReturn({'message': 'bad request'});
      final dioException = MockDioException();
      when(() => dioException.type).thenReturn(DioExceptionType.badResponse);
      when(() => dioException.response).thenReturn(response);

      final result = await ErrorHandler.handleException<int>(() async {
        throw dioException;
      });

      expect(result.errorType, ErrorType.requestError);
      expect(result.message, 'bad request');
      expect(result.statusCode, 400);
    });

    test('handles DioException with 404 status as BadRequestState', () async {
      final response = MockResponse();
      when(() => response.statusCode).thenReturn(404);
      when(() => response.data).thenReturn({'message': 'not found'});
      final dioException = MockDioException();
      when(() => dioException.type).thenReturn(DioExceptionType.badResponse);
      when(() => dioException.response).thenReturn(response);

      final result = await ErrorHandler.handleException<int>(() async {
        throw dioException;
      });

      expect(result.errorType, ErrorType.requestError);
      expect(result.message, 'not found');
      expect(result.statusCode, 404);
    });

    test('handles DioException with 500 status as ServerErrorState', () async {
      final response = MockResponse();
      when(() => response.statusCode).thenReturn(500);
      when(() => response.data).thenReturn({'message': 'server error'});
      final dioException = MockDioException();
      when(() => dioException.type).thenReturn(DioExceptionType.badResponse);
      when(() => dioException.response).thenReturn(response);

      final result = await ErrorHandler.handleException<int>(() async {
        throw dioException;
      });

      expect(result.errorType, ErrorType.serverError);
      expect(result.message, 'server error');
      expect(result.statusCode, 500);
    });

    test('handles DioException with 503 status as ServerErrorState', () async {
      final response = MockResponse();
      when(() => response.statusCode).thenReturn(503);
      when(() => response.data).thenReturn({'message': 'service unavailable'});
      final dioException = MockDioException();
      when(() => dioException.type).thenReturn(DioExceptionType.badResponse);
      when(() => dioException.response).thenReturn(response);

      final result = await ErrorHandler.handleException<int>(() async {
        throw dioException;
      });

      expect(result.errorType, ErrorType.serverError);
      expect(result.message, 'service unavailable');
      expect(result.statusCode, 503);
    });

    test('handles DioException with connectionError as FailureState', () async {
      final dioException = MockDioException();
      when(
        () => dioException.type,
      ).thenReturn(DioExceptionType.connectionError);
      when(() => dioException.response).thenReturn(null);

      final result = await ErrorHandler.handleException<int>(() async {
        throw dioException;
      });

      expect(result, isA<FailureState<int>>());
      expect(result.errorType, ErrorType.dioError);
      expect(result.message, contains('Connection error'));
    });

    test('handles DioException with cancel as FailureState', () async {
      final dioException = MockDioException();
      when(() => dioException.type).thenReturn(DioExceptionType.cancel);
      when(() => dioException.response).thenReturn(null);

      final result = await ErrorHandler.handleException<int>(() async {
        throw dioException;
      });

      expect(result, isA<FailureState<int>>());
      expect(result.errorType, ErrorType.dioError);
      expect(result.message, contains('Request was cancelled'));
    });

    test('handles DioException with receiveTimeout as FailureState', () async {
      final dioException = MockDioException();
      when(() => dioException.type).thenReturn(DioExceptionType.receiveTimeout);
      when(() => dioException.response).thenReturn(null);

      final result = await ErrorHandler.handleException<int>(() async {
        throw dioException;
      });

      expect(result, isA<FailureState<int>>());
      expect(result.errorType, ErrorType.dioError);
      expect(result.message, contains('Receive timeout'));
    });

    test('handles DioException with sendTimeout as FailureState', () async {
      final dioException = MockDioException();
      when(() => dioException.type).thenReturn(DioExceptionType.sendTimeout);
      when(() => dioException.response).thenReturn(null);

      final result = await ErrorHandler.handleException<int>(() async {
        throw dioException;
      });

      expect(result, isA<FailureState<int>>());
      expect(result.errorType, ErrorType.dioError);
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

        final result = await ErrorHandler.handleException<int>(() async {
          throw dioException;
        });

        expect(result, isA<FailureState<int>>());
        expect(result.errorType, ErrorType.dioError);
        expect(result.message, contains('Connection timeout'));
      },
    );

    test('handles DioException with badCertificate as FailureState', () async {
      final dioException = MockDioException();
      when(() => dioException.type).thenReturn(DioExceptionType.badCertificate);
      when(() => dioException.response).thenReturn(null);

      final result = await ErrorHandler.handleException<int>(() async {
        throw dioException;
      });

      expect(result, isA<FailureState<int>>());
      expect(result.errorType, ErrorType.dioError);
      expect(result.message, contains('Bad certificate'));
    });

    test(
      'handles DioException with unknown error type as FailureState',
      () async {
        final dioException = MockDioException();
        when(() => dioException.type).thenReturn(DioExceptionType.unknown);
        when(() => dioException.response).thenReturn(null);

        final result = await ErrorHandler.handleException<int>(() async {
          throw dioException;
        });

        expect(result, isA<FailureState<int>>());
        expect(result.errorType, ErrorType.dioError);
        expect(result.message, isNotNull);
      },
    );

    test('handles TypeError as FailureState.typeError', () async {
      final result = await ErrorHandler.handleException<int>(() async {
        throw TypeError();
      });

      expect(result, isA<FailureState<int>>());
      expect(result.errorType, ErrorType.typeError);
    });

    test('handles FormatException as FailureState.formatError', () async {
      final result = await ErrorHandler.handleException<int>(() async {
        throw const FormatException('bad format');
      });

      expect(result, isA<FailureState<int>>());
      expect(result.errorType, ErrorType.formatError);
    });

    test('handles generic Exception as FailureState', () async {
      final result = await ErrorHandler.handleException<int>(() async {
        throw Exception('generic error');
      });

      expect(result, isA<FailureState<int>>());
      expect(result.message, contains('generic error'));
    });

    test('handles String error as FailureState', () async {
      final result = await ErrorHandler.handleException<int>(() async {
        throw 'string error';
      });

      expect(result, isA<FailureState<int>>());
      expect(result.message, contains('string error'));
    });

    test('handles custom error object as FailureState', () async {
      final result = await ErrorHandler.handleException<int>(() async {
        throw ArgumentError('invalid argument');
      });

      expect(result, isA<FailureState<int>>());
      expect(result.message, contains('invalid argument'));
    });
  });

  group('ErrorHandler.catchException', () {
    test('catches and logs exception without rethrowing', () async {
      var exceptionCaught = false;

      await ErrorHandler.catchException(() {
        throw Exception('test exception');
      });

      // If we reach here, the exception was caught and not rethrown
      exceptionCaught = true;
      expect(exceptionCaught, true);
    });

    test('does not interfere with successful execution', () async {
      var executed = false;

      await ErrorHandler.catchException(() {
        executed = true;
      });

      expect(executed, true);
    });
  });
}
