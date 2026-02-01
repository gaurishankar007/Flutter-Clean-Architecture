import 'package:clean_architecture/core/domain/entities/user_data.dart';

abstract interface class SessionRepository {
  bool get isLoggedIn;
  UserData get userData;
  Future<void> checkForUserCredential();
  set setUserData(UserData model);
  void clearSessionData();
}
