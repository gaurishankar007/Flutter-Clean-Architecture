import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/widgets.dart';

part 'screen_type.dart';
part 'screen_details.dart';

/// Provides screen size measurements
class ScreenUtil {
  ScreenUtil._();
  static final ScreenUtil _singleton = ScreenUtil._();

  factory ScreenUtil() => _singleton;
  static ScreenUtil get I => ScreenUtil();

  double _width = 0;
  double _height = 0;
  double _devicePixelRatio = 0;
  double _statusBarHeight = 0;
  ScreenType _type = ScreenType.unknown;

  double get height => _height;
  double get width => _width;

  /// Physical pixels on the screen ↔️ Logical (Flutter) pixels you work with.
  ///
  /// 🔍 Example:
  ///
  /// Let’s say you're working on a phone with:
  /// - A screen resolution of 1080 × 1920 (physical pixels)
  /// - And the screen size in Flutter is 360 × 640 logical pixels
  /// - Then the devicePixelRatio = 1080 / 360 = 3.0
  double get devicePixelRatio => _devicePixelRatio;

  /// Height of the system top status bar
  double get statusBarHeight => _statusBarHeight;

  ScreenType get type => _type;

  /// Set screen dimensions, orientation, screen type, etc.
  void configureScreen([ScreenDetails? screenDetails]) {
    screenDetails ??= _getScreenDetails();

    _height = screenDetails.logicalSize.height;
    _width = screenDetails.logicalSize.width;
    _devicePixelRatio = screenDetails.devicePixelRatio;
    _statusBarHeight = 0;
    _type = _getScreenType();
  }

  ScreenDetails _getScreenDetails() {
    final view = WidgetsBinding.instance.platformDispatcher.views.first;
    final physicalSize = view.physicalSize;
    final devicePixelRatio = view.devicePixelRatio;
    final logicalSize = Size(
      physicalSize.width / devicePixelRatio,
      physicalSize.height / devicePixelRatio,
    );

    return ScreenDetails(
      logicalSize: logicalSize,
      physicalSize: physicalSize,
      devicePixelRatio: devicePixelRatio,
    );
  }

  /// Check screen size according to the width
  ScreenType _getScreenType() {
    if (width <= 360) return ScreenType.compact;
    if (width <= 600) return ScreenType.phone;
    if (width <= 840) return ScreenType.tablet;
    if (width <= 1024) return ScreenType.largeTablet;
    return ScreenType.desktop;
  }

  /// Get the required number within the limitation
  double _limitedNumber(double number, {double? min, double? max}) {
    if (min != null && number < min) return min;
    if (max != null && number > max) return max;
    return number;
  }

  /// Required percentage of height with limitation
  double heightPart(double percentage, {double? min, double? max}) {
    double height = percentage / 100 * _height;
    if (min == null && max == null) return height;

    return _limitedNumber(height, min: min, max: max);
  }

  /// Required percentage of width with limitation
  double widthPart(double percentage, {double? min, double? max}) {
    double width = percentage / 100 * _width;
    if (min == null && max == null) return width;

    return _limitedNumber(width, min: min, max: max);
  }

  /// The first matching screen type value is returned otherwise use [base].
  T getResponsiveValue<T>({
    required T base,
    required Map<Set<ScreenType>, T> screens,
  }) {
    for (final entry in screens.entries) {
      if (entry.key.contains(_type)) return entry.value;
    }
    return base;
  }

  /// Get adapted values for compact and small screens otherwise use [base]
  T getMobileValue<T>({required T base, required T screen12}) =>
      getResponsiveValue(
        base: base,
        screens: {
          {.compact, .phone}: screen12,
        },
      );

  /// Whether the screen is smartphone screen
  bool get _isPhoneScreen => _type.index <= ScreenType.phone.index;

  /// Whether the screen is desktop screen in web view
  bool get isWebDesktopScreen => kIsWeb && _type == ScreenType.desktop;

  /// Spacing between the items in the grid view
  double gridViewSpace = 20;

  /// View horizontal padding
  double get horizontalSpace => _isPhoneScreen ? widthPart(5.55, max: 20) : 24;

  /// View vertical padding
  double get verticalSpace => _isPhoneScreen ? 24 : 32;

  /// View horizontal padding
  EdgeInsets get horizontalPadding =>
      EdgeInsets.symmetric(horizontal: horizontalSpace);

  /// View horizontal padding
  EdgeInsets get verticalPadding =>
      EdgeInsets.symmetric(vertical: verticalSpace);

  /// View padding
  EdgeInsets pagePadding() => EdgeInsets.symmetric(
    horizontal: horizontalSpace,
    vertical: verticalSpace,
  );

  /// Width of the screen excluding left and right screen padding
  double availableWidth({double extraSpace = 0}) =>
      width - (horizontalSpace * 2) - extraSpace;
}

extension NumScreenUtilExtension<T extends num> on T {
  T get avoidNegativeValue => (this < 0 ? 0 : this) as T;

  /// Required percentage of height with limitation
  double heightPart({double? min, double? max}) =>
      ScreenUtil.I.heightPart(toDouble(), min: min, max: max);

  /// Required percentage of width with limitation
  double widthPart({double? min, double? max}) =>
      ScreenUtil.I.widthPart(toDouble(), min: min, max: max);
}
