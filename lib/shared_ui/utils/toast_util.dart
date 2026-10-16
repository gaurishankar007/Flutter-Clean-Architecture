import 'package:clean_architecture/core/constants/app_colors.dart';
import 'package:clean_architecture/core/data/states/data_state.dart';
import 'package:clean_architecture/routing/navigation_client.dart';
import 'package:clean_architecture/shared_ui/cubits/base/base_cubit.dart';
import 'package:clean_architecture/shared_ui/ui/base/text/base_text.dart';
import 'package:clean_architecture/shared_ui/utils/ui_helpers.dart';
import 'package:flutter_sliding_toast/flutter_sliding_toast.dart';
import 'package:material_ui/material_ui.dart';

/// Shows toasts one at a time: new ones queue until the shown one closes, and
/// tapping a toast opens its full message in a toast-styled dialog.
abstract final class ToastUtil {
  static final _navigationClient = NavigationUtil.I;
  static const _toastSetting = SlidingToastSetting(
    displayDuration: Duration(milliseconds: 2500),
    toastStartPosition: ToastPosition.top,
    toastAlignment: Alignment.topCenter,
    showDialogOnTap: true,
  );
  static final EdgeInsets _padding = UIHelpers.paddingA12;
  static const BoxShadow _boxShadow = BoxShadow(
    color: AppColors.black05,
    spreadRadius: 1,
    blurRadius: 3,
  );

  // The last queued toast, to skip an identical one right after it.
  static ({String message, Color color})? _lastToast;
  // Lets a close callback tell if its toast is still the last queued one.
  static int _lastToastId = 0;

  static void show(String message, {Duration? duration}) => _enqueue(
    message,
    icon: Icons.info_rounded,
    color: AppColors.primary,
    duration: duration,
  );

  static void showSuccess(String message, {Duration? duration}) => _enqueue(
    message,
    icon: Icons.check_circle_rounded,
    color: AppColors.green500,
    duration: duration,
  );

  static void showError(String message, {Duration? duration}) => _enqueue(
    message,
    icon: Icons.warning_rounded,
    color: AppColors.red600,
    duration: duration,
  );

  static void showWarning(String message, {Duration? duration}) => _enqueue(
    message,
    icon: Icons.warning_amber_rounded,
    color: AppColors.warning,
    duration: duration,
  );

  static void _enqueue(
    String message, {
    required IconData icon,
    required Color color,
    Duration? duration,
  }) {
    final toast = (message: message, color: color);
    if (toast == _lastToast) {
      return;
    }
    _lastToast = toast;
    final toastId = ++_lastToastId;

    InteractiveToast.slide(
      overlayState: _navigationClient.navigatorKey.currentState?.overlay,
      title: BaseText(message),
      trailing: Icon(icon, color: color, size: 20),
      toastSetting: _toastSetting.copyWith(displayDuration: duration),
      toastStyle: ToastStyle(
        padding: _padding,
        progressBarColor: color,
        boxShadow: const [_boxShadow],
      ),
      displayMode: ToastDisplayMode.oneByOne,
      // Once it closes, the same message may show again.
      onDisposed: () {
        if (toastId == _lastToastId) {
          _lastToast = null;
        }
      },
    );
  }

  /// Clears the duplicate-skip state; tests use it to isolate static state.
  @visibleForTesting
  static void reset() => _lastToast = null;

  /// Shows success or error message based on success and failure state
  static void showDataStateToast<T>(
    DataState<T> dataState, {
    String message = '',
  }) {
    if (dataState is! SuccessState) {
      showError(dataState.message!);
    } else if (message.isNotEmpty) {
      showSuccess(message);
    }
  }

  /// Shows [message] via the matching toast style. Does nothing for `null`.
  static void showStateMessage(StateMessage? message) {
    switch (message) {
      case SuccessMessage(:final text):
        showSuccess(text);
      case ErrorMessage(:final text):
        showError(text);
      case WarningMessage(:final text):
        showWarning(text);
      case NormalMessage(:final text):
        show(text);
      case null:
        break;
    }
  }
}
