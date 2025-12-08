import 'package:injectable/injectable.dart';

import '../../../../core/services/internet/internet_service.dart';
import '../../domain/repositories/{{feature.snakeCase()}}_repository.dart';
import '../data_sources/{{feature.snakeCase()}}_local_data_source.dart';
import '../data_sources/{{feature.snakeCase()}}_remote_data_source.dart';


@LazySingleton(as: {{feature.pascalCase()}}Repository)
final class {{feature.pascalCase()}}RepositoryImpl implements {{feature.pascalCase()}}Repository {
  final InternetService _internetService;
  final {{feature.pascalCase()}}RemoteDataSource _remoteDataSource;
  final {{feature.pascalCase()}}LocalDataSource _localDataSource;

  {{feature.pascalCase()}}RepositoryImpl({
    required InternetService internetService,
    required {{feature.pascalCase()}}RemoteDataSource remoteDataSource,
    required {{feature.pascalCase()}}LocalDataSource localDataSource,
  })  : _internetService = internetService,
        _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource;
}
