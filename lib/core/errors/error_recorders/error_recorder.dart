import 'package:clean_architecture/core/data/states/data_state.dart';

/// Interface for recording errors to different error reporting services.
abstract interface class ErrorRecorder {
  /// Records all the uncaught errors thrown within the Flutter framework
  /// and asynchronous errors that are not handled by the Flutter framework.
  void recordUncaughtErrors();

  /// Returns true if the error should be recorded.
  ///
  /// If the error is not recordable, the [record] method will not be called.
  bool get isRecordable;

  /// Records an error with its stack trace.
  void record({
    required Object error,
    FailureState<dynamic>? failureState,
    StackTrace? stackTrace,
  });
}
