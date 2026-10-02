import 'package:flutter_test/flutter_test.dart';
import 'package:facebook_login/main.dart';
import 'package:facebook_login/auth_service.dart';

void main() {
  group('Facebook Login Auth & Unit Tests', () {
    test('AuthService error message translations', () {
      expect(
        AuthService.getReadableErrorMessage(
          Exception('some error'),
        ),
        isA<String>(),
      );
    });

    testWidgets('Renders Facebook Login screen by default', (tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pump(const Duration(seconds: 1));

      // The AuthGate should show FacebookLoginScreen with 'Log in' button when not authed
      expect(find.text('Log in'), findsAtLeast(1));
    });
  });
}
