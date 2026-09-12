import 'package:material_ui/material_ui.dart';

extension PageControllerExtension on PageController {
  Future<void> goBack() => previousPage(
    duration: const Duration(milliseconds: 350),
    curve: Curves.easeInOut,
  );
  Future<void> moveForward() => nextPage(
    duration: const Duration(milliseconds: 350),
    curve: Curves.easeInOut,
  );
}
