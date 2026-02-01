part of 'http_client.dart';

abstract interface class MultiPartClient {
  Future<MultipartFile> multipartFromFile(
    String filePath, {
    String? filename,
    MediaType? contentType,
    Map<String, List<String>>? headers,
  });
}

/// A file to be uploaded as part of a MultipartRequest. This doesn't need to
/// correspond to a physical file.
///
/// MultipartFile is based on stream, and a stream can be read only once,
/// so the same MultipartFile can't be read multiple times.
final class MultiPartClientImpl implements MultiPartClient {
  @override
  Future<MultipartFile> multipartFromFile(
    String filePath, {
    String? filename,
    MediaType? contentType,
    Map<String, List<String>>? headers,
  }) => MultipartFile.fromFile(
    filePath,
    filename: filename,
    contentType: contentType,
    headers: headers,
  );
}
