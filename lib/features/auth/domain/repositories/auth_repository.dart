import 'package:clean_architecture/core/domain/entities/user_data.dart';
import 'package:clean_architecture/core/types/types.dart';
import 'package:clean_architecture/features/auth/domain/entities/authentication.dart';

abstract interface class AuthRepository {
  FutureData<UserData> login(Authentication authentication);
  FutureVoid saveUserData(UserData userData);
  FutureData<UserData> getUserData();
  FutureBool checkAuth();
  FutureVoid removeUserData();
}
