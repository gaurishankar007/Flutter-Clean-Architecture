part of 'screen_util.dart';

final class ScreenDetails {
  const ScreenDetails({
    required this.logicalSize,
    required this.physicalSize,
    required this.devicePixelRatio,
  });
  final Size logicalSize;
  final Size physicalSize;
  final double devicePixelRatio;
}
