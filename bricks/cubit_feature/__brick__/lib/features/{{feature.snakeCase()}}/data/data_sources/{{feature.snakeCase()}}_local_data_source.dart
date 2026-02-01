import 'package:clean_architecture/core/clients/local/local_storage_client.dart';
import 'package:clean_architecture/core/data/handlers/error_handler.dart';
import 'package:injectable/injectable.dart';


abstract interface class {{feature.pascalCase()}}LocalDataSource {}

@LazySingleton(as: {{feature.pascalCase()}}LocalDataSource)
final class {{feature.pascalCase()}}LocalDataSourceImpl implements {{feature.pascalCase()}}LocalDataSource {
  {{feature.pascalCase()}}LocalDataSourceImpl({
    required LocalStorageClient localDatabase,
  }) : _localDatabase = localDatabase;

  final LocalStorageClient _localDatabase;
}
