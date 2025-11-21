import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

import 'config/app_config.dart';
import 'core/app_initializer.dart';
import 'shared_ui/application.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppInitializer.initializeApp(environment: Flavor.production);
  usePathUrlStrategy(); // Web-only

  runApp(const CleanArchitectureSample());
}
