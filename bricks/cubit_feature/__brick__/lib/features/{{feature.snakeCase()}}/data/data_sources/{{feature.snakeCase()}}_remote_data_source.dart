import 'package:clean_architecture/core/clients/remote/http/http_client.dart';
import 'package:clean_architecture/core/data/handlers/api_handler.dart';
import 'package:clean_architecture/core/utils/type_defs.dart';
import 'package:injectable/injectable.dart';

abstract interface class {{feature.pascalCase()}}RemoteDataSource {}

@LazySingleton(as: {{feature.pascalCase()}}RemoteDataSource)
final class {{feature.pascalCase()}}RemoteDataSourceImpl implements {{feature.pascalCase()}}RemoteDataSource {
  const {{feature.pascalCase()}}RemoteDataSourceImpl({
    required HttpClient httpClient,
  }) : _httpClient = httpClient;

  final HttpClient _httpClient;
}
