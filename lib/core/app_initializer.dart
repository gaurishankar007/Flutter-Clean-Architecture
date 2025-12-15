import 'package:clean_architecture/config/injector/injector.dart';
import 'package:clean_architecture/core/data_handling/data_handler.dart';
import 'package:clean_architecture/core/services/session/session_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

abstract final class AppInitializer {
  static Future<void> initializeApp({required String environment}) async {
    await ErrorHandler.catchException(() async {
      await dotenv.load(fileName: ".env");
      await configureDependencies(environment: environment);
      await SessionUtil.I.checkForUserCredential();
    });
  }
}
