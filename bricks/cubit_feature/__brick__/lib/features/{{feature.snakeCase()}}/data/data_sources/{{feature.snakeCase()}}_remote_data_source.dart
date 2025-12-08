import 'package:injectable/injectable.dart';

import '../../../../core/services/api/api_service.dart';

abstract interface class {{feature.pascalCase()}}RemoteDataSource {}

@LazySingleton(as: {{feature.pascalCase()}}RemoteDataSource)
final class {{feature.pascalCase()}}RemoteDataSourceImpl implements {{feature.pascalCase()}}RemoteDataSource {
  final ApiService _apiService;

  const {{feature.pascalCase()}}RemoteDataSourceImpl({
    required ApiService apiService,
  }) : _apiService = apiService;
}
