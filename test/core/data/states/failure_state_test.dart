import 'package:clean_architecture/core/data/states/data_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FailureState', () {
    test('should have correct message and hasError true', () {
      const state = FailureState<int>(message: 'Failed', statusCode: 400);

      expect(state.message, 'Failed');
      expect(state.statusCode, 400);
      expect(state.hasError, true);
      expect(state.hasData, false);
    });

    test('should use default values if not provided', () {
      const state = FailureState<int>();

      expect(state.message, kErrorMessage);
      expect(state.hasError, true);
    });

    test('should be equatable', () {
      const state1 = FailureState<int>(message: 'msg', statusCode: 500);
      const state2 = FailureState<int>(message: 'msg', statusCode: 500);

      expect(state1, equals(state2));
    });

    test('badRequest factory returns correct default FailureState', () {
      final state = FailureState<int>.badRequest();

      expect(state.message, contains('Bad client request'));
    });

    test('badRequest factory uses provided values', () {
      final state = FailureState<int>.badRequest(
        message: 'Custom msg',
        error: 'Custom err',
        statusCode: 400,
      );

      expect(state.message, 'Custom msg');
      expect(state.error, 'Custom err');
      expect(state.statusCode, 400);
    });

    test('tokenExpired factory returns correct FailureState', () {
      final state = FailureState<int>.tokenExpired();

      expect(state.message, contains('Token expired'));
    });

    test('badResponse factory returns correct default FailureState', () {
      final state = FailureState<int>.badResponse();

      expect(state.message, contains('Bad server response'));
    });

    test('badResponse factory uses provided values', () {
      final state = FailureState<int>.badResponse(
        message: 'Custom response msg',
        error: 'Custom response err',
        statusCode: 502,
      );

      expect(state.message, 'Custom response msg');
      expect(state.error, 'Custom response err');
      expect(state.statusCode, 502);
    });

    test('serverError factory returns correct default FailureState', () {
      final state = FailureState<int>.serverError();

      expect(state.message, contains('Server error occurred'));
    });

    test('serverError factory uses provided values', () {
      final state = FailureState<int>.serverError(
        message: 'Custom server msg',
        error: 'Custom server err',
        statusCode: 500,
      );

      expect(state.message, 'Custom server msg');
      expect(state.error, 'Custom server err');
      expect(state.statusCode, 500);
    });

    test('noInternet factory returns correct FailureState', () {
      final state = FailureState<int>.noInternet();

      expect(state.message, contains('No internet access'));
    });
  });
}
