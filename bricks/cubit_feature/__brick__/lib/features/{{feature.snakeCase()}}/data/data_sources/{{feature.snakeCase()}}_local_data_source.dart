import 'package:injectable/injectable.dart';

import '../../../../core/services/database/local_database_service.dart';

abstract interface class {{feature.pascalCase()}}LocalDataSource {}

@LazySingleton(as: {{feature.pascalCase()}}LocalDataSource)
final class {{feature.pascalCase()}}LocalDataSourceImpl implements {{feature.pascalCase()}}LocalDataSource {
  final LocalDatabaseService _localDatabase;
  
  {{feature.pascalCase()}}LocalDataSourceImpl({
    required LocalDatabaseService localDatabase,
  }) : _localDatabase = localDatabase;
}
