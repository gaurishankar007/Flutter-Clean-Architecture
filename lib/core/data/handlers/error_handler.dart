import 'dart:developer' show log;

import 'package:clean_architecture/core/data/states/data_state.dart';
import 'package:clean_architecture/core/utils/type_defs.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show kDebugMode;

abstract final class ErrorHandler {
  /// Run an async callback and log any exceptions (does not rethrow).
  ///
  /// Use this to execute `Future`-returning code where errors should be
  /// logged for diagnostics but not propagated.
  static Future<void> executeSafe(Future<void> Function() callBack) async {
    try {
      await callBack();
    } catch (error, stackTrace) {
      _debugError(error, stackTrace);
    }
  }

  /// Run an async callback that returns `T`, logging exceptions.
  ///
  /// On error this returns the provided `valueOnError` fallback.
  static Future<T> executeSafeReturn<T>(
    Future<T> Function() callBack, {
    required T valueOnError,
  }) async {
    try {
      return await callBack();
    } catch (error, stackTrace) {
      _debugError(error, stackTrace);
      return valueOnError;
    }
  }

  /// Run a synchronous callback and log any exceptions (no rethrow).
  static void executeSafeSync(void Function() callBack) {
    try {
      callBack();
    } catch (error, stackTrace) {
      _debugError(error, stackTrace);
    }
  }

  /// Run a synchronous callback that returns `T`, logging exceptions.
  ///
  /// On error this returns the provided `valueOnError` fallback.
  static T executeSafeReturnSync<T>(
    T Function() callBack, {
    required T valueOnError,
  }) {
    try {
      return callBack();
    } catch (error, stackTrace) {
      _debugError(error, stackTrace);
      return valueOnError;
    }
  }

  /// Execute a callback that returns a `FutureData<T>` and convert
  /// thrown exceptions into appropriate `FailureState<T>` instances.
  static FutureData<T> execute<T>(FutureData<T> Function() callBack) async {
    try {
      return await callBack();
    } on DioException catch (exception, stackTrace) {
      _debugError('Http Response: ${exception.response}');
      _debugError(exception, stackTrace);
      return _handleDioException<T>(exception);
    } 
    // on FirebaseAuthException catch (exception, stackTrace) {
    //   _debugError(exception, stackTrace);
    //   return _handleFirebaseAuthException<T>(exception);
    // } on GoogleSignInException catch (exception, stackTrace) {
    //   _debugError(exception, stackTrace);
    //   return _handleGoogleSignInException<T>(exception);
    // }
    catch (error, stackTrace) {
      _debugError(error, stackTrace);
      return FailureState<T>(error: error.toString());
    }
  }

  /// Map a `DioException` to a `FailureState<T>` with an appropriate
  /// user-facing message and error metadata.
  static FailureState<T> _handleDioException<T>(DioException exception) {
    final errorType = exception.type;
    final response = exception.response;
    final statusCode = response?.statusCode ?? 0;

    /// If the server response contains error status codes
    if (errorType == .badResponse && response != null) {
      String? errorMessage, error;
      if (response.data case final MapDynamic responseBody) {
        errorMessage = responseBody['message'] as String?;
        error = 'Response: $responseBody';
      }

      if (statusCode >= 400 && statusCode < 500) {
        return FailureState.badRequest(
          message: errorMessage,
          error: error,
          statusCode: statusCode,
          response: response,
        );
      } else if (statusCode >= 500) {
        return FailureState.serverError(
          message: errorMessage,
          error: error,
          statusCode: statusCode,
          response: response,
        );
      }
    }

    return FailureState(
      message: _dioErrorMessages[errorType.name],
      error: exception.toString(),
      statusCode: response?.statusCode,
      response: response,
    );
  }

  /// Map a `FirebaseAuthException` to a `FailureState<T>`.
  // static FailureState<T> _handleFirebaseAuthException<T>(
  //   FirebaseAuthException exception,
  // ) {
  //   final firebaseAuthError = exception.code.toLowerCase().trim();
  //   return FailureState(
  //     message: _firebaseAuthErrorMessages[firebaseAuthError],
  //     error: exception.toString(),
  //   );
  // }

  /// Map a `GoogleSignInException` to a `FailureState<T>`.
  // static FailureState<T> _handleGoogleSignInException<T>(
  //   GoogleSignInException exception,
  // ) {
  //   final errorCode = exception.code.name;
  //   return FailureState(
  //     message: _googleSignInErrorMessages[errorCode],
  //     error: exception.toString(),
  //   );
  // }

  /// Internal debug logger used to print caught exceptions in debug mode.
  static void _debugError(Object? error, [StackTrace? stackTrace]) {
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
    'receiveTimeout': 'Receive timeout in connection. $kCheckInternet',
    'sendTimeout': 'Send timeout in connection. $kCheckInternet',
    'connectionTimeout': 'Connection timeout. $kCheckInternet',
    'badCertificate': 'Bad certificate. $kCustomerSupport',
  };

  // static const _firebaseAuthErrorMessages = {
  //   'invalid-credential': 'The given user was not found on the server!',
  //   'user-not-found': 'The given user was not found on the server!',
  //   'wrong-password':
  //       'The password is invalid or the user does not have a password.',
  //   'weak-password':
  //       'Please choose a stronger password consisting of more characters!',
  //   'invalid-email':
  //       'Invalid email. Please double check your email and try again!',
  //   'operation-not-allowed':
  //       'You cannot register using this method at this moment!',
  //   'email-already-in-use':
  //       'Email already in use.Please choose another email to register with!',
  //   'requires-recent-login':
  //       'You need to log out and log back in again in order to perform this operation',
  //   'no-current-user': 'No current user with this information was found',
  //   'user-disabled': 'This user account has been disabled.',
  //   'too-many-requests': 'Too many requests. Try again later.',
  //   'account-exists-with-different-credential':
  //       'An account already exists with a different credential.',
  //   'invalid-verification-code': 'The verification code is invalid or expired.',
  //   'invalid-verification-id': 'The verification ID is invalid.',
  //   'network-request-failed':
  //       'Network error. Please check your internet connection and try again!',
  //   'unknown': 'Unknown authentication error',
  // };

  // static const _googleSignInErrorMessages = {
  //   'unknownError':
  //       'An unknown error occurred during Google Sign-In. Please try again.',
  //   'canceled':
  //       'The sign-in process was canceled. Please try again if you want to sign in.',
  //   'interrupted': 'The sign-in process was interrupted. Please try again.',
  //   'clientConfigurationError':
  //       'Google Sign-In is not configured correctly on this app. Please contact support.',
  //   'providerConfigurationError':
  //       'There is a problem with the Google Sign-In provider configuration. Please contact support.',
  //   'uiUnavailable':
  //       'The sign-in UI could not be displayed. This might be a temporary issue, please try again.',
  //   'userMismatch':
  //       'The user trying to sign in is different from the one already signed in. Please sign out first.',
  // };
}
