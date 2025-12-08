import 'package:injectable/injectable.dart';

import '../../../../core/utils/type_defs.dart';
import '../../../../core/domain/use_cases/use_case.dart';
import '../entities/authentication.dart';
import '../../../../core/domain/entities/user_data.dart';
import '../repositories/auth_repository.dart';

@LazySingleton()
class LoginUseCase implements UseCase<UserData, Authentication> {
  final AuthRepository _authRepository;

  LoginUseCase({required AuthRepository authRepository})
      : _authRepository = authRepository;

  @override
  FutureData<UserData> call(Authentication authentication) =>
      _authRepository.login(authentication);
}
