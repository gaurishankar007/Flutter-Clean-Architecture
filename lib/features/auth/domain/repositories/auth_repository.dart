import '../../../../core/domain/entities/user_data.dart';
import '../../../../core/utils/type_defs.dart';
import '../entities/authentication.dart';

abstract interface class AuthRepository {
  FutureData<UserData> login(Authentication authentication);
  FutureBool saveUserData(UserData userData);
  FutureData<UserData> getUserData();
  FutureBool checkAuth();
  FutureBool removeUserData();
}
