import 'package:clean_architecture/core/data/states/data_state.dart';
import 'package:clean_architecture/core/errors/error_translators/error_translator.dart';
import 'package:clean_architecture/core/utils/type_defs.dart';
import 'package:dio/dio.dart';

final class DioErrorTranslator implements ErrorTranslator<DioException> {
  final _dioErrorMessages = {
    'connectionError': 'Connection error, host lookup failed.',
    'cancel': 'Request was cancelled',
    'receiveTimeout': 'Receive timeout in connection. $kCheckInternet',
    'sendTimeout': 'Send timeout in connection. $kCheckInternet',
    'connectionTimeout': 'Connection timeout. $kCheckInternet',
    'badCertificate': 'Bad certificate. $kCustomerSupport',
  };

  @override
  bool matches(Object error) => error is DioException;

  @override
  FailureState<T> translate<T>(DioException exception) {
    final errorType = exception.type;
    final response = exception.response;
    final statusCode = response?.statusCode ?? 0;

    /// If the server response contains error status codes
    if (errorType == .badResponse && response != null) {
      final errorMessage = _getErrorMessage(exception);
      final error = _getErrorDescription(exception);

      if (statusCode >= 400 && statusCode < 500) {
        return FailureState.badRequest(
          message: errorMessage,
          error: error,
          extra: response,
        );
      } else if (statusCode >= 500) {
        return FailureState.serverError(
          message: errorMessage,
          error: error,
          extra: response,
        );
      }
    }

    return FailureState(
      message: _dioErrorMessages[errorType.name],
      error: exception.toString(),
      extra: response,
    );
  }

  /// Returns the error message from the DioException response data if present.
  String? _getErrorMessage(DioException exception) {
    try {
      // Check whether the response body is a MapDynamic or not.
      if (exception.response?.data case final MapDynamic body) {
        // Check whether the response body contains the 'errors' key.
        if (body['errors'] case final MapDynamic errors) {
          var errorMessage = '';

          // Check if the error message is in the form of a list of strings.
          for (final value in errors.values) {
            if (value case final List<dynamic> messages) {
              final stringMessages = messages.whereType<String>().toList();
              errorMessage += stringMessages.join(' ');
              errorMessage += ' ';
            }
          }

          // Return the error message if it is not empty.
          if (errorMessage.isNotEmpty) {
            return errorMessage;
          }
        }

        // Check if the response body contains the 'message' key.
        if (body['message'] case final String message) {
          return message;
        }
      }
    } catch (_) {}

    return null;
  }

  /// Returns a formatted error string out of the DioException request/response data
  /// that is helpful for debugging purposes.
  String _getErrorDescription(DioException exception) {
    return '--> Method: ${exception.requestOptions.method}'
        '\n--> URL: ${exception.requestOptions.baseUrl}${exception.requestOptions.path}'
        '\n--> Request Headers: ${exception.requestOptions.headers}'
        '\n--> Request Data: ${exception.requestOptions.data}'
        '\n--> Request Query Parameters: ${exception.requestOptions.queryParameters}'
        '\n--> Response Status Code: ${exception.response?.statusCode}'
        '\n--> Response Headers: ${exception.response?.headers}'
        '\n--> Response Body: ${exception.response?.data}';
  }
}
