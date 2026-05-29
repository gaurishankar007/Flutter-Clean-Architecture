part of 'app_error_cubit.dart';

class AppErrorState extends BaseState {
  const AppErrorState({super.status, this.errors = const []});

  factory AppErrorState.initial() => const AppErrorState();

  final List<AppErrorDetails> errors;

  AppErrorState copyWith({StateStatus? status, List<AppErrorDetails>? errors}) {
    return AppErrorState(
      status: status ?? this.status,
      errors: errors ?? this.errors,
    );
  }

  @override
  List<Object?> get props => [status, errors];
}
