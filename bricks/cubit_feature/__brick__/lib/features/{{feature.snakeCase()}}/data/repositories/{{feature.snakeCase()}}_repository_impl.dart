import 'package:clean_architecture/core/services/internet/internet_service.dart';
import 'package:clean_architecture/features/{{feature.snakeCase()}}/data/data_sources/test_local_data_source.dart';
import 'package:clean_architecture/features/{{feature.snakeCase()}}/data/data_sources/test_remote_data_source.dart';
import 'package:clean_architecture/features/{{feature.snakeCase()}}/domain/repositories/test_repository.dart';
import 'package:injectable/injectable.dart';


@LazySingleton(as: {{feature.pascalCase()}}Repository)
final class {{feature.pascalCase()}}RepositoryImpl implements {{feature.pascalCase()}}Repository {
  {{feature.pascalCase()}}RepositoryImpl({
    required InternetService internetService,
    required {{feature.pascalCase()}}RemoteDataSource remoteDataSource,
    required {{feature.pascalCase()}}LocalDataSource localDataSource,
  })  : _internetService = internetService,
        _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource;

  final InternetService _internetService;
  final {{feature.pascalCase()}}RemoteDataSource _remoteDataSource;
  final {{feature.pascalCase()}}LocalDataSource _localDataSource;
}
