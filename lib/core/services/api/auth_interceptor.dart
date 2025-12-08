part of 'api_service.dart';

/// Modifies http requests and responses. Used to
/// * Add headers
/// * Modify data
/// * Refresh tokens
@LazySingleton()
interface class AuthInterceptor extends Interceptor {
  // Access the session service lazily via the locator to break circular DI.
  SessionService get _sessionManager => SessionUtil.I;
  final Dio _dio = Dio();

  /// This flag is to prevent multiple refresh token requests. If the request
  /// is in progress then other token refresh requests are discarded
  bool _isTokenBeingRefreshed = false;

  /// Whenever token is expired, the requests are added to the list.
  /// So that even if simultaneously multiple requests are made and
  /// token is expired, each requests are retried after refreshing token
  final List<DioRequestData> _pendingRequests = [];

  AuthInterceptor();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    /// Add authorization token if the user is logged in
    if (_sessionManager.isLoggedIn) {
      options.headers.addAll({
        "Authorization": "Bearer ${_sessionManager.accessToken}",
      });
    }

    return super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    /// If the error contains a status code of 401. That means token is expired.
    if (err.response?.statusCode == 401) {
      _pendingRequests.add(DioRequestData(error: err, handler: handler));

      /// Don't refresh token again, if it is already being refreshed
      if (_isTokenBeingRefreshed) return;
      _isTokenBeingRefreshed = true;

      bool tokenRefreshSucceed = await _refreshToken(err.requestOptions);

      /// If token refreshing is successful, retry the pending requests
      if (tokenRefreshSucceed) {
        for (final request in _pendingRequests) {
          try {
            final response = await _retryRequest(request.error.requestOptions);
            request.handler.resolve(response);
          } on DioException catch (error) {
            if (kDebugMode) log("Retry request: ${error.response.toString()}");
            request.handler.next(error);
          } catch (error) {
            if (kDebugMode) log("Retry request: ${error.toString()}");
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
      final request = RefreshTokenRequest(
        refreshToken: _sessionManager.refreshToken,
      );
      final response = await _dio.post(
        ApiEndpoints.refreshToken,
        data: request.toJson(),
        options: Options(headers: requestOptions.headers),
      );

      /// If api response is successful, return the new accessToken
      ApiResponse<MapDynamic> apiResponse = ApiResponse.fromResponse(response);
      if (apiResponse.success) {
        final tokenResponse = RefreshTokenResponse.fromJson(apiResponse.data);
        _sessionManager.refreshAccessToken(tokenResponse.accessToken);
        return true;
      }
    } on DioException catch (_) {
      _sessionManager.clearSessionData();
    } catch (error) {
      _sessionManager.clearSessionData();
      if (kDebugMode) log("Token refresh: ${error.toString()}");
    }

    return false;
  }

  Future<Response> _retryRequest(RequestOptions requestOptions) async {
    /// Reset authorization header
    requestOptions.headers.remove("Authorization");
    requestOptions.headers.addAll({
      "Authorization": "Bearer ${_sessionManager.accessToken}",
    });

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
  final DioException error;
  final ErrorInterceptorHandler handler;

  const DioRequestData({required this.error, required this.handler});
}
