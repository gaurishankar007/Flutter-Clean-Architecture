import 'package:clean_architecture/config/injector/injector.config.dart';
import 'package:clean_architecture/core/errors/error_handler.dart';
import 'package:clean_architecture/core/errors/error_recorders/app_error_recorder.dart';
import 'package:clean_architecture/core/errors/error_recorders/firebase_error_recorder/firebase_error_recorder.dart';
import 'package:clean_architecture/core/errors/error_recorders/logger_error_recorder.dart';
import 'package:clean_architecture/core/errors/error_translators/dio_error_translator.dart';
import 'package:clean_architecture/core/errors/error_translators/firebase_error_translator.dart';
import 'package:clean_architecture/core/errors/error_translators/google_sign_in_error_translator.dart';
import 'package:clean_architecture/core/errors/error_translators/web_camera_error_translator.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

@InjectableInit(initializerName: 'initialize')
Future<void> configureDependencies({String? environment}) async {
  /// Registration in the correct order.
  AppErrorProvider.register();
  ErrorHandlerProvider.register(
    errorTranslators: [
      DioErrorTranslator(),
      FirebaseErrorTranslator(),
      GoogleSignInErrorTranslator(),
      WebCameraErrorTranslator(),
    ],
    errorReporters: [
      GetIt.I<AppErrorRecorder>(),
      FirebaseErrorRecorder(),
      LoggerErrorRecorder(),
    ],
  );
  await GetIt.I.initialize(environment: environment);
}
