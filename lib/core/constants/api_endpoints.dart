class ApiEndpoints {
  ApiEndpoints._();

  /// Base
  static const auth = 'api/auth/';

  // Auth
  static const login = '${auth}login';
  static const refreshToken = '${auth}refreshToken';
  static const checkAuth = '${auth}check-auth';
}
