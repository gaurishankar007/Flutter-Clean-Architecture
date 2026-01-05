import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart' show immutable;

part 'failure_state.dart';
part 'loading_state.dart';
part 'success_state.dart';

@immutable
sealed class DataState<T> extends Equatable {
  /// Base immutable sealed class representing the state of asynchronous
  /// data operations. Subtypes are `SuccessState`, `FailureState` and
  /// `LoadingState`. This class holds optional metadata useful for
  /// UI and error handling.
  const DataState({
    this.data,
    this.message,
    this.error,
    this.statusCode,
    this.response,
    this.hasData = false,
    this.hasError = false,
  });

  /// The payload for successful operations. May be `null` for
  /// non-success states or when no data is available.
  final T? data;

  /// A user-facing, localized message suitable for display in UI.
  /// Present when an operation failed but a friendly message is known.
  final String? message;

  /// A raw error string (e.g. exception message or debug info). This
  /// is intended for logging or developer diagnostics rather than
  /// direct user display.
  final String? error;

  /// Optional HTTP or transport status code associated with this
  /// response (when applicable).
  final int? statusCode;

  /// The raw network response object (e.g. Dio Response), if available.
  final Response<dynamic>? response;

  /// Whether this state currently carries non-null data.
  final bool hasData;

  /// Whether this state represents an error condition.
  final bool hasError;

  /// Executes the matching callback depending on runtime subtype.
  /// - `success` receives the unwrapped `data` for `SuccessState`.
  /// - `failure` receives the friendly `message` and `errorType`.
  /// - `loading` is used for `LoadingState` and as a safe fallback.
  R when<R>({
    required R Function(T data) success,
    required R Function(String? message, String? error) failure,
    required R Function() loading,
  }) {
    if (this is SuccessState<T>) {
      return success((this as SuccessState<T>).data as T);
    } else if (this is FailureState<T>) {
      return failure(
        (this as FailureState<T>).message,
        (this as FailureState<T>).error,
      );
    } else if (this is LoadingState<T>) {
      return loading();
    } else {
      // Defensive fallback: treat unknown cases as loading.
      return loading();
    }
  }

  /// Similar to `when`, but passes the concrete state instance to the
  /// callbacks allowing access to all fields (`data`, `message`, etc.).
  /// If the runtime subtype is unknown, return a fresh `LoadingState`.
  R map<R>({
    required R Function(SuccessState<T> value) success,
    required R Function(FailureState<T> value) failure,
    required R Function(LoadingState<T> value) loading,
  }) {
    if (this is SuccessState<T>) {
      return success(this as SuccessState<T>);
    } else if (this is FailureState<T>) {
      return failure(this as FailureState<T>);
    } else if (this is LoadingState<T>) {
      return loading(this as LoadingState<T>);
    } else {
      return loading(LoadingState<T>());
    }
  }

  /// Transforms the contained `data` from `T` to `R` when the state is
  /// `SuccessState`. For `FailureState` and `LoadingState` the same
  /// logical state is returned but typed to `R`.
  DataState<R> mapData<R>(R Function(T data) transform) {
    return when(
      success: (data) => SuccessState<R>(
        data: transform(data),
        message: message,
        statusCode: statusCode,
        response: response,
      ),
      failure: (message, errorType) => FailureState<R>(
        message: message,
        error: error,
        statusCode: statusCode,
        response: response,
      ),
      loading: LoadingState<R>.new,
    );
  }

  @override
  List<Object?> get props => [
    data,
    message,
    error,
    statusCode,
    response,
    hasData,
    hasError,
  ];
}
