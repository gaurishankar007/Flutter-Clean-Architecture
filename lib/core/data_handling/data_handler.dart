import 'dart:developer' show log;

import 'package:clean_architecture/core/data/models/domain_convertible.dart';
import 'package:clean_architecture/core/data_states/data_state.dart';
import 'package:clean_architecture/core/utils/type_defs.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show kDebugMode;

part 'error_handler.dart';

/// A centralized handler for data operations, providing safe execution of
/// API calls, network fallback strategies, and error handling.
///
/// Wraps all operations in a [DataState] to consistently represent
/// success, failure, or loading states across the application.
abstract final class DataHandler {
  /// Execute an HTTP request safely and normalize the result into a [DataState].
  ///
  /// This method centralizes common API response handling and error mapping.
  ///
  /// Generics:
  /// - `T` — the final return type wrapped by the returned [DataState] (for
  ///   example a domain model, a DTO, `List<T>`, or a primitive).
  /// - `R` — the deserialization type produced by [fromJson] (commonly a DTO
  ///   type or `Map<String, dynamic>`). When the response body is a list,
  ///   the method will call [fromJson] for each element and return `List<R>`
  ///   casted to `T`.
  ///
  /// Behavior:
  /// - If [isStandardResponse] is `true` (the default), the method expects a
  ///   JSON object shaped like `{ "data": <payload>, "message": "..." }`.
  ///   The payload is extracted using [responseDataKey] (default: `'data'`).
  /// - If [fromJson] is provided, it will be used to convert a `Map<String, dynamic>`
  ///   (single object) or each element of a `List` into an `R` instance.
  /// - If [staticData] is non-null it is returned directly. If [useStaticDataAsNull]
  ///   is true, `staticData` will be used even when it is `null` (allowing an
  ///   explicit `SuccessState(data: null)`).
  /// - If neither [fromJson] nor [staticData] are provided, the raw response
  ///   body will be returned when it is already assignable to `T`.
  ///
  /// Returns a [SuccessState<T>] on success or a [FailureState<T>] describing
  /// the error (format errors, bad response structure, or other mapped errors).
  static FutureData<T> safeApiCall<T, R>({
    required Future<Response> Function() request,
    R Function(Map<String, dynamic> json)? fromJson,
    bool isStandardResponse = true,
    String responseDataKey = 'data',
    T? staticData,
    bool useStaticDataAsNull = false,
  }) {
    return ErrorHandler.handleException(() async {
      final Response response = await request();
      dynamic rawData = response.data;
      String? responseMessage;
      T? data;

      // Handle standard API response structure
      if (isStandardResponse && staticData == null) {
        if (rawData is! Map<String, dynamic>) {
          return FailureState.badResponse(
            message:
                'Expected standard response format but got ${rawData.runtimeType}',
          );
        }
        // Returns bad response failure state if the response structure is not standard
        if (!rawData.containsKey(responseDataKey)) {
          return FailureState.badResponse(
            message: 'Response missing expected key: "$responseDataKey"',
          );
        }

        responseMessage = rawData['message'];
        rawData = rawData[responseDataKey];
      }

      // Handle static data return
      if (staticData != null || useStaticDataAsNull) {
        data = staticData;
      }
      // Handle JSON deserialization
      else if (fromJson != null) {
        if (rawData is Map<String, dynamic>) {
          data = fromJson(rawData) as T;
        } else if (rawData is List) {
          data = rawData.map((json) => fromJson(json)).toList() as T;
        } else {
          return FailureState(
            message:
                'Expected Map or List for deserialization but got ${rawData.runtimeType}',
            errorType: ErrorType.formatError,
          );
        }
      }
      // Handle raw data without deserialization
      else if (rawData is T) {
        data = rawData;
      } else {
        return FailureState(
          message: 'Type mismatch: Expected $T, got ${rawData.runtimeType}',
          errorType: ErrorType.formatError,
        );
      }

      return SuccessState(
        data: data,
        message: responseMessage,
        statusCode: response.statusCode,
      );
    });
  }

  /// Fetches data with a network fallback strategy.
  ///
  /// High-level helper that chooses between a remote source and a local fallback:
  /// - If [isInternetConnected] is `true` it calls [remoteCallback] and returns
  ///   its [DataState]. If the returned state contains non-null `data` and
  ///   [onRemoteSuccess] is supplied, that callback is invoked with the raw
  ///   result (useful for caching the DTO).
  /// - If [isInternetConnected] is `false`, the method will call [localCallback]
  ///   (if provided) and return its result. If no local fallback is provided,
  ///   a `FailureState.noInternet()` is returned.
  static FutureData<T> fetchWithFallback<T>(
    bool isInternetConnected, {
    required FutureData<T> Function() remoteCallback,
    Function(T data)? onRemoteSuccess,
    FutureData<T> Function()? localCallback,
  }) async {
    if (isInternetConnected) {
      final dataState = await remoteCallback();
      final data = dataState.data;

      // Optional: Perform an action on successful remote fetch (e.g., cache the data)
      if (data != null && onRemoteSuccess != null) onRemoteSuccess(data);
      return dataState;
    }

    // Fallback to local data source or return no internet error
    return localCallback?.call() ?? FailureState.noInternet();
  }

  /// Fetches and transforms data with a network fallback strategy.
  /// Fetches a DTO from remote/local and maps it to a domain model.
  ///
  /// This variant expects the DTO type `T` to implement [DomainConvertible<R>].
  /// It will invoke `dto.toDomain()` internally so callers do not need to
  /// provide a mapping function. Use this when your data layer objects implement
  /// `toDomain()` to convert themselves to the domain representation.
  ///
  /// - `isInternetConnected` controls whether the remote or local path is used.
  /// - `remoteCallback` must return a [DataState] wrapping the DTO (`T`). If
  ///   the remote fetch succeeds and [onRemoteSuccess] is provided it will be
  ///   called with the raw DTO (before mapping) — useful for persisting the
  ///   original DTO to cache.
  /// - `localCallback` is an optional fallback called when offline.
  ///
  /// The returned [DataState] contains the mapped domain model `R` on success
  /// or the propagated failure state on error.
  static FutureData<R>
  fetchWithFallbackAndMap<T extends DomainConvertible<R>, R>(
    bool isInternetConnected, {
    required FutureData<T> Function() remoteCallback,
    Function(T data)? onRemoteSuccess,
    FutureData<T> Function()? localCallback,
  }) async {
    final DataState<T> dtoState = await fetchWithFallback(
      isInternetConnected,
      remoteCallback: remoteCallback,
      onRemoteSuccess: onRemoteSuccess,
      localCallback: localCallback,
    );

    // Transform the DataState containing the DTO (T) to a DataState containing the Domain Model (R)
    return dtoState.mapData((dto) => dto.toDomain());
  }

  static FutureList<R>
  fetchWithFallbackAndMapList<T extends DomainConvertible<R>, R>(
    bool isInternetConnected, {
    required FutureList<T> Function() remoteCallback,
    Function(List<T> data)? onRemoteSuccess,
    FutureData<List<T>> Function()? localCallback,
  }) async {
    final DataState<List<T>> dtoState = await fetchWithFallback(
      isInternetConnected,
      remoteCallback: remoteCallback,
      onRemoteSuccess: onRemoteSuccess,
      localCallback: localCallback,
    );

    return dtoState.mapData((list) => list.map((e) => e.toDomain()).toList());
  }

  /// Fetches a DTO from local storage and maps it to a domain model.
  ///
  /// The `localCallback` should return a [DataState] containing a DTO `T` that
  /// implements [DomainConvertible<R>]. On success the DTO is converted to the
  /// domain type by calling `dto.toDomain()` and returned in a [SuccessState<R>].
  /// Failure states returned by the `localCallback` are propagated unchanged.
  static FutureData<R> fetchFromLocalAndMap<T extends DomainConvertible<R>, R>({
    required FutureData<T> Function() localCallback,
  }) async {
    // Error handling is expected to be implemented within the localCallback,
    // similar to how remote data sources handle exceptions.
    final dtoState = await localCallback();
    return dtoState.mapData((dto) => dto.toDomain());
  }

  /// Fetches a list of DTOs from local storage and maps them to domain models.
  ///
  /// The `localCallback` should return a [DataState] containing a `List<T>` where
  /// each `T` implements [DomainConvertible<R>]. On success the list elements
  /// are converted by calling `toDomain()` on each DTO and returned inside a
  /// [SuccessState<List<R>>]. Any failure state returned by the `localCallback`
  /// is propagated unchanged.
  static FutureList<R> fetchFromLocalAndMapList<
    T extends DomainConvertible<R>,
    R
  >({required FutureList<T> Function() localCallback}) async {
    final dtoState = await localCallback();
    return dtoState.mapData((list) => list.map((e) => e.toDomain()).toList());
  }
}
