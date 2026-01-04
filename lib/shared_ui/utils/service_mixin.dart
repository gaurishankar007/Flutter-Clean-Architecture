import 'package:auto_route/auto_route.dart';
import 'package:clean_architecture/core/data/states/data_state.dart';
import 'package:clean_architecture/core/services/image_picker/image_picker_service.dart';
import 'package:clean_architecture/core/services/navigation/navigation_service.dart';
import 'package:clean_architecture/shared_ui/utils/toast_util.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

mixin ServiceMixin {
  final _navigationService = NavigationUtil.I;
  final _imagePickerService = ImagePickerUtil.I;

  /// Navigation Service
  Future<bool> maybePopRoute<T extends Object?>([T? result]) =>
      _navigationService.maybePop(result);

  Future<bool> maybePopTopRoute<T extends Object?>([T? result]) =>
      _navigationService.maybePopTop(result);

  /// Pops route based on mobile or web platform.
  void popRouteAdaptively() =>
      kIsWeb ? _navigationService.back() : _navigationService.maybePop();

  Future<void> replaceAllRoute<T>(PageRouteInfo<T> route) =>
      _navigationService.replaceAllRoute(route);

  Future<T?> pushRoute<T>(PageRouteInfo<T> route) =>
      _navigationService.pushRoute(route);

  Future<void> pushPlatformRoute<T>({
    PageRouteInfo<T>? androidRoute,
    PageRouteInfo<T>? iOSRoute,
    PageRouteInfo<T>? androidIOSRoute,
    PageRouteInfo<T>? webRoute,
  }) => _navigationService.pushPlatformRoute(
    androidRoute: androidRoute,
    iOSRoute: iOSRoute,
    androidIOSRoute: androidIOSRoute,
    webRoute: webRoute,
  );

  String get currentPath => _navigationService.currentPath;

  /// Toast Message Service
  void showSuccessToast(String message) => ToastUtil.showSuccess(message);

  void showErrorToast(String message) => ToastUtil.showError(message);

  void showDataStateToast<T>(DataState<T> dataState, {String message = ''}) =>
      ToastUtil.showMessage(dataState, message: message);

  /// Image Picker Service
  Future<String?> pickImage([ImageSource source = ImageSource.camera]) =>
      _imagePickerService.pickImage(source: source);
}
