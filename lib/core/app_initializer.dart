import 'package:clean_architecture/config/injector/injector.dart';
import 'package:clean_architecture/core/data/handlers/error_handler.dart';
import 'package:clean_architecture/features/auth/domain/repositories/session_repository.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';

abstract final class AppInitializer {
  static Future<void> initializeApp({required String environment}) async {
    await ErrorHandler.executeSafe(() async {
      await dotenv.load();
      await configureDependencies(environment: environment);
      await GetIt.I<SessionRepository>().checkForUserCredential();
    });
  }
}
