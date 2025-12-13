import 'package:clean_architecture/core/constants/app_colors.dart';
import 'package:clean_architecture/core/data_states/data_state.dart';
import 'package:clean_architecture/core/services/navigation/navigation_service.dart';
import 'package:clean_architecture/shared_ui/ui/base/text/base_text.dart';
import 'package:clean_architecture/shared_ui/utils/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sliding_toast/flutter_sliding_toast.dart';

abstract interface class ToastUtil {
  static final _navigationService = NavigationUtil.I;
  static final _toastSetting = const SlidingToastSetting(
    displayDuration: Duration(milliseconds: 2500),
    toastStartPosition: ToastPosition.top,
    toastAlignment: Alignment.topCenter,
  );
  static final EdgeInsets _padding = UIHelpers.paddingA12;
  static final BoxShadow _boxShadow = const BoxShadow(
    color: AppColors.black05,
    spreadRadius: 1,
    blurRadius: 3,
  );

  static void showSuccess(String message, {Duration? duration}) {
    InteractiveToast.slide(
      overlayState: _navigationService.navigatorKey.currentState?.overlay,
      title: Text(message),
      trailing: const Icon(
        Icons.check_circle_rounded,
        color: AppColors.green500,
        size: 20,
      ),
      toastSetting: _toastSetting.copyWith(displayDuration: duration),
      toastStyle: ToastStyle(
        padding: _padding,
        progressBarColor: AppColors.green500,
        boxShadow: [_boxShadow],
      ),
    );
  }

  static void showError(String message, {Duration? duration}) {
    InteractiveToast.slide(
      overlayState: _navigationService.navigatorKey.currentState?.overlay,
      title: BaseText(message),
      trailing: const Icon(
        Icons.warning_rounded,
        color: AppColors.red600,
        size: 20,
      ),
      toastSetting: _toastSetting.copyWith(displayDuration: duration),
      toastStyle: ToastStyle(
        padding: _padding,
        progressBarColor: AppColors.red600,
        boxShadow: [_boxShadow],
      ),
    );
  }

  /// Shows success or error message based on success and failure state
  static void showMessage(DataState dataState, {String message = ""}) {
    if (dataState is! SuccessState) {
      showError(dataState.message!);
    } else if (message.isNotEmpty) {
      showSuccess(message);
    }
  }
}
