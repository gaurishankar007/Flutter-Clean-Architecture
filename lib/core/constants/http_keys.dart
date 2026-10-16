/// Keys used when building or intercepting HTTP requests, instead of raw
/// string literals.
abstract final class HttpKeys {
  // Per-request `Options(extra: {...})` flags read by `HttpAuthInterceptor`.

  /// Skips attaching the Authorization header to the request.
  static const excludeAuth = 'excludeAuth';

  // HTTP header names.

  static const authorization = 'Authorization';
  static const contentType = 'Content-Type';
}
