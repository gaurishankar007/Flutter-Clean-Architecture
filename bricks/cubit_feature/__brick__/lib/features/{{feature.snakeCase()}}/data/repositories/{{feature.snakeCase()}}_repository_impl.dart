import 'package:clean_architecture/core/clients/remote/connectivity_client.dart';
import 'package:clean_architecture/core/data/operations/repository_fetcher.dart';
import 'package:clean_architecture/core/types/types.dart';
import 'package:clean_architecture/features/{{feature.snakeCase()}}/data/data_sources/{{feature.snakeCase()}}_local_data_source.dart';
import 'package:clean_architecture/features/{{feature.snakeCase()}}/data/data_sources/{{feature.snakeCase()}}_remote_data_source.dart';
import 'package:clean_architecture/features/{{feature.snakeCase()}}/domain/repositories/{{feature.snakeCase()}}_repository.dart';
import 'package:injectable/injectable.dart';


@LazySingleton(as: {{feature.pascalCase()}}Repository)
final class {{feature.pascalCase()}}RepositoryImpl implements {{feature.pascalCase()}}Repository {
  {{feature.pascalCase()}}RepositoryImpl({
    required this._internet,
    required this._remoteDataSource,
    required this._localDataSource,
  });

  final ConnectivityClient _internet;
  final {{feature.pascalCase()}}RemoteDataSource _remoteDataSource;
  final {{feature.pascalCase()}}LocalDataSource _localDataSource;
}
