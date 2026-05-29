import 'dart:developer' show log;

import 'package:clean_architecture/config/injector/injector.dart';
import 'package:clean_architecture/core/errors/error_handler.dart';
import 'package:clean_architecture/features/auth/domain/repositories/session_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';

abstract final class AppInitializer {
  static Future<void> initializeApp({required String environment}) async {
    try {
      // Initializations in the correct order.
      await dotenv.load();
      await configureDependencies(environment: environment);
      await GetIt.I<SessionRepository>().checkForUserCredential();
      ErrorHandlerProvider.I.configureErrorHandlers();
    } catch (e, s) {
      if (kDebugMode) {
        log('App Initialization Failed: $e');
        log('Stack trace: $s');
      }
    }
  }
}
