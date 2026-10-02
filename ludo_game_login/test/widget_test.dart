import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ludo_game_login/auth_service.dart';
import 'package:ludo_game_login/main.dart';
import 'package:ludo_game_login/ludo_signin_screen.dart';

void main() {
  group('Ludo Auth & Unit Tests', () {
    test('AuthService error message translations', () {
      expect(
        AuthService.getReadableErrorMessage(FirebaseAuthException(code: 'user-not-found')),
        'No account found with this email. Please create an account.',
      );
      expect(
        AuthService.getReadableErrorMessage(FirebaseAuthException(code: 'wrong-password')),
        'Incorrect password. Please verify and try again.',
      );
    });

    testWidgets('Renders Ludo Signin screen by default', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      expect(find.byType(LudoSigninScreen), findsOneWidget);
      expect(find.widgetWithText(ElevatedButton, 'Sign In'), findsOneWidget);
    });
  });
}
