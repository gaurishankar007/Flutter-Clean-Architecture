import 'package:dio/dio.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockDio extends Mock implements Dio {}

class MockDioException extends Mock implements DioException {}

class MockInternetConnection extends Mock implements InternetConnection {}

class MockSharedPreferences extends Mock implements SharedPreferences {}

class MockResponse<T> extends Mock implements Response<T> {}
