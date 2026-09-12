import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';

extension BuildContextExtension on BuildContext {
  double get statusHeight => MediaQuery.of(this).viewPadding.top;

  SystemUiOverlayStyle get systemOverlayStyle =>
      Theme.of(this).appBarTheme.systemOverlayStyle!;

  ColorScheme get colorScheme => Theme.of(this).colorScheme;
}
