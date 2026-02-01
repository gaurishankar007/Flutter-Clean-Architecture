part of 'http_client.dart';

/// Modifies http requests and responses. Used to
/// * Add headers
/// * Modify data
/// * Refresh tokens
@LazySingleton()
interface class HttpAuthInterceptor extends Interceptor {
  HttpAuthInterceptor();
  // Access services lazily via the locator
  LocalStorageClient get _localStorageClient => GetIt.I<LocalStorageClient>();
  NavigationClient get _navigationClient => GetIt.I<NavigationClient>();

  final Dio _dio = Dio();

  /// This flag is to prevent multiple refresh token requests. If the request
  /// is in progress then other token refresh requests are discarded
  bool _isTokenBeingRefreshed = false;

  /// Whenever token is expired, the requests are added to the list.
  /// So that even if simultaneously multiple requests are made and
  /// token is expired, each requests are retried after refreshing token
  final List<DioRequestData> _pendingRequests = [];

  UserDataResponse? get _userData {
    final stored = _localStorageClient.getString(LocalDbKeys.userData);
    if (stored != null && stored.isNotEmpty) {
      try {
        final map = jsonDecode(stored) as Map<String, dynamic>;
        return UserDataResponse.fromJson(map);
      } catch (_) {
        return null;
      }
    }
    return null;
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    /// Add authorization token if the user is logged in
    final token = _userData?.accessToken;
    if (token != null && token.isNotEmpty) {
      options.headers.addAll({'Authorization': 'Bearer $token'});
    }

    return super.onRequest(options, handler);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    /// If the error contains a status code of 401. That means token is expired.
    if (err.response?.statusCode == 401) {
      _pendingRequests.add(DioRequestData(error: err, handler: handler));

      /// Don't refresh token again, if it is already being refreshed
      if (_isTokenBeingRefreshed) {
        return;
      }
      _isTokenBeingRefreshed = true;

      final bool tokenRefreshSucceed = await _refreshToken(err.requestOptions);

      /// If token refreshing is successful, retry the pending requests
      if (tokenRefreshSucceed) {
        for (final request in _pendingRequests) {
          try {
            final response = await _retryRequest(request.error.requestOptions);
            request.handler.resolve(response);
          } on DioException catch (error) {
            if (kDebugMode) {
              log('Retry request: ${error.response}');
            }
            request.handler.next(error);
          } catch (error) {
            if (kDebugMode) {
              log('Retry request: $error');
            }
          }
        }
      }

      /// Clear pending requests
      _pendingRequests.clear();
      _isTokenBeingRefreshed = false;
      return;
    }

    return super.onError(err, handler);
  }

  /// Try to refresh access token. Log out the user if it fails.
  Future<bool> _refreshToken(RequestOptions requestOptions) async {
    try {
      final userData = _userData;
      if (userData == null) {
        _clearSessionData();
        return false;
      }

      final request = RefreshTokenRequest(refreshToken: userData.refreshToken);
      final response = await _dio.post<dynamic>(
        ApiEndpoints.refreshToken,
        data: request.toJson(),
        options: Options(headers: requestOptions.headers),
      );

      /// If api response is successful, update the accessToken
      final ApiResponse<MapDynamic> apiResponse = ApiResponse.fromResponse(
        response,
      );
      if (apiResponse.success) {
        final tokenResponse = RefreshTokenResponse.fromJson(apiResponse.data);
        final newUserData = userData..toDomain().copyWith(
          accessToken: tokenResponse.accessToken,
        );
        await _localStorageClient.setString(
          LocalDbKeys.userData,
          jsonEncode(newUserData.toJson()),
        );
        return true;
      }
    } on DioException catch (_) {
      _clearSessionData();
    } catch (error) {
      _clearSessionData();
      if (kDebugMode) {
        log('Token refresh: $error');
      }
    }

    return false;
  }

  void _clearSessionData() {
    _localStorageClient.remove(LocalDbKeys.userData);
    _navigationClient.replaceAllRoute(const LoginRoute());
  }

  Future<Response<dynamic>> _retryRequest(RequestOptions requestOptions) {
    /// Reset authorization header
    requestOptions.headers.remove('Authorization');
    final token = _userData?.accessToken;
    if (token != null) {
      requestOptions.headers.addAll({'Authorization': 'Bearer $token'});
    }

    /// RequestOptions with the same method, path, data,
    /// query parameters, but with new access token.
    final options = Options(
      method: requestOptions.method,
      headers: requestOptions.headers,
    );

    /// Retry the request with the new requestOptions.
    return _dio.request(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: options,
    );
  }
}

/// Stores failed dio request's data
class DioRequestData {
  const DioRequestData({required this.error, required this.handler});
  final DioException error;
  final ErrorInterceptorHandler handler;
}
