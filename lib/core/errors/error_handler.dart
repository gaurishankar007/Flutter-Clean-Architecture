import 'package:clean_architecture/core/data/states/data_state.dart';
import 'package:clean_architecture/core/errors/error_recorders/error_recorder.dart';
import 'package:clean_architecture/core/errors/error_translators/error_translator.dart';
import 'package:clean_architecture/core/utils/type_defs.dart';
import 'package:get_it/get_it.dart';

abstract interface class ErrorHandler {
  /// Configures error recorders for recording uncaught errors.
  void configureErrorHandlers();

  /// Execute a callback that returns a `FutureData<T>` and convert
  /// thrown exceptions into appropriate `FailureState<T>` instances.
  FutureData<T> execute<T>(FutureData<T> Function() callBack);

  /// Run an async callback and log any exceptions (does not rethrow).
  ///
  /// Use this to execute `Future`-returning code where errors should be
  /// logged for diagnostics but not propagated.
  Future<void> executeSafe(Future<void> Function() callBack);

  /// Run an async callback that returns `T`, logging exceptions.
  ///
  /// On error this returns the provided `valueOnError` fallback.
  Future<T> executeSafeReturn<T>(
    Future<T> Function() callBack, {
    required T valueOnError,
  });

  /// Run a synchronous callback and log any exceptions (no rethrow).
  void executeSafeSync(void Function() callBack);

  /// Run a synchronous callback that returns `T`, logging exceptions.
  ///
  /// On error this returns the provided `valueOnError` fallback.
  T executeSafeReturnSync<T>(T Function() callBack, {required T valueOnError});
}

final class ErrorHandlerImpl implements ErrorHandler {
  ErrorHandlerImpl({
    required List<ErrorTranslator<Object>> errorTranslators,
    required List<ErrorRecorder> errorReporters,
  }) : _errorTranslators = errorTranslators,
       _errorReporters = errorReporters;

  final List<ErrorTranslator> _errorTranslators;
  final List<ErrorRecorder> _errorReporters;

  @override
  void configureErrorHandlers() {
    for (final errorRecorder in _errorReporters) {
      errorRecorder.recordUncaughtErrors();
    }
  }

  @override
  FutureData<T> execute<T>(FutureData<T> Function() callBack) async {
    try {
      return await callBack();
    } catch (error, stackTrace) {
      final failureState = _translateError<T>(error);
      _reportError(
        error: error,
        failureState: failureState,
        stackTrace: stackTrace,
      );
      return failureState;
    }
  }

  @override
  Future<void> executeSafe(Future<void> Function() callBack) async {
    try {
      await callBack();
    } catch (error, stackTrace) {
      _reportError(error: error, stackTrace: stackTrace);
    }
  }

  @override
  Future<T> executeSafeReturn<T>(
    Future<T> Function() callBack, {
    required T valueOnError,
  }) async {
    try {
      return await callBack();
    } catch (error, stackTrace) {
      _reportError(error: error, stackTrace: stackTrace);
      return valueOnError;
    }
  }

  @override
  void executeSafeSync(void Function() callBack) {
    try {
      callBack();
    } catch (error, stackTrace) {
      _reportError(error: error, stackTrace: stackTrace);
    }
  }

  @override
  T executeSafeReturnSync<T>(T Function() callBack, {required T valueOnError}) {
    try {
      return callBack();
    } catch (error, stackTrace) {
      _reportError(error: error, stackTrace: stackTrace);
      return valueOnError;
    }
  }

  /// Report the error to all registered error reporters.
  void _reportError({
    required Object error,
    FailureState<dynamic>? failureState,
    StackTrace? stackTrace,
  }) {
    for (final errorReporter in _errorReporters) {
      if (errorReporter.isRecordable) {
        errorReporter.record(
          error: error,
          failureState: failureState,
          stackTrace: stackTrace,
        );
      }
    }
  }

  /// Translate the error to a [FailureState<T>].
  FailureState<T> _translateError<T>(Object error) {
    // Step 1: Try to find an error translator that matches the error.
    final translatorIndex = _errorTranslators.indexWhere(
      (errorTranslator) => errorTranslator.matches(error),
    );

    // Step 2: If a matching error translator is found, translate the error.
    if (translatorIndex >= 0) {
      return _errorTranslators[translatorIndex].translate<T>(error);
    }

    // Step 3: If no matching error translator is found,
    // return a [FailureState] with the error.
    return FailureState<T>(error: error.toString());
  }
}

/// A util class for accessing/registering [ErrorHandler] singleton instance.
abstract final class ErrorHandlerProvider {
  /// Returns the [ErrorHandler] singleton instance.
  static ErrorHandler get I => GetIt.I<ErrorHandler>();

  /// Register the [ErrorHandler] singleton instance lazily.
  /// Takes Dio, FirebaseAuth, GoogleSignIn, and WebCamera error translators.
  /// Takes App, Firebase, and Logger error recorders.
  static void register({
    List<ErrorTranslator<Object>> errorTranslators = const [],
    List<ErrorRecorder> errorReporters = const [],
  }) => GetIt.I.registerLazySingleton<ErrorHandler>(
    () => ErrorHandlerImpl(
      errorTranslators: errorTranslators,
      errorReporters: errorReporters,
    ),
  );
}
