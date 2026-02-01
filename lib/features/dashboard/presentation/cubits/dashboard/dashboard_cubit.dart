import 'package:clean_architecture/core/utils/type_defs.dart';
import 'package:clean_architecture/features/dashboard/presentation/cubits/dashboard/dashboard_cubit_use_cases.dart';
import 'package:clean_architecture/routing/routes.gr.dart';
import 'package:clean_architecture/shared_ui/cubits/base/base_cubit.dart';
import 'package:injectable/injectable.dart';

part 'dashboard_state.dart';

@injectable
class DashboardCubit extends BaseCubit<DashboardState> {
  DashboardCubit({required DashboardCubitUseCases useCases})
    : _useCases = useCases,
      super(DashboardState.initial());

  final DashboardCubitUseCases _useCases;
  int _activeIndex = 0;

  Future<void> initialize() async {
    /// If token is expired, log out and don't perform other operations
    // final dataState = await _verifyToken();
    // if (dataState is! SuccessState) return;
  }

  void setIndex(int index) {
    if (_activeIndex == index && index != 0) {
      return;
    }

    _activeIndex = index;
    emit(state.copyWith(activeIndex: _activeIndex));

    switch (index) {
      case 0:
        replaceAllRoute(const HomeRoute());
        return;

      case 1:
        replaceAllRoute(const SettingRoute());
        return;

      default:
        return;
    }
  }

  /// Check whether the token is expired or not
  FutureBool verifyToken() => _useCases.checkAuthentication.call();

  Future<void> logOut() async {
    _useCases.logOut();
    await replaceAllRoute(const LoginRoute());
  }
}
