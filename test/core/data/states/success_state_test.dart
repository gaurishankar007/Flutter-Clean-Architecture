import 'package:clean_architecture/core/data/states/data_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SuccessState', () {
    test('should have correct data and hasData true', () {
      const state = SuccessState<int>(data: 10, message: 'Success');

      expect(state.data, 10);
      expect(state.message, 'Success');
      expect(state.hasData, true);
      expect(state.hasError, false);
    });

    test('should be equatable', () {
      const state1 = SuccessState<int>(data: 1, message: 'ok');
      const state2 = SuccessState<int>(data: 1, message: 'ok');

      expect(state1, equals(state2));
    });
  });
}
