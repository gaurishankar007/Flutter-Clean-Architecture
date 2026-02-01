import 'package:clean_architecture/config/app_config.dart';
import 'package:clean_architecture/core/clients/remote/http/http_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../testing/mocks/client_mocks.dart';
import '../../../../testing/mocks/external/external_mocks.dart';

void main() {
  late MockDio mockDio;
  late MockAuthInterceptor mockAuthInterceptor;
  late MockNavigationClient mockNavigationClient;
  late HttpClientImpl httpClient;
  late AppConfig appConfig;

  setUpAll(() async {
    await dotenv.load();

    mockDio = MockDio();
    mockAuthInterceptor = MockAuthInterceptor();
    mockNavigationClient = MockNavigationClient();
    appConfig = AppConfigDev();
  });

  setUp(() {
    when(
      () => mockNavigationClient.navigatorKey,
    ).thenReturn(GlobalKey<NavigatorState>());

    httpClient = HttpClientImpl(
      appConfig: appConfig,
      authInterceptor: mockAuthInterceptor,
      dio: mockDio,
      navigationClient: mockNavigationClient,
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

      final result = await httpClient.get<dynamic>('/test', data: {'a': 1});

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

      final result = await httpClient.post<dynamic>('/test', data: {'b': 2});

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

      final result = await httpClient.put<dynamic>('/test', data: {'c': 3});

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

      final result = await httpClient.patch<dynamic>('/test', data: {'d': 4});

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

      final result = await httpClient.delete<dynamic>('/test', data: {'e': 5});

      expect(result, response);
      verify(() => mockDio.delete<dynamic>('/test', data: {'e': 5})).called(1);
    });
  });
}
