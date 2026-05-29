import 'package:clean_architecture/core/data/states/data_state.dart';
import 'package:clean_architecture/core/errors/error_handler.dart';
import 'package:clean_architecture/core/errors/error_translators/dio_error_translator.dart';
import 'package:clean_architecture/core/errors/error_translators/firebase_error_translator.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';

import '../../../testing/mocks/external/external_mocks.dart';
import '../../../testing/mocks/external/firebase_mocks.dart';

void main() {
  setUpAll(() {
    ErrorHandlerProvider.register(
      errorTranslators: [DioErrorTranslator(), FirebaseErrorTranslator()],
    );
  });

  tearDownAll(() {
    GetIt.I.reset();
  });

  group('ErrorHandlerProvider.I.execute', () {
    test('returns result when no exception thrown', () async {
      final result = await ErrorHandlerProvider.I.execute<int>(
        () async => const SuccessState(data: 1),
      );
      expect(result, isA<SuccessState<int>>());
      expect(result.data, 1);
    });

    test('handles various exceptions correctly', () async {
      // 1. DioException - 400
      final response400 = MockResponse<dynamic>();
      when(() => response400.statusCode).thenReturn(400);
      when(() => response400.data).thenReturn({'message': 'bad request'});
      when(() => response400.headers).thenReturn(Headers());
      final dio400 = MockDioException();
      when(() => dio400.requestOptions).thenReturn(RequestOptions());
      when(() => dio400.type).thenReturn(DioExceptionType.badResponse);
      when(() => dio400.response).thenReturn(response400);

      final result400 = await ErrorHandlerProvider.I.execute<int>(
        () => throw dio400,
      );
      expect(result400.message, 'bad request');

      // 2. DioException - 500
      final response500 = MockResponse<dynamic>();
      when(() => response500.statusCode).thenReturn(500);
      when(() => response500.data).thenReturn({'message': 'server error'});
      when(() => response500.headers).thenReturn(Headers());
      final dio500 = MockDioException();
      when(() => dio500.requestOptions).thenReturn(RequestOptions());
      when(() => dio500.type).thenReturn(DioExceptionType.badResponse);
      when(() => dio500.response).thenReturn(response500);

      final result500 = await ErrorHandlerProvider.I.execute<int>(
        () => throw dio500,
      );
      expect(result500.message, 'server error');

      // 3. DioException - Connection Error
      final dioConn = MockDioException();
      when(() => dioConn.requestOptions).thenReturn(RequestOptions());
      when(() => dioConn.type).thenReturn(DioExceptionType.connectionError);
      final resultConn = await ErrorHandlerProvider.I.execute<int>(
        () => throw dioConn,
      );
      expect(resultConn.message, contains('Connection error'));

      // 4. FirebaseAuthException - user-not-found
      final firebaseNotFound = MockFirebaseAuthException();
      when(() => firebaseNotFound.code).thenReturn('user-not-found');
      final resultFirebase = await ErrorHandlerProvider.I.execute<int>(
        () => throw firebaseNotFound,
      );
      expect(resultFirebase.message, contains('not found'));

      // 5. Generic Exception
      final resultGeneric = await ErrorHandlerProvider.I.execute<int>(
        () => throw Exception('generic'),
      );
      expect(resultGeneric.message, contains(kErrorMessage));
    });
  });

  group('ErrorHandlerProvider.I.executeSafe', () {
    test('catches and logs exception without re-throwing', () async {
      var executed = false;
      await ErrorHandlerProvider.I.executeSafe(() {
        executed = true;
        throw Exception('test exception');
      });
      expect(executed, true);
    });
  });

  group('ErrorHandlerProvider.I.executeSafeReturn', () {
    test('returns value or valueOnError correctly', () async {
      final success = await ErrorHandlerProvider.I.executeSafeReturn<int>(
        () async => 10,
        valueOnError: -1,
      );
      expect(success, 10);

      final failure = await ErrorHandlerProvider.I.executeSafeReturn<int>(
        () async => throw Exception(),
        valueOnError: -1,
      );
      expect(failure, -1);
    });
  });

  group('ErrorHandlerProvider.I.executeSafeSync', () {
    test('executes or catches exception correctly', () {
      var executed = false;
      ErrorHandlerProvider.I.executeSafeSync(() {
        executed = true;
        throw Exception();
      });
      expect(executed, true);
    });
  });

  group('ErrorHandlerProvider.I.executeSafeReturnSync', () {
    test('returns value or valueOnError correctly', () {
      expect(
        ErrorHandlerProvider.I.executeSafeReturnSync(
          () => 20,
          valueOnError: -1,
        ),
        20,
      );
      expect(
        ErrorHandlerProvider.I.executeSafeReturnSync(
          () => throw Exception(),
          valueOnError: -1,
        ),
        -1,
      );
    });
  });
}
