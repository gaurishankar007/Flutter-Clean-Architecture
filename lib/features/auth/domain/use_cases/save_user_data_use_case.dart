import 'package:injectable/injectable.dart';

import '../../../../core/utils/type_defs.dart';
import '../../../../core/domain/use_cases/use_case.dart';
import '../../../../core/domain/entities/user_data.dart';
import '../repositories/auth_repository.dart';

@LazySingleton()
class SaveUserDataUseCase implements UseCase<bool, UserData> {
  final AuthRepository _authRepository;

  SaveUserDataUseCase({required AuthRepository authRepository})
    : _authRepository = authRepository;

  @override
  FutureBool call(UserData request) => _authRepository.saveUserData(request);
}
