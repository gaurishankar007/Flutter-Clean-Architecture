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
    await dotenv.load(fileName: ".env");

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
      addInterceptors: false,
    );
  });

  group('Api Service Implementation', () {
    test('get calls Dio.get with correct arguments', () async {
      final response = Response(requestOptions: RequestOptions(path: '/test'));
      when(
        () => mockDio.get(
          any(),
          data: any(named: 'data'),
          queryParameters: any(named: 'queryParameters'),
          options: any(named: 'options'),
          cancelToken: any(named: 'cancelToken'),
          onReceiveProgress: any(named: 'onReceiveProgress'),
        ),
      ).thenAnswer((_) async => response);

      final result = await apiService.get('/test', data: {'a': 1});

      expect(result, response);
      verify(() => mockDio.get('/test', data: {'a': 1})).called(1);
    });

    test('post calls Dio.post with correct arguments', () async {
      final response = Response(requestOptions: RequestOptions(path: '/test'));
      when(
        () => mockDio.post(
          any(),
          data: any(named: 'data'),
          queryParameters: any(named: 'queryParameters'),
          options: any(named: 'options'),
          cancelToken: any(named: 'cancelToken'),
          onSendProgress: any(named: 'onSendProgress'),
          onReceiveProgress: any(named: 'onReceiveProgress'),
        ),
      ).thenAnswer((_) async => response);

      final result = await apiService.post('/test', data: {'b': 2});

      expect(result, response);
      verify(
        () => mockDio.post('/test', data: {'b': 2}, queryParameters: null),
      ).called(1);
    });

    test('put calls Dio.put with correct arguments', () async {
      final response = Response(requestOptions: RequestOptions(path: '/test'));
      when(
        () => mockDio.put(
          any(),
          data: any(named: 'data'),
          queryParameters: any(named: 'queryParameters'),
          options: any(named: 'options'),
          cancelToken: any(named: 'cancelToken'),
          onSendProgress: any(named: 'onSendProgress'),
          onReceiveProgress: any(named: 'onReceiveProgress'),
        ),
      ).thenAnswer((_) async => response);

      final result = await apiService.put('/test', data: {'c': 3});

      expect(result, response);
      verify(
        () => mockDio.put(
          '/test',
          data: {'c': 3},
          queryParameters: null,
          options: null,
          cancelToken: null,
          onSendProgress: null,
          onReceiveProgress: null,
        ),
      ).called(1);
    });

    test('patch calls Dio.patch with correct arguments', () async {
      final response = Response(requestOptions: RequestOptions(path: '/test'));
      when(
        () => mockDio.patch(
          any(),
          data: any(named: 'data'),
          queryParameters: any(named: 'queryParameters'),
          options: any(named: 'options'),
          cancelToken: any(named: 'cancelToken'),
          onSendProgress: any(named: 'onSendProgress'),
          onReceiveProgress: any(named: 'onReceiveProgress'),
        ),
      ).thenAnswer((_) async => response);

      final result = await apiService.patch('/test', data: {'d': 4});

      expect(result, response);
      verify(
        () => mockDio.patch(
          '/test',
          data: {'d': 4},
          queryParameters: null,
          options: null,
          cancelToken: null,
          onSendProgress: null,
          onReceiveProgress: null,
        ),
      ).called(1);
    });

    test('delete calls Dio.delete with correct arguments', () async {
      final response = Response(requestOptions: RequestOptions(path: '/test'));
      when(
        () => mockDio.delete(
          any(),
          data: any(named: 'data'),
          queryParameters: any(named: 'queryParameters'),
          options: any(named: 'options'),
          cancelToken: any(named: 'cancelToken'),
        ),
      ).thenAnswer((_) async => response);

      final result = await apiService.delete('/test', data: {'e': 5});

      expect(result, response);
      verify(
        () => mockDio.delete(
          '/test',
          data: {'e': 5},
          queryParameters: null,
          options: null,
          cancelToken: null,
        ),
      ).called(1);
    });
  });
}
