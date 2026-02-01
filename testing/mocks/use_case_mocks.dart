import 'package:clean_architecture/features/auth/domain/use_cases/log_out_use_case.dart';
import 'package:clean_architecture/features/auth/domain/use_cases/login_use_case.dart';
import 'package:clean_architecture/features/auth/domain/use_cases/save_user_data_use_case.dart';
import 'package:clean_architecture/features/auth/domain/use_cases/set_session_use_case.dart';
import 'package:mocktail/mocktail.dart';

class MockLoginUseCase extends Mock implements LoginUseCase {}

class MockSaveUserDataUseCase extends Mock implements SaveUserDataUseCase {}

class MockSetSessionUseCase extends Mock implements SetSessionUseCase {}

class MockLogOutUseCase extends Mock implements LogOutUseCase {}
