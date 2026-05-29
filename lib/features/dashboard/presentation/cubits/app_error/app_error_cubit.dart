import 'package:clean_architecture/core/data/models/app_error_details.dart';
import 'package:clean_architecture/core/errors/error_recorders/app_error_recorder.dart';
import 'package:clean_architecture/shared_ui/cubits/base/base_cubit.dart';
import 'package:injectable/injectable.dart';

part 'app_error_state.dart';

@injectable
class AppErrorCubit extends BaseCubit<AppErrorState> {
  AppErrorCubit() : super(AppErrorState.initial());

  void fetchErrors() {
    emit(state.copyWith(status: StateStatus.loading));
    final errors = AppErrorProvider.I.getErrors;
    emit(state.copyWith(status: StateStatus.loaded, errors: errors));
  }

  void removeError(String errorId) {
    AppErrorProvider.I.removeError(errorId);
    fetchErrors();
  }

  void clearAllErrors() {
    AppErrorProvider.I.clearAllErrors();
    fetchErrors();
  }
}
