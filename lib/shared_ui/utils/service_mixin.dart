import 'package:auto_route/auto_route.dart';
import 'package:clean_architecture/core/data_states/data_state.dart';
import 'package:clean_architecture/core/services/image_picker/image_picker_service.dart';
import 'package:clean_architecture/core/services/navigation/navigation_service.dart';
import 'package:clean_architecture/shared_ui/utils/toast_util.dart';
import 'package:image_picker/image_picker.dart';

mixin ServiceMixin {
  final _navigationService = NavigationUtil.I;
  final _imagePickerService = ImagePickerUtil.I;

  /// Navigation Service
  Future<bool> popPage<T extends Object?>([T? result]) =>
      _navigationService.maybePopTop(result);

  Future<void> replaceAllRoute(PageRouteInfo<dynamic> route) =>
      _navigationService.replaceAllRoute(route);

  Future<T?> pushRoute<T>(PageRouteInfo<dynamic> route) =>
      _navigationService.pushRoute(route);

  Future<T?> pushPlatformRoute<T>({
    PageRouteInfo<dynamic>? androidRoute,
    PageRouteInfo<dynamic>? iOSRoute,
    PageRouteInfo<dynamic>? androidIOSRoute,
    PageRouteInfo<dynamic>? webRoute,
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

  void showDataStateToast(DataState dataState, {String message = ""}) =>
      ToastUtil.showMessage(dataState, message: message);

  /// Image Picker Service
  Future<String?> pickImage([ImageSource source = ImageSource.camera]) =>
      _imagePickerService.pickImage(source: source);
}
