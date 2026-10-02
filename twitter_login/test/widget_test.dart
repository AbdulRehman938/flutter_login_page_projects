import 'package:flutter_test/flutter_test.dart';
import 'package:twitter_login/main.dart';
import 'package:twitter_login/auth_service.dart';

void main() {
  group('Twitter Auth & Unit Tests', () {
    test('AuthService error message translations', () {
      expect(
        AuthService.getReadableErrorMessage(Exception('some error')),
        isA<String>(),
      );
    });

    testWidgets('Renders Twitter Landing screen by default', (tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pump(const Duration(seconds: 1));

      // The AuthGate shows LandingScreen (which has "See what's happening") when not authed
      expect(find.textContaining("happening"), findsAtLeast(1));
    });
  });
}
