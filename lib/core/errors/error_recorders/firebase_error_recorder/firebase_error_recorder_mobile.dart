import 'dart:developer' show log;

import 'package:clean_architecture/core/data/states/data_state.dart';
import 'package:clean_architecture/core/errors/error_recorders/error_recorder.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

/// Implementation of [ErrorRecorder] that records errors to Firebase Crashlytics.
final class FirebaseErrorRecorder implements ErrorRecorder {
  @override
  void recordUncaughtErrors() {
    try {
      // Pass all uncaught "fatal" errors from the framework to Crashlytics
      FlutterError.onError =
          FirebaseCrashlytics.instance.recordFlutterFatalError;

      // Pass all uncaught asynchronous errors to Crashlytics
      PlatformDispatcher.instance.onError = (error, stack) {
        FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
        return true;
      };

      // When Crashlytics' automatic data collection is off, reports stay on the device.
      // Use checkForUnsentReports to find them, sendUnsentReports to upload them manually,
      // or deleteUnsentReports to clear them.
      FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(
        kReleaseMode,
      );
    } catch (e, stack) {
      if (kDebugMode) {
        log('Firebase uncaught errors recording failed: $e\n$stack');
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
  }) => FirebaseCrashlytics.instance.recordError(error, stackTrace);
}
