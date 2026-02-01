import 'package:clean_architecture/core/data/states/data_state.dart';
import 'package:clean_architecture/core/domain/entities/user.dart';
import 'package:clean_architecture/core/domain/entities/user_data.dart';
import 'package:clean_architecture/features/auth/domain/entities/authentication.dart';
import 'package:clean_architecture/features/auth/presentation/cubits/login/login_cubit_use_cases.dart';
import 'package:clean_architecture/routing/routes.gr.dart';
import 'package:clean_architecture/shared_ui/cubits/base/base_cubit.dart';
import 'package:injectable/injectable.dart';

part 'login_state.dart';

@injectable
class LoginCubit extends BaseCubit<LoginState> {
  LoginCubit({required LoginCubitUseCases useCases})
    : _useCases = useCases,
      super(const LoginState.initial());

  final LoginCubitUseCases _useCases;
  bool _passwordVisibility = false;
  bool _saveUserCredential = false;

  /// Emits a new State
  void _refreshState() {
    final newState = LoginState(
      passwordVisibility: _passwordVisibility,
      saveUserCredential: _saveUserCredential,
    );
    emit(newState);
  }

  /// Clear any stale session data when login page loads
  /// This handles cases where the auth interceptor navigated to login
  /// but couldn't clear the in-memory session data
  void clearSession() {
    _useCases.logOut.call();
  }

  void togglePasswordVisibility() {
    _passwordVisibility = !_passwordVisibility;
    _refreshState();
  }

  void toggleUserCredentialSaving() {
    _saveUserCredential = !_saveUserCredential;
    _refreshState();
  }

  Future<void> login({
    required String username,
    required String password,
  }) async {
    final authentication = Authentication(
      username: username,
      password: password,
    );
    final dataState = await _useCases.login.call(authentication);
    showDataStateToast(dataState);

    if (dataState.hasData) {
      _useCases.setSession.call(dataState.data!);
      if (_saveUserCredential) {
        await _useCases.saveUserData.call(dataState.data!);
      }
      await replaceAllRoute(const HomeRoute());
    }
  }

  Future<void> fakeLogin({
    required String username,
    required String password,
  }) async {
    await Future<void>.delayed(const Duration(seconds: 2));

    final dataState = SuccessState(
      data: UserData(
        accessToken: 'access',
        refreshToken: 'refresh',
        user: User(
          id: 1,
          firstName: 'Flutter',
          lastName: 'Developers',
          username: username,
          email: 'email',
          isActive: true,
        ),
      ),
    );
    _useCases.setSession.call(dataState.data!);
    if (_saveUserCredential) {
      await _useCases.saveUserData.call(dataState.data!);
    }

    await replaceAllRoute(const HomeRoute());
  }
}
