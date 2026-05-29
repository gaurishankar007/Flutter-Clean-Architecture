import 'package:clean_architecture/core/data/states/data_state.dart';
import 'package:clean_architecture/core/errors/custom_errors.dart';
import 'package:clean_architecture/core/errors/error_translators/error_translator.dart';

final class WebCameraErrorTranslator
    implements ErrorTranslator<WebCameraException> {
  @override
  bool matches(Object error) => error is WebCameraException;

  @override
  FailureState<T> translate<T>(WebCameraException exception) =>
      FailureState<T>(message: exception.message, error: exception.error);
}
