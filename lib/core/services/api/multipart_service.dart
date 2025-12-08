part of 'api_service.dart';

abstract interface class MultiPartService {
  Future<MultipartFile> multipartFromFile(
    String filePath, {
    String? filename,
    MediaType? contentType,
    Map<String, List<String>>? headers,
  });
}

/// A file to be uploaded as part of a [MultipartRequest]. This doesn't need to
/// correspond to a physical file.
///
/// MultipartFile is based on stream, and a stream can be read only once,
/// so the same MultipartFile can't be read multiple times.
final class MultiPartServiceImpl implements MultiPartService {
  @override
  Future<MultipartFile> multipartFromFile(
    String filePath, {
    String? filename,
    MediaType? contentType,
    Map<String, List<String>>? headers,
  }) async => await MultipartFile.fromFile(
    filePath,
    filename: filename,
    contentType: contentType,
    headers: headers,
  );
}
