import 'dart:developer' show log;

import 'package:clean_architecture/core/data/states/data_state.dart';
import 'package:clean_architecture/core/errors/error_recorders/error_recorder.dart';
import 'package:flutter/foundation.dart';

/// Implementation of [ErrorRecorder] that logs errors to the console.
final class LoggerErrorRecorder implements ErrorRecorder {
  @override
  void recordUncaughtErrors() {}

  @override
  bool get isRecordable => kDebugMode;

  @override
  void record({
    required Object error,
    FailureState<dynamic>? failureState,
    StackTrace? stackTrace,
  }) {
    var loggerMessage =
        '<<========================= Recorded Error =========================>>';

    // Add the failure message if it exists.
    if (failureState?.message?.isNotEmpty ?? false) {
      loggerMessage += '\nMessage: ${failureState?.message}';
    }

    log(
      loggerMessage,
      // Add the failure error if it exists otherwise fallback to the error.
      error: failureState?.error ?? error,
      stackTrace: stackTrace,
    );
  }
}
