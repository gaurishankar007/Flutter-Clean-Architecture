// ignore_for_file: constant_identifier_names

part of 'data_state.dart';

const String CUSTOMER_SUPPORT = "Please contact our customer support.";
const String ERROR_MESSAGE = "Unexpected error occurred. $CUSTOMER_SUPPORT";
const String CHECK_INTERNET = "Please check your internet and try again.";

enum ErrorType {
  unknown,
  typeError,
  formatError,
  isarError,
  firebaseAuthError,
  googleSignInError,
  dioError,
  internetError,
  requestError,
  responseError,
  serverError,
  tokenError,
}

/// A failure data state when error occurs
final class FailureState<T> extends DataState<T> {
  const FailureState({String? message, ErrorType? errorType, super.statusCode})
    : super(
        message: message ?? ERROR_MESSAGE,
        errorType: errorType ?? ErrorType.unknown,
        hasError: true,
      );

  /// A failure data state when type error occurs
  factory FailureState.typeError() => const FailureState(
    message: "Error occurred. Unsupported data type is assigned.",
    errorType: ErrorType.typeError,
  );

  /// A failure data state when format exception occurs
  factory FailureState.formatError() => const FailureState(
    message: "Error occurred. Operation on unsupported data format.",
    errorType: ErrorType.formatError,
  );

  /// A failure data state when invalid data is provided to the server
  factory FailureState.badRequest({String? message, int? statusCode}) =>
      FailureState(
        message: message ?? "Bad request. Please try again",
        errorType: ErrorType.requestError,
        statusCode: statusCode,
      );

  /// A failure data state when the user's token is expired
  factory FailureState.tokenExpired() => const FailureState(
    message: "Token is expired. Login again.",
    errorType: ErrorType.tokenError,
  );

  /// A failure data state when the response of the server is invalid
  factory FailureState.badResponse({String? message, int? statusCode}) =>
      FailureState(
        message: message ?? "Invalid server response.",
        errorType: ErrorType.responseError,
        statusCode: statusCode,
      );

  /// A failure data state when error occurs in the server
  factory FailureState.serverError({String? message, int? statusCode}) =>
      FailureState(
        message: message ?? "Server error occurred. $CUSTOMER_SUPPORT",
        errorType: ErrorType.serverError,
        statusCode: statusCode,
      );

  /// A failure data state when there is no internet access
  factory FailureState.noInternet() => const FailureState(
    message: "No internet access.",
    errorType: ErrorType.internetError,
  );
}
