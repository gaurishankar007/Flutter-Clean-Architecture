import 'package:clean_architecture/core/data/states/data_state.dart';

/// Interface for translating errors into [FailureState] instances.
abstract interface class ErrorTranslator<E extends Object> {
  /// Checks if the error can be translated by this translator.
  bool matches(Object error);

  /// Translates the error into a [FailureState].
  FailureState<T> translate<T>(E error);
}
