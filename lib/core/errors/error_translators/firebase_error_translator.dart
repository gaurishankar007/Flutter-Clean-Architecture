import 'package:clean_architecture/core/data/states/data_state.dart';
import 'package:clean_architecture/core/errors/error_translators/error_translator.dart';
import 'package:firebase_auth/firebase_auth.dart';

final class FirebaseErrorTranslator
    implements ErrorTranslator<FirebaseException> {
  final _errorMessages = {
    // Auth Codes
    'invalid-credential': 'The given user was not found on the server!',
    'user-not-found': 'The given user was not found on the server!',
    'wrong-password':
        'The password is invalid or the user does not have a password.',
    'weak-password':
        'Please choose a stronger password consisting of more characters!',
    'invalid-email':
        'Invalid email. Please double check your email and try again!',
    'operation-not-allowed':
        'You cannot register using this method at this moment!',
    'email-already-in-use':
        'Email already in use.Please choose another email to register with!',
    'requires-recent-login':
        'You need to log out and log back in again in order to perform this operation',
    'no-current-user': 'No current user with this information was found',
    'user-disabled': 'This user account has been disabled.',
    'too-many-requests': 'Too many requests. Try again later.',
    'account-exists-with-different-credential':
        'An account already exists with a different credential.',
    'invalid-verification-code': 'The verification code is invalid or expired.',
    'invalid-verification-id': 'The verification ID is invalid.',
    'network-request-failed':
        'Network error. Please check your internet connection and try again!',

    // Storage Codes
    'object-not-found': 'The file you are looking for does not exist.',
    'unauthorized': 'You do not have permission to perform this action.',
    'canceled': 'The upload was canceled.',
    'retry-limit-exceeded':
        'The upload took too long. Please check your connection.',
  };

  @override
  bool matches(Object error) => error is FirebaseException;

  @override
  FailureState<T> translate<T>(FirebaseException exception) {
    final errorCode = exception.code.toLowerCase().trim();

    // Look up the message, or provide a default if the code isn't in our map
    final message =
        _errorMessages[errorCode] ??
        'A system error occurred (${exception.plugin}). Please try again.';

    return FailureState(message: message, error: exception.toString());
  }
}
