import 'package:clean_architecture/core/clients/remote/internet_client.dart';
import 'package:clean_architecture/core/data/handlers/repository_handler.dart';
import 'package:clean_architecture/core/utils/type_defs.dart';
import 'package:clean_architecture/features/{{feature.snakeCase()}}/data/data_sources/{{feature.snakeCase()}}_local_data_source.dart';
import 'package:clean_architecture/features/{{feature.snakeCase()}}/data/data_sources/{{feature.snakeCase()}}_remote_data_source.dart';
import 'package:clean_architecture/features/{{feature.snakeCase()}}/domain/repositories/{{feature.snakeCase()}}_repository.dart';
import 'package:injectable/injectable.dart';


@LazySingleton(as: {{feature.pascalCase()}}Repository)
final class {{feature.pascalCase()}}RepositoryImpl implements {{feature.pascalCase()}}Repository {
  {{feature.pascalCase()}}RepositoryImpl({
    required InternetClient internet,
    required {{feature.pascalCase()}}RemoteDataSource remoteDataSource,
    required {{feature.pascalCase()}}LocalDataSource localDataSource,
  })  : _internet = internet,
        _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource;

  final InternetClient _internet;
  final {{feature.pascalCase()}}RemoteDataSource _remoteDataSource;
  final {{feature.pascalCase()}}LocalDataSource _localDataSource;
}
