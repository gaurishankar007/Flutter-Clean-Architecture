import 'package:clean_architecture/config/app_config.dart';
import 'package:clean_architecture/core/app_initializer.dart';
import 'package:clean_architecture/shared_ui/application.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:material_ui/material_ui.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppInitializer.initializeApp(environment: Flavor.staging);
  usePathUrlStrategy(); // Web-only

  runApp(const CleanArchitectureSample());
}
