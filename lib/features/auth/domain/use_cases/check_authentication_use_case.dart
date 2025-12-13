import 'package:clean_architecture/core/domain/use_cases/use_case.dart';
import 'package:clean_architecture/core/utils/type_defs.dart';
import 'package:clean_architecture/features/auth/domain/repositories/auth_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton()
class CheckAuthenticationUseCase implements UseCaseNoParameter<bool> {
  final AuthRepository _authRepository;

  CheckAuthenticationUseCase({required AuthRepository authRepository})
    : _authRepository = authRepository;

  @override
  FutureBool call() => _authRepository.checkAuth();
}
