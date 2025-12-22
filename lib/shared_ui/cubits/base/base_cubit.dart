import 'package:clean_architecture/shared_ui/utils/service_mixin.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// The status of a bloc state when there is only a single state
/// * loading
/// * completed
/// * noInternet
enum StateStatus { initial, loading, loaded, noInternet }

abstract class BaseState extends Equatable {
  const BaseState({this.stateStatus = StateStatus.initial});
  final StateStatus stateStatus;

  @override
  List<Object?> get props => [stateStatus];
}

abstract class BaseCubit<T> extends Cubit<T> with ServiceMixin {
  BaseCubit(super.initialState);
}
