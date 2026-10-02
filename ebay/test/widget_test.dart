import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ebay/auth_service.dart';
import 'package:ebay/main.dart';
import 'package:ebay/ebay_login_screen.dart';

void main() {
  group('eBay Auth & Unit Tests', () {
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

    testWidgets('Renders eBay Login screen by default', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      expect(find.byType(EbayLoginScreen), findsOneWidget);
      expect(find.text('Sign in to your account'), findsOneWidget);
    });
  });
}
