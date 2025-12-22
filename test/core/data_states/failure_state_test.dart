import 'package:clean_architecture/core/data_states/data_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FailureState', () {
    test('should have correct message, errorType, and hasError true', () {
      const state = FailureState<int>(
        message: 'Failed',
        errorType: ErrorType.dioError,
        statusCode: 400,
      );

      expect(state.message, 'Failed');
      expect(state.errorType, ErrorType.dioError);
      expect(state.statusCode, 400);
      expect(state.hasError, true);
      expect(state.hasData, false);
    });

    test('should use default values if not provided', () {
      const state = FailureState<int>();

      expect(state.message, isNotNull);
      expect(state.errorType, ErrorType.unknown);
      expect(state.hasError, true);
    });

    test('should be equatable', () {
      const state1 = FailureState<int>(
        message: 'msg',
        errorType: ErrorType.dioError,
        statusCode: 500,
      );
      const state2 = FailureState<int>(
        message: 'msg',
        errorType: ErrorType.dioError,
        statusCode: 500,
      );

      expect(state1, equals(state2));
    });

    test('typeError factory returns correct FailureState', () {
      final state = FailureState<int>.typeError();

      expect(state.errorType, ErrorType.typeError);
      expect(state.hasError, true);
      expect(state.message, contains('Unsupported data type'));
    });

    test('formatError factory returns correct FailureState', () {
      final state = FailureState<int>.formatError();

      expect(state.errorType, ErrorType.formatError);
      expect(state.hasError, true);
      expect(state.message, contains('unsupported data format'));
    });

    test('badRequest factory returns correct FailureState', () {
      final state = FailureState<int>.badRequest();

      expect(state.errorType, ErrorType.requestError);
      expect(state.message, contains('Bad request'));
    });

    test('tokenExpired factory returns correct FailureState', () {
      final state = FailureState<int>.tokenExpired();

      expect(state.errorType, ErrorType.tokenError);
      expect(state.message, contains('Token is expired'));
    });

    test('badResponse factory returns correct FailureState', () {
      final state = FailureState<int>.badResponse();

      expect(state.errorType, ErrorType.responseError);
      expect(state.message, contains('Invalid server response'));
    });

    test('serverError factory returns correct FailureState', () {
      final state = FailureState<int>.serverError();

      expect(state.errorType, ErrorType.serverError);
      expect(state.message, contains('Server error occurred'));
    });

    test('noInternet factory returns correct FailureState', () {
      final state = FailureState<int>.noInternet();

      expect(state.errorType, ErrorType.internetError);
      expect(state.message, contains('No internet access'));
    });
  });
}
