import 'package:clean_architecture/core/domain/entities/user_data.dart';
import 'package:clean_architecture/core/domain/use_cases/use_case.dart';
import 'package:clean_architecture/core/utils/type_defs.dart';
import 'package:clean_architecture/features/auth/domain/entities/authentication.dart';
import 'package:clean_architecture/features/auth/domain/repositories/auth_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton()
class LoginUseCase implements UseCase<UserData, Authentication> {
  final AuthRepository _authRepository;

  LoginUseCase({required AuthRepository authRepository})
    : _authRepository = authRepository;

  @override
  FutureData<UserData> call(Authentication authentication) =>
      _authRepository.login(authentication);
}
