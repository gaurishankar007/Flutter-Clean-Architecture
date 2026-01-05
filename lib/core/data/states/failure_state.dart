part of 'data_state.dart';

const String kCustomerSupport = 'Please contact our customer support.';
const String kErrorMessage = 'Unexpected error occurred. $kCustomerSupport';
const String kCheckInternet = 'Please check your internet and try again.';
const String kNoInternet = 'No internet access. Please try again later.';

/// A failure data state when error occurs
final class FailureState<T> extends DataState<T> {
  const FailureState({
    String? message,
    super.error,
    super.statusCode,
    super.response,
  }) : super(message: message ?? kErrorMessage, hasError: true);

  /// A failure data state when invalid data is provided to the server
  factory FailureState.badRequest({
    String? message,
    String? error,
    int? statusCode,
    Response<dynamic>? response,
  }) => FailureState(
    message: message ?? 'Bad client request. Please try again',
    error: error,
    statusCode: statusCode,
    response: response,
  );

  /// A failure data state when the user's token is expired
  factory FailureState.tokenExpired() =>
      const FailureState(message: 'Token expired, login again.');

  /// A failure data state when the response of the server is invalid
  factory FailureState.badResponse({
    String? message,
    String? error,
    int? statusCode,
    Response<dynamic>? response,
  }) => FailureState(
    message: message ?? 'Bad server response.',
    error: error,
    statusCode: statusCode,
    response: response,
  );

  /// A failure data state when error occurs in the server
  factory FailureState.serverError({
    String? message,
    String? error,
    int? statusCode,
    Response<dynamic>? response,
  }) => FailureState(
    message: message ?? 'Server error occurred. $kCustomerSupport',
    error: error,
    statusCode: statusCode,
    response: response,
  );

  /// A failure data state when there is no internet access
  factory FailureState.noInternet() =>
      const FailureState(message: kNoInternet, error: kNoInternet);
}
