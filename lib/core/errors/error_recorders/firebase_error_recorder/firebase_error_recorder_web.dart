import 'package:clean_architecture/core/data/states/data_state.dart';
import 'package:clean_architecture/core/errors/error_recorders/error_recorder.dart';

final class FirebaseErrorRecorder implements ErrorRecorder {
  @override
  void recordUncaughtErrors() {}

  @override
  bool get isRecordable => false;

  @override
  void record({
    required Object error,
    FailureState<dynamic>? failureState,
    StackTrace? stackTrace,
  }) {}
}
