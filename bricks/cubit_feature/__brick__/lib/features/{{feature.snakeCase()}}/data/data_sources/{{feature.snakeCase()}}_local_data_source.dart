import 'package:clean_architecture/core/services/database/local_database_service.dart';
import 'package:injectable/injectable.dart';


abstract interface class {{feature.pascalCase()}}LocalDataSource {}

@LazySingleton(as: {{feature.pascalCase()}}LocalDataSource)
final class {{feature.pascalCase()}}LocalDataSourceImpl implements {{feature.pascalCase()}}LocalDataSource {
  {{feature.pascalCase()}}LocalDataSourceImpl({
    required LocalDatabaseService localDatabase,
  }) : _localDatabase = localDatabase;

  final LocalDatabaseService _localDatabase;
}
