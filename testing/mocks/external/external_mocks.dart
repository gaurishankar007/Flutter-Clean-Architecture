import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockDio extends Mock implements Dio {}

class MockDioException extends Mock implements DioException {}

class MockConnectivity extends Mock implements Connectivity {}

class MockSharedPreferences extends Mock implements SharedPreferences {}

class MockResponse<T> extends Mock implements Response<T> {}
