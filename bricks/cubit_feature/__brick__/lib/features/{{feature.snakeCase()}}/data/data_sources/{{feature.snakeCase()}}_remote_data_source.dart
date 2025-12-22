import 'package:clean_architecture/core/services/api/api_service.dart';
import 'package:injectable/injectable.dart';

abstract interface class {{feature.pascalCase()}}RemoteDataSource {}

@LazySingleton(as: {{feature.pascalCase()}}RemoteDataSource)
final class {{feature.pascalCase()}}RemoteDataSourceImpl implements {{feature.pascalCase()}}RemoteDataSource {
  const {{feature.pascalCase()}}RemoteDataSourceImpl({
    required ApiService apiService,
  }) : _apiService = apiService;

  final ApiService _apiService;
}
