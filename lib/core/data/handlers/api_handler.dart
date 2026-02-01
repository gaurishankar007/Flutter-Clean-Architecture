import 'package:clean_architecture/core/data/handlers/error_handler.dart';
import 'package:clean_architecture/core/data/states/data_state.dart';
import 'package:clean_architecture/core/utils/type_defs.dart';
import 'package:dio/dio.dart';

/// A dedicated executor for API operations, providing safe execution of
/// HTTP requests, standard response normalization, and error mapping.
abstract final class ApiHandler {
  /// Executes a request and parses the response into [T].
  ///
  /// Use [fromJson] to deserialize the data. If [isStandardResponse] is true,
  /// it extracts the payload from [responseDataKey] before parsing.
  static FutureData<T> call<T, R>(
    Future<Response<dynamic>> Function() request, {
    R Function(MapDynamic json)? fromJson,
    bool isStandardResponse = true,
    String responseDataKey = 'data',
  }) {
    return ErrorHandler.execute(() async {
      final response = await request();
      dynamic rawData = response.data;
      String? responseMessage;

      FailureState<T> failure(String error) => FailureState.badResponse(
        error: error,
        statusCode: response.statusCode,
        response: response,
      );
      SuccessState<T> success(T data) => SuccessState(
        data: data,
        message: responseMessage,
        statusCode: response.statusCode,
        response: response,
      );

      // 1. Get message from the response if provided
      if (rawData is MapDynamic) {
        if (rawData['message'] case final String? message) {
          responseMessage = message;
        }
      }

      // 2. Handle standard API response structure if required
      if (isStandardResponse) {
        if (rawData is! MapDynamic) {
          return failure('Bad response format: ${rawData.runtimeType}');
        }
        if (!rawData.containsKey(responseDataKey)) {
          return failure('Response missing expected key: "$responseDataKey"');
        }
        rawData = rawData[responseDataKey];
      }
      // 3. Handle JSON deserialization
      if (fromJson != null) {
        if (rawData is MapDynamic) {
          return success(fromJson(rawData) as T);
        } else if (rawData is List) {
          return success(
            rawData.map((e) => fromJson(e as MapDynamic)).toList() as T,
          );
        }
        return failure('Expected Map or List but got ${rawData.runtimeType}');
      }
      // 4. Handle raw data without deserialization
      if (rawData is T) {
        return success(rawData);
      }

      return failure('Type mismatch: Expected $T, got ${rawData.runtimeType}');
    });
  }

  /// Executes a request and returns a success state without data.
  ///
  /// Useful for endpoints where the response body is not needed.
  static FutureVoid voidCall(Future<Response<dynamic>> Function() request) {
    return ErrorHandler.execute(() async {
      final response = await request();
      final rawData = response.data;
      String? responseMessage;

      // 1. Get message from the response if provided
      if (rawData is MapDynamic) {
        if (rawData['message'] case final String? message) {
          responseMessage = message;
        }
      }

      return SuccessState<void>(
        data: null,
        message: responseMessage,
        statusCode: response.statusCode,
        response: response,
      );
    });
  }

  /// Executes a request and returns [staticData] on success.
  ///
  /// Useful when the API response is ignored in favor of a local value (e.g., returning `true`).
  static FutureData<T> staticCall<T>(
    Future<Response<dynamic>> Function() request, {
    required T staticData,
  }) {
    return ErrorHandler.execute(() async {
      final response = await request();
      final rawData = response.data;
      String? responseMessage;

      // 1. Get message from the response if provided
      if (rawData is MapDynamic) {
        if (rawData['message'] case final String? message) {
          responseMessage = message;
        }
      }

      return SuccessState<T>(
        data: staticData,
        message: responseMessage,
        statusCode: response.statusCode,
        response: response,
      );
    });
  }
}
