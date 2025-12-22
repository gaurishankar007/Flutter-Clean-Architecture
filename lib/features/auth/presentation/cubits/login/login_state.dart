part of 'login_cubit.dart';

class LoginState extends BaseState {
  const LoginState({
    required this.passwordVisibility,
    required this.saveUserCredential,
  });

  const LoginState.initial()
    : passwordVisibility = false,
      saveUserCredential = false;
  final bool passwordVisibility;
  final bool saveUserCredential;

  @override
  List<Object> get props => [passwordVisibility, saveUserCredential];
}
