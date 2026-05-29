import 'package:clean_architecture/core/clients/local/local_storage_client.dart';
import 'package:clean_architecture/core/errors/error_handler.dart';
import 'package:injectable/injectable.dart';


abstract interface class {{feature.pascalCase()}}LocalDataSource {}

@LazySingleton(as: {{feature.pascalCase()}}LocalDataSource)
final class {{feature.pascalCase()}}LocalDataSourceImpl implements {{feature.pascalCase()}}LocalDataSource {
  const {{feature.pascalCase()}}LocalDataSourceImpl({
    required ErrorHandler errorHandler,
    required LocalStorageClient localDatabase,
  }) : _errorHandler = errorHandler,
       _localDatabase = localDatabase;

  final ErrorHandler _errorHandler;
  final LocalStorageClient _localDatabase;
}
