import 'package:injectable/injectable.dart';

import '../../../../core/domain/use_cases/use_case.dart';
import '../../../../core/utils/type_defs.dart';
import '../../../../core/domain/entities/user_data.dart';
import '../repositories/auth_repository.dart';

@LazySingleton()
class GetUserDataUseCase implements UseCaseNoParameter<UserData> {
  final AuthRepository _authRepository;

  GetUserDataUseCase({required AuthRepository authRepository})
      : _authRepository = authRepository;

  @override
  FutureData<UserData> call() => _authRepository.getUserData();
}
