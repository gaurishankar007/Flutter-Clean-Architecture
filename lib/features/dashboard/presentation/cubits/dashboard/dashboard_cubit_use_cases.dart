import 'package:clean_architecture/features/auth/domain/use_cases/check_authentication_use_case.dart';
import 'package:injectable/injectable.dart';

@LazySingleton()
class DashboardCubitUseCases {
  final CheckAuthenticationUseCase checkAuthentication;

  const DashboardCubitUseCases({required this.checkAuthentication});
}
