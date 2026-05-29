import 'dart:developer' show log;

import 'package:clean_architecture/core/data/models/app_error_details.dart';
import 'package:clean_architecture/core/data/states/data_state.dart';
import 'package:clean_architecture/core/errors/error_recorders/error_recorder.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';

class AppErrorRecorder implements ErrorRecorder {
  @override
  void recordUncaughtErrors() {
    try {
      // Record all uncaught "fatal" errors from the framework.
      FlutterError.onError = (errorDetails) {
        record(error: errorDetails.exception, stackTrace: errorDetails.stack);
      };
      // Record all uncaught asynchronous errors.
      PlatformDispatcher.instance.onError = (error, stack) {
        record(error: error, stackTrace: stack);
        return true;
      };
    } catch (e, stack) {
      if (kDebugMode) {
        log('App uncaught errors recording failed: $e\n$stack');
      }
    }
  }

  @override
  bool get isRecordable => true;

  @override
  void record({
    required Object error,
    FailureState<dynamic>? failureState,
    StackTrace? stackTrace,
  }) {
    final errorDetails = AppErrorDetails(
      title: 'vAIolin App Error (${error.runtimeType})',
      message: failureState?.message,
      // Add the failure error if it exists otherwise fallback to the error.
      error: failureState?.error ?? error.toString(),
      stackTrace: stackTrace?.toString(),
      appFlavor: '',
      appVersion: '',
      deviceDetails: '',
      extras: {},
    );

    _appErrors.insert(0, errorDetails);
  }

  final List<AppErrorDetails> _appErrors = [];

  List<AppErrorDetails> get getErrors => [..._appErrors];

  void removeError(String errorId) =>
      _appErrors.removeWhere((error) => error.id == errorId);

  void clearAllErrors() => _appErrors.clear();
}

/// A util class for accessing/registering [AppErrorRecorder] singleton instance.
abstract final class AppErrorProvider {
  /// Returns the [AppErrorRecorder] singleton instance.
  static AppErrorRecorder get I => GetIt.I<AppErrorRecorder>();

  /// Register the [AppErrorRecorder] singleton instance as [AppErrorRecorder] lazily.
  static void register() =>
      GetIt.I.registerLazySingleton<AppErrorRecorder>(AppErrorRecorder.new);
}
