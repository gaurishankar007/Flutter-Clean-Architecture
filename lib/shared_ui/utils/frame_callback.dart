import 'package:material_ui/material_ui.dart';

/// Runs [callback] once, right after the current frame finishes building.
void runAfterBuild(VoidCallback callback) {
  WidgetsBinding.instance.addPostFrameCallback((_) => callback());
}
