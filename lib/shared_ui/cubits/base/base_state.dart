part of 'base_cubit.dart';

/// The status of a page/cubit.
/// * [initial] - The initial state.
/// * [loading] - The state when data loading is in progress.
/// * [loaded] - The state when data loads without any issue.
/// * [error] - The state when there is an error while loading the data.
/// * [noInternet] - The state when there is no internet connection.
enum StateStatus { initial, loading, loaded, error, noInternet }

/// A one-shot message for the UI to display (e.g. via `ToastUtil`), carried
/// on [BaseState.message].
///
/// Mandatory `copyWith` rule: a state's `copyWith` method must NOT preserve
/// the previous `message` instance - it must use the provided `message`
/// argument directly (`message: message`, never `message ?? this.message`).
/// This way a message is shown exactly once: the state transition that sets
/// it is followed, sooner or later, by one that doesn't pass `message` and
/// so clears it back to `null` - without that, an old error/success message
/// would resurface on a later, unrelated state update.
sealed class StateMessage extends Equatable {
  const StateMessage(this.text);
  final String text;

  @override
  List<Object?> get props => [text];
}

class SuccessMessage extends StateMessage {
  const SuccessMessage(super.text);
}

class ErrorMessage extends StateMessage {
  const ErrorMessage(super.text);
}

class WarningMessage extends StateMessage {
  const WarningMessage(super.text);
}

abstract class BaseState extends Equatable {
  const BaseState({this.status = StateStatus.initial, this.message});
  final StateStatus status;
  final StateMessage? message;

  @override
  List<Object?> get props => [status, message];
}

/// Derives a [StateMessage] from a [DataState]: an [ErrorMessage] when
/// [dataState] failed, a [SuccessMessage] with [message] when it succeeded
/// and [message] is non-empty, otherwise `null` (a silent success).
StateMessage? stateMessageFromDataState(
  DataState<dynamic> dataState, {
  String message = '',
}) {
  if (dataState is! SuccessState) {
    return ErrorMessage(dataState.message ?? kErrorMessage);
  }
  if (message.isNotEmpty) {
    return SuccessMessage(message);
  }
  return null;
}
