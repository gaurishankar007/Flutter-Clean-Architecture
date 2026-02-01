import 'package:clean_architecture/shared_ui/utils/client_mixin.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// The status of a page/cubit.
/// * [initial] - The initial state.
/// * [loading] - The state when data loading is in progress.
/// * [loaded] - The state when data loads without any issue.
/// * [error] - The state when there is an error while loading the data.
/// * [noInternet] - The state when there is no internet connection.
enum StateStatus { initial, loading, loaded, error, noInternet }

abstract class BaseState extends Equatable {
  const BaseState({this.status = StateStatus.initial});
  final StateStatus status;

  @override
  List<Object?> get props => [status];
}

abstract class BaseCubit<T> extends Cubit<T> with ClientMixin {
  BaseCubit(super.initialState);
}
