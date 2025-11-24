part of 'screen_util.dart';

final class ScreenDetails {
  final Size logicalSize;
  final Size physicalSize;
  final double devicePixelRatio;

  const ScreenDetails({
    required this.logicalSize,
    required this.physicalSize,
    required this.devicePixelRatio,
  });
}
