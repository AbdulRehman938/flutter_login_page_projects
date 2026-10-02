import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:amazon_login/auth_service.dart';

void main() {
  group('AuthService Error Mapping Unit Tests', () {
    test('Translates FirebaseAuthException codes to readable messages', () {
      expect(
        AuthService.getReadableErrorMessage(
          FirebaseAuthException(code: 'user-not-found'),
        ),
        'No account found with this email. Please create an account.',
      );

      expect(
        AuthService.getReadableErrorMessage(
          FirebaseAuthException(code: 'wrong-password'),
        ),
        'Incorrect password. Please verify and try again.',
      );

      expect(
        AuthService.getReadableErrorMessage(
          FirebaseAuthException(code: 'invalid-credential'),
        ),
        'Invalid credentials. Please check your email and password.',
      );

      expect(
        AuthService.getReadableErrorMessage(
          FirebaseAuthException(code: 'email-already-in-use'),
        ),
        'This email address is already registered. Try signing in.',
      );

      expect(
        AuthService.getReadableErrorMessage(
          FirebaseAuthException(code: 'invalid-email'),
        ),
        'The email address is invalid. Please check the format.',
      );

      expect(
        AuthService.getReadableErrorMessage(
          FirebaseAuthException(code: 'weak-password'),
        ),
        'Password is too weak. Please use at least 6 characters.',
      );

      expect(
        AuthService.getReadableErrorMessage(
          FirebaseAuthException(code: 'operation-not-allowed'),
        ),
        'Email/Password sign-in is not enabled in Firebase Console.',
      );

      expect(
        AuthService.getReadableErrorMessage(
          FirebaseAuthException(code: 'network-request-failed'),
        ),
        'Network error. Please check your internet connection.',
      );

      expect(
        AuthService.getReadableErrorMessage(
          FirebaseAuthException(
            code: 'custom-error',
            message: 'Custom message from Firebase',
          ),
        ),
        'Custom message from Firebase',
      );
    });

    test('Translates generic exceptions to fallback string', () {
      expect(
        AuthService.getReadableErrorMessage('Simple error string'),
        'Simple error string',
      );
    });
  });
}
