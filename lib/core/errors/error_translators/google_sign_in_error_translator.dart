import 'package:clean_architecture/core/data/states/data_state.dart';
import 'package:clean_architecture/core/errors/error_translators/error_translator.dart';
import 'package:google_sign_in/google_sign_in.dart';

final class GoogleSignInErrorTranslator
    implements ErrorTranslator<GoogleSignInException> {
  final _googleSignInErrorMessages = {
    'unknownError':
        'An unknown error occurred during Google Sign-In. Please try again.',
    'canceled':
        'The sign-in process was canceled. Please try again if you want to sign in.',
    'interrupted': 'The sign-in process was interrupted. Please try again.',
    'clientConfigurationError':
        'Google Sign-In is not configured correctly on this app. Please contact support.',
    'providerConfigurationError':
        'There is a problem with the Google Sign-In provider configuration. Please contact support.',
    'uiUnavailable':
        'The sign-in UI could not be displayed. This might be a temporary issue, please try again.',
    'userMismatch':
        'The user trying to sign in is different from the one already signed in. Please sign out first.',
  };

  @override
  bool matches(Object error) => error is GoogleSignInException;

  @override
  FailureState<T> translate<T>(GoogleSignInException exception) {
    final errorCode = exception.code.name;
    final message = _googleSignInErrorMessages[errorCode];
    return FailureState(message: message, error: exception.toString());
  }
}
