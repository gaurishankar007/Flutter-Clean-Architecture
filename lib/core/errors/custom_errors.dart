///
class WebCameraException implements Exception {
  const WebCameraException({this.message, this.error});

  final String? message;
  final String? error;

  @override
  String toString() => 'WebCameraException(message: $message, error: $error)';
}
