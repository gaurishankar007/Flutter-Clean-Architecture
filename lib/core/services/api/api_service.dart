// ignore_for_file: depend_on_referenced_packages

import 'dart:developer';

import 'package:alice/alice.dart';
import 'package:alice/model/alice_configuration.dart';
import 'package:alice_dio/alice_dio_adapter.dart';
import 'package:clean_architecture/config/app_config.dart';
import 'package:clean_architecture/core/constants/api_endpoints.dart';
import 'package:clean_architecture/core/data/models/requests/refresh_token_request.dart';
import 'package:clean_architecture/core/data/models/responses/api_response.dart';
import 'package:clean_architecture/core/data/models/responses/refresh_token_response.dart';
import 'package:clean_architecture/core/services/navigation/navigation_service.dart';
import 'package:clean_architecture/core/services/session/session_service.dart';
import 'package:clean_architecture/core/utils/type_defs.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:http_parser/http_parser.dart';
import 'package:injectable/injectable.dart';

part 'auth_interceptor.dart';
part 'multipart_service.dart';

/// Convenience methods to make an HTTP PATCH request.
abstract interface class ApiService {
  Future<Response> get<T>(
    String path, {
    final Object? data,
    final Map<String, dynamic>? queryParameters,
    final Options? options,
    final CancelToken? cancelToken,
    final ProgressCallback? onSendProgress,
    final ProgressCallback? onReceiveProgress,
  });

  Future<Response> post<T>(
    String path, {
    final Object? data,
    final Map<String, dynamic>? queryParameters,
    final Options? options,
    final CancelToken? cancelToken,
    final ProgressCallback? onSendProgress,
    final ProgressCallback? onReceiveProgress,
  });

  Future<Response> put<T>(
    String path, {
    final Object? data,
    final Map<String, dynamic>? queryParameters,
    final Options? options,
    final CancelToken? cancelToken,
    final ProgressCallback? onSendProgress,
    final ProgressCallback? onReceiveProgress,
  });

  Future<Response> patch<T>(
    String path, {
    final Object? data,
    final Map<String, dynamic>? queryParameters,
    final Options? options,
    final CancelToken? cancelToken,
    final ProgressCallback? onSendProgress,
    final ProgressCallback? onReceiveProgress,
  });

  Future<Response> delete<T>(
    String path, {
    final Object? data,
    final Map<String, dynamic>? queryParameters,
    final Options? options,
    final CancelToken? cancelToken,
  });
}

@module
abstract class ApiServiceModule {
  @lazySingleton
  Dio get dio => Dio();

  @injectable
  bool get addInterceptors => false;
}

@LazySingleton(as: ApiService)
final class ApiServiceImpl implements ApiService {
  final Dio _dio;

  ApiServiceImpl({
    required Dio dio,
    required AppConfig appConfig,
    required AuthInterceptor authInterceptor,
    required NavigationService navigationService,
    bool addInterceptors = false,
  }) : _dio = dio {
    _dio.options = BaseOptions(
      baseUrl: appConfig.apiBaseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      sendTimeout: const Duration(seconds: 15),
      headers: {"Content-Type": "application/json"},
    );

    if (addInterceptors) {
      /// Alice Configuration
      final alice = Alice(
        configuration: AliceConfiguration(
          navigatorKey: navigationService.navigatorKey,
          showNotification: true,
          showInspectorOnShake: true,
          showShareButton: true,
        ),
      );
      AliceDioAdapter aliceDioAdapter = AliceDioAdapter();
      alice.addAdapter(aliceDioAdapter);
      _dio.interceptors.addAll([authInterceptor, aliceDioAdapter]);
    }
  }

  @override
  Future<Response> get<T>(
    String path, {
    final Object? data,
    final Map<String, dynamic>? queryParameters,
    final Options? options,
    final CancelToken? cancelToken,
    final ProgressCallback? onSendProgress,
    final ProgressCallback? onReceiveProgress,
  }) async => await _dio.get(
    path,
    data: data,
    queryParameters: queryParameters,
    options: options,
    cancelToken: cancelToken,
    onReceiveProgress: onReceiveProgress,
  );

  @override
  Future<Response> post<T>(
    String path, {
    final Object? data,
    final Map<String, dynamic>? queryParameters,
    final Options? options,
    final CancelToken? cancelToken,
    final ProgressCallback? onSendProgress,
    final ProgressCallback? onReceiveProgress,
  }) async => await _dio.post(
    path,
    data: data,
    queryParameters: queryParameters,
    options: options,
    cancelToken: cancelToken,
    onSendProgress: onSendProgress,
    onReceiveProgress: onReceiveProgress,
  );

  @override
  Future<Response> put<T>(
    String path, {
    final Object? data,
    final Map<String, dynamic>? queryParameters,
    final Options? options,
    final CancelToken? cancelToken,
    final ProgressCallback? onSendProgress,
    final ProgressCallback? onReceiveProgress,
  }) async => await _dio.put(
    path,
    data: data,
    queryParameters: queryParameters,
    options: options,
    cancelToken: cancelToken,
    onSendProgress: onSendProgress,
    onReceiveProgress: onReceiveProgress,
  );

  @override
  Future<Response> patch<T>(
    String path, {
    final Object? data,
    final Map<String, dynamic>? queryParameters,
    final Options? options,
    final CancelToken? cancelToken,
    final ProgressCallback? onSendProgress,
    final ProgressCallback? onReceiveProgress,
  }) async => await _dio.patch(
    path,
    data: data,
    queryParameters: queryParameters,
    options: options,
    cancelToken: cancelToken,
    onSendProgress: onSendProgress,
    onReceiveProgress: onReceiveProgress,
  );

  @override
  Future<Response> delete<T>(
    String path, {
    final Object? data,
    final Map<String, dynamic>? queryParameters,
    final Options? options,
    final CancelToken? cancelToken,
  }) async => await _dio.delete(
    path,
    data: data,
    queryParameters: queryParameters,
    options: options,
    cancelToken: cancelToken,
  );
}
