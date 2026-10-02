import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram_login/auth_service.dart';
import 'package:instagram_login/main.dart';
import 'package:instagram_login/instagram_login_screen.dart';

void main() {
  group('Instagram Auth & Unit Tests', () {
    test('AuthService error message translations', () {
      expect(
        AuthService.getReadableErrorMessage(FirebaseAuthException(code: 'user-not-found')),
        'No account found with this credential. Please sign up.',
      );
      expect(
        AuthService.getReadableErrorMessage(FirebaseAuthException(code: 'wrong-password')),
        'Incorrect password. Please verify and try again.',
      );
    });

    testWidgets('Renders Instagram Login screen by default', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      expect(find.byType(InstagramLoginScreen), findsOneWidget);
      expect(find.widgetWithText(ElevatedButton, 'Log in'), findsOneWidget);
    });
  });
}
