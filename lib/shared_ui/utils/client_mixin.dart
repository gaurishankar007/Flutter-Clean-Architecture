import 'package:auto_route/auto_route.dart';
import 'package:clean_architecture/core/data/states/data_state.dart';
import 'package:clean_architecture/routing/helper/navigation_client.dart';
import 'package:clean_architecture/shared_ui/utils/toast_util.dart';
import 'package:flutter/foundation.dart';

mixin ClientMixin {
  final _navigationClient = NavigationUtil.I;

  /// Navigation Client
  Future<bool> maybePopRoute<T extends Object?>([T? result]) =>
      _navigationClient.maybePop(result);

  Future<bool> maybePopTopRoute<T extends Object?>([T? result]) =>
      _navigationClient.maybePopTop(result);

  /// Pops route based on mobile or web platform.
  void popRouteAdaptively() =>
      kIsWeb ? _navigationClient.back() : _navigationClient.maybePop();

  Future<void> replaceAllRoute<T>(PageRouteInfo<T> route) =>
      _navigationClient.replaceAllRoute(route);

  Future<T?> pushRoute<T>(PageRouteInfo<T> route) =>
      _navigationClient.pushRoute(route);

  Future<void> pushPlatformRoute<T>({
    PageRouteInfo<T>? androidRoute,
    PageRouteInfo<T>? iOSRoute,
    PageRouteInfo<T>? androidIOSRoute,
    PageRouteInfo<T>? webRoute,
  }) => _navigationClient.pushPlatformRoute(
    androidRoute: androidRoute,
    iOSRoute: iOSRoute,
    androidIOSRoute: androidIOSRoute,
    webRoute: webRoute,
  );

  String get currentPath => _navigationClient.currentPath;

  /// Toast Message Service
  void showSuccessToast(String message) => ToastUtil.showSuccess(message);

  void showErrorToast(String message) => ToastUtil.showError(message);

  void showDataStateToast<T>(DataState<T> dataState, {String message = ''}) =>
      ToastUtil.showMessage(dataState, message: message);
}
