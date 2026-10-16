import 'package:dio/browser.dart';
import 'package:dio/dio.dart';

// The API expects JSON, so every request is preflighted by design.
HttpClientAdapter createHttpClientAdapter() =>
    BrowserHttpClientAdapter(enableCORSWarning: false);
