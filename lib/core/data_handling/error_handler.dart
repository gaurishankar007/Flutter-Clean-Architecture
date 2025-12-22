part of 'data_handler.dart';

abstract final class ErrorHandler {
  /// Catches exceptions and logs the error.
  static Future<void> catchException(Future<void> Function() callBack) async {
    try {
      await callBack();
    } catch (error, stackTrace) {
      debugError(error, stackTrace);
    }
  }

  /// Handles exceptions and returns appropriate failure states.
  static FutureData<T> handleException<T>(
    FutureData<T> Function() callBack,
  ) async {
    try {
      return await callBack();
    } on DioException catch (exception, stackTrace) {
      debugError('Error Response: ${exception.response}');
      debugError(exception, stackTrace);
      return _dioExceptionToFailureState<T>(exception);
    } on FormatException catch (exception, stackTrace) {
      debugError(exception, stackTrace);
      return FailureState.formatError();
    } catch (error, stackTrace) {
      debugError(error, stackTrace);
      return FailureState<T>(message: error.toString());
    }
  }

  /// Returns the respective data failure state base on the dio exception.
  static FailureState<T> _dioExceptionToFailureState<T>(
    DioException exception,
  ) {
    String? errorMessage = ERROR_MESSAGE;
    final errorType = exception.type;
    final response = exception.response;
    final statusCode = response?.statusCode ?? 0;

    /// If the server response contains error status codes
    if (errorType == DioExceptionType.badResponse && response != null) {
      if (response.data is Map) {
        errorMessage = response.data?['message'] as String?;
      }

      if (statusCode >= 400 && statusCode < 500) {
        return FailureState.badRequest(
          message: errorMessage,
          statusCode: statusCode,
        );
      } else if (statusCode >= 500) {
        return FailureState.serverError(
          message: errorMessage,
          statusCode: statusCode,
        );
      }
    }

    errorMessage = _dioErrorMessages[errorType.name] ?? ERROR_MESSAGE;

    return FailureState(
      message: errorMessage,
      errorType: ErrorType.dioError,
      statusCode: statusCode,
    );
  }

  static void debugError(Object? error, [StackTrace? stackTrace]) {
    if (kDebugMode) {
      log(
        '<--------- Caught Exception ---------->',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  static const _dioErrorMessages = {
    'connectionError': 'Connection error, host lookup failed.',
    'cancel': 'Request was cancelled',
    'receiveTimeout': 'Receive timeout in connection. $CHECK_INTERNET',
    'sendTimeout': 'Send timeout in connection. $CHECK_INTERNET',
    'connectionTimeout': 'Connection timeout. $CHECK_INTERNET',
    'badCertificate': 'Bad certificate. $CUSTOMER_SUPPORT',
  };
}
