import 'package:firebase_auth/firebase_auth.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthCredential extends Fake implements AuthCredential {}

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockOAuthCredential extends Mock implements OAuthCredential {}

class MockUser extends Mock implements User {}

class MockUserCredential extends Mock implements UserCredential {}

//
// ignore: avoid_implementing_value_types
class MockFirebaseAuthException extends Mock implements FirebaseAuthException {}
