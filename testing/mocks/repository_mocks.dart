import 'package:clean_architecture/features/auth/domain/repositories/auth_repository.dart';
import 'package:clean_architecture/features/auth/domain/repositories/session_repository.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class MockSessionRepository extends Mock implements SessionRepository {}
