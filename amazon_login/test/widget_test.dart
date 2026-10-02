import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:amazon_login/main.dart';
import 'package:amazon_login/amazon_signup_screen.dart';
import 'package:amazon_login/validation_utils.dart';

void main() {
  group('ValidationUtils Unit Tests', () {
    test('Login input validation (Email and Phone)', () {
      expect(ValidationUtils.validateLoginInput(null), 'Enter your email or mobile phone number');
      expect(ValidationUtils.validateLoginInput(''), 'Enter your email or mobile phone number');
      expect(ValidationUtils.validateLoginInput('   '), 'Enter your email or mobile phone number');
      expect(ValidationUtils.validateLoginInput('invalid-email'), 'Enter a valid email address or phone number');
      expect(ValidationUtils.validateLoginInput('invalid@'), 'Enter a valid email address or phone number');
      expect(ValidationUtils.validateLoginInput('invalid@domain'), 'Enter a valid email address or phone number');
      expect(ValidationUtils.validateLoginInput('123'), 'Enter a valid email address or phone number');
      expect(ValidationUtils.validateLoginInput('user@example.com'), isNull);
      expect(ValidationUtils.validateLoginInput('user.name+tag@domain.co.uk'), isNull);
      expect(ValidationUtils.validateLoginInput('+1234567890'), isNull);
      expect(ValidationUtils.validateLoginInput('123-456-7890'), isNull);
    });

    test('Signup Name validation', () {
      expect(ValidationUtils.validateName(null), 'Enter your name');
      expect(ValidationUtils.validateName(''), 'Enter your name');
      expect(ValidationUtils.validateName(' '), 'Enter your name');
      expect(ValidationUtils.validateName('A'), 'Enter your name');
      expect(ValidationUtils.validateName('John Doe'), isNull);
    });

    test('Signup Email validation', () {
      expect(ValidationUtils.validateEmail(null), 'Enter your email');
      expect(ValidationUtils.validateEmail(''), 'Enter your email');
      expect(ValidationUtils.validateEmail('not-an-email'), 'Enter a valid email address');
      expect(ValidationUtils.validateEmail('user@domain.com'), isNull);
    });

    test('Signup Password validation', () {
      expect(ValidationUtils.validatePassword(null), 'Enter your password');
      expect(ValidationUtils.validatePassword(''), 'Enter your password');
      expect(ValidationUtils.validatePassword('12345'), 'Passwords must be at least 6 characters');
      expect(ValidationUtils.validatePassword('123456'), isNull);
      expect(ValidationUtils.validatePassword('securePassword123!'), isNull);
    });

    test('Signup Confirm Password validation', () {
      expect(ValidationUtils.validateConfirmPassword(null, 'password'), 'Type your password again');
      expect(ValidationUtils.validateConfirmPassword('', 'password'), 'Type your password again');
      expect(ValidationUtils.validateConfirmPassword('mismatch', 'password'), 'Passwords must match');
      expect(ValidationUtils.validateConfirmPassword('password', 'password'), isNull);
    });
  });

  group('AmazonLoginScreen Validation and ZERO Layout Shift Tests', () {
    testWidgets('Login screen validates empty input and preserves layout coordinates', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      final emailFieldFinder = find.byType(TextField);
      final continueButtonFinder = find.widgetWithText(ElevatedButton, 'Continue');
      final newToAmazonFinder = find.text('New to Amazon?');

      // Record baseline positions and sizes
      final Rect fieldRectBefore = tester.getRect(emailFieldFinder);
      final Rect buttonRectBefore = tester.getRect(continueButtonFinder);
      final Rect textRectBefore = tester.getRect(newToAmazonFinder);

      // Verify no error tooltip is present initially
      expect(find.byType(AmazonErrorTooltip), findsNothing);

      // Tap Continue with empty input
      await tester.tap(continueButtonFinder);
      await tester.pumpAndSettle();

      // Tooltip error should now appear
      expect(find.byType(AmazonErrorTooltip), findsOneWidget);
      final tooltip = tester.widget<AmazonErrorTooltip>(find.byType(AmazonErrorTooltip));
      expect(tooltip.message, 'Enter your email or mobile phone number');

      // Verify STRICT ZERO layout shift: coordinates and heights must be identical
      final Rect fieldRectAfter = tester.getRect(emailFieldFinder);
      final Rect buttonRectAfter = tester.getRect(continueButtonFinder);
      final Rect textRectAfter = tester.getRect(newToAmazonFinder);

      expect(fieldRectAfter, equals(fieldRectBefore), reason: 'TextField rect must not shift');
      expect(buttonRectAfter, equals(buttonRectBefore), reason: 'Continue button rect must not shift');
      expect(textRectAfter, equals(textRectBefore), reason: 'New to Amazon rect must not shift');

      // Tap on the error icon directly to verify Tooltip activation
      await tester.tap(find.byType(AmazonErrorTooltip));
      await tester.pump();
      expect(find.text('Enter your email or mobile phone number'), findsWidgets);

      // Enter invalid email
      await tester.enterText(emailFieldFinder, 'invalidEmail');
      await tester.pumpAndSettle();

      // Error tooltip should update to format error
      final updatedTooltip = tester.widget<AmazonErrorTooltip>(find.byType(AmazonErrorTooltip));
      expect(updatedTooltip.message, 'Enter a valid email address or phone number');

      // Coordinates must STILL be identical
      expect(tester.getRect(emailFieldFinder), equals(fieldRectBefore));
      expect(tester.getRect(continueButtonFinder), equals(buttonRectBefore));

      // Enter valid email
      await tester.enterText(emailFieldFinder, 'user@example.com');
      await tester.pumpAndSettle();

      // Error tooltip should disappear
      expect(find.byType(AmazonErrorTooltip), findsNothing);

      // Coordinates must still remain unchanged
      expect(tester.getRect(emailFieldFinder), equals(fieldRectBefore));
      expect(tester.getRect(continueButtonFinder), equals(buttonRectBefore));

      // Tap Continue when valid -> should show progress indicator
      await tester.tap(continueButtonFinder);
      await tester.pump();
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      await tester.pump(const Duration(seconds: 2));
      await tester.pump();
      expect(find.text('Sign-in successful!'), findsOneWidget);
    });

    testWidgets('Under development dialog appears on Need help and footer links', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Tap "Need help?"
      await tester.tap(find.text('Need help?'));
      await tester.pumpAndSettle();
      expect(find.text('This screen is under development.'), findsOneWidget);
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();
      expect(find.text('This screen is under development.'), findsNothing);

      // Tap "Conditions of Use" in footer
      await tester.tap(find.text('Conditions of Use').last);
      await tester.pumpAndSettle();
      expect(find.text('This screen is under development.'), findsOneWidget);
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      // Tap "Privacy Notice" in footer
      await tester.tap(find.text('Privacy Notice').last);
      await tester.pumpAndSettle();
      expect(find.text('This screen is under development.'), findsOneWidget);
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      // Tap "Help" in footer
      await tester.tap(find.text('Help'));
      await tester.pumpAndSettle();
      expect(find.text('This screen is under development.'), findsOneWidget);
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();
    });
  });

  group('AmazonSignupScreen Validation and ZERO Layout Shift Tests', () {
    testWidgets('Signup screen validates all inputs and preserves layout coordinates', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: AmazonSignupScreen()));
      await tester.pumpAndSettle();

      final textFields = find.byType(TextField);
      expect(textFields, findsNWidgets(4));

      final createAccountButton = find.widgetWithText(ElevatedButton, 'Create your Amazon account');
      final alreadyHaveAccount = find.text('Already have an account? ');

      // Record baseline positions
      final List<Rect> fieldRectsBefore = [];
      for (int i = 0; i < 4; i++) {
        fieldRectsBefore.add(tester.getRect(textFields.at(i)));
      }
      final Rect buttonRectBefore = tester.getRect(createAccountButton);
      final Rect alreadyHaveAccountBefore = tester.getRect(alreadyHaveAccount);

      // Verify no error tooltips initially
      expect(find.byType(AmazonErrorTooltip), findsNothing);

      // Tap Create Account with empty fields
      await tester.tap(createAccountButton);
      await tester.pumpAndSettle();

      // All 4 fields should have error tooltips
      expect(find.byType(AmazonErrorTooltip), findsNWidgets(4));

      // Check error messages
      final tooltips = tester.widgetList<AmazonErrorTooltip>(find.byType(AmazonErrorTooltip)).toList();
      expect(tooltips[0].message, 'Enter your name');
      expect(tooltips[1].message, 'Enter your email');
      expect(tooltips[2].message, 'Enter your password');
      expect(tooltips[3].message, 'Type your password again');

      // Verify STRICT ZERO layout shift on all fields and buttons
      for (int i = 0; i < 4; i++) {
        expect(tester.getRect(textFields.at(i)), equals(fieldRectsBefore[i]),
            reason: 'TextField $i must not shift');
      }
      expect(tester.getRect(createAccountButton), equals(buttonRectBefore),
          reason: 'Create Account button must not shift');
      expect(tester.getRect(alreadyHaveAccount), equals(alreadyHaveAccountBefore),
          reason: 'Already have account text must not shift');

      // Test password visibility toggle alongside error icon
      final visibilityIcons = find.byIcon(Icons.visibility_outlined);
      expect(visibilityIcons, findsNWidgets(2)); // for password and confirm password
      await tester.tap(visibilityIcons.first);
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.visibility_off_outlined), findsOneWidget);

      // Height should still be completely unchanged
      expect(tester.getRect(textFields.at(2)), equals(fieldRectsBefore[2]));

      // Fill in invalid inputs: short name, invalid email, short password, mismatched confirm password
      await tester.enterText(textFields.at(0), 'A');
      await tester.enterText(textFields.at(1), 'badEmail');
      await tester.enterText(textFields.at(2), '123');
      await tester.enterText(textFields.at(3), '1234');
      await tester.pumpAndSettle();

      final updatedTooltips = tester.widgetList<AmazonErrorTooltip>(find.byType(AmazonErrorTooltip)).toList();
      expect(updatedTooltips[0].message, 'Enter your name');
      expect(updatedTooltips[1].message, 'Enter a valid email address');
      expect(updatedTooltips[2].message, 'Passwords must be at least 6 characters');
      expect(updatedTooltips[3].message, 'Passwords must match');

      // Still ZERO shift!
      for (int i = 0; i < 4; i++) {
        expect(tester.getRect(textFields.at(i)), equals(fieldRectsBefore[i]));
      }
      expect(tester.getRect(createAccountButton), equals(buttonRectBefore));

      // Fill valid inputs
      await tester.enterText(textFields.at(0), 'John Doe');
      await tester.enterText(textFields.at(1), 'john@example.com');
      await tester.enterText(textFields.at(2), 'secret123');
      await tester.enterText(textFields.at(3), 'secret123');
      await tester.pumpAndSettle();

      // All error tooltips should be gone
      expect(find.byType(AmazonErrorTooltip), findsNothing);

      // Verify layout remains identical
      for (int i = 0; i < 4; i++) {
        expect(tester.getRect(textFields.at(i)), equals(fieldRectsBefore[i]));
      }
      expect(tester.getRect(createAccountButton), equals(buttonRectBefore));

      // Submit valid form
      await tester.tap(createAccountButton);
      await tester.pump();
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      await tester.pump(const Duration(seconds: 2));
      await tester.pump();
      expect(find.text('Account created successfully!'), findsOneWidget);
    });
  });
}
