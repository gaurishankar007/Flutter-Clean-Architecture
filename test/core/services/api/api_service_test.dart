import 'package:clean_architecture/config/app_config.dart';
import 'package:clean_architecture/core/services/api/api_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../testing/mocks/external/external_mocks.dart';
import '../../../../testing/mocks/service_mocks.dart';

void main() {
  late MockDio mockDio;
  late MockAuthInterceptor mockAuthInterceptor;
  late MockNavigationService mockNavigationService;
  late ApiServiceImpl apiService;
  late AppConfig appConfig;

  setUpAll(() async {
    await dotenv.load();

    mockDio = MockDio();
    mockAuthInterceptor = MockAuthInterceptor();
    mockNavigationService = MockNavigationService();
    appConfig = AppConfigDev();
  });

  setUp(() {
    when(
      () => mockNavigationService.navigatorKey,
    ).thenReturn(GlobalKey<NavigatorState>());

    apiService = ApiServiceImpl(
      appConfig: appConfig,
      authInterceptor: mockAuthInterceptor,
      dio: mockDio,
      navigationService: mockNavigationService,
    );
  });

  group('Api Service Implementation', () {
    test('get calls Dio.get with correct arguments', () async {
      final response = Response<dynamic>(
        requestOptions: RequestOptions(path: '/test'),
      );
      when(
        () => mockDio.get<dynamic>(
          any(),
          data: any(named: 'data'),
          queryParameters: any(named: 'queryParameters'),
          options: any(named: 'options'),
          cancelToken: any(named: 'cancelToken'),
          onReceiveProgress: any(named: 'onReceiveProgress'),
        ),
      ).thenAnswer((_) async => response);

      final result = await apiService.get<dynamic>('/test', data: {'a': 1});

      expect(result, response);
      verify(() => mockDio.get<dynamic>('/test', data: {'a': 1})).called(1);
    });

    test('post calls Dio.post with correct arguments', () async {
      final response = Response<dynamic>(
        requestOptions: RequestOptions(path: '/test'),
      );
      when(
        () => mockDio.post<dynamic>(
          any(),
          data: any(named: 'data'),
          queryParameters: any(named: 'queryParameters'),
          options: any(named: 'options'),
          cancelToken: any(named: 'cancelToken'),
          onSendProgress: any(named: 'onSendProgress'),
          onReceiveProgress: any(named: 'onReceiveProgress'),
        ),
      ).thenAnswer((_) async => response);

      final result = await apiService.post<dynamic>('/test', data: {'b': 2});

      expect(result, response);
      verify(() => mockDio.post<dynamic>('/test', data: {'b': 2})).called(1);
    });

    test('put calls Dio.put with correct arguments', () async {
      final response = Response<dynamic>(
        requestOptions: RequestOptions(path: '/test'),
      );
      when(
        () => mockDio.put<dynamic>(
          any(),
          data: any(named: 'data'),
          queryParameters: any(named: 'queryParameters'),
          options: any(named: 'options'),
          cancelToken: any(named: 'cancelToken'),
          onSendProgress: any(named: 'onSendProgress'),
          onReceiveProgress: any(named: 'onReceiveProgress'),
        ),
      ).thenAnswer((_) async => response);

      final result = await apiService.put<dynamic>('/test', data: {'c': 3});

      expect(result, response);
      verify(() => mockDio.put<dynamic>('/test', data: {'c': 3})).called(1);
    });

    test('patch calls Dio.patch with correct arguments', () async {
      final response = Response<dynamic>(
        requestOptions: RequestOptions(path: '/test'),
      );
      when(
        () => mockDio.patch<dynamic>(
          any(),
          data: any(named: 'data'),
          queryParameters: any(named: 'queryParameters'),
          options: any(named: 'options'),
          cancelToken: any(named: 'cancelToken'),
          onSendProgress: any(named: 'onSendProgress'),
          onReceiveProgress: any(named: 'onReceiveProgress'),
        ),
      ).thenAnswer((_) async => response);

      final result = await apiService.patch<dynamic>('/test', data: {'d': 4});

      expect(result, response);
      verify(() => mockDio.patch<dynamic>('/test', data: {'d': 4})).called(1);
    });

    test('delete calls Dio.delete with correct arguments', () async {
      final response = Response<dynamic>(
        requestOptions: RequestOptions(path: '/test'),
      );
      when(
        () => mockDio.delete<dynamic>(
          any(),
          data: any(named: 'data'),
          queryParameters: any(named: 'queryParameters'),
          options: any(named: 'options'),
          cancelToken: any(named: 'cancelToken'),
        ),
      ).thenAnswer((_) async => response);

      final result = await apiService.delete<dynamic>('/test', data: {'e': 5});

      expect(result, response);
      verify(() => mockDio.delete<dynamic>('/test', data: {'e': 5})).called(1);
    });
  });
}
