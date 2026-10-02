import 'package:flutter/material.dart';

/// Validation utilities for Amazon login and signup forms.
class ValidationUtils {
  static final RegExp _emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  static final RegExp _phoneRegex = RegExp(r'^\+?[0-9]{7,15}$');

  /// Validates email or mobile phone number for login.
  static String? validateLoginInput(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Enter your email or mobile phone number';
    }
    final trimmed = value.trim();

    // Check if it looks like an email
    if (trimmed.contains('@')) {
      if (!_emailRegex.hasMatch(trimmed)) {
        return 'Enter a valid email address or phone number';
      }
      return null;
    }

    // Check if it's a valid phone number (digits with optional +, spaces, hyphens)
    final digits = trimmed.replaceAll(RegExp(r'[\s\-\(\)\.]'), '');
    if (!_phoneRegex.hasMatch(digits)) {
      return 'Enter a valid email address or phone number';
    }

    return null;
  }

  /// Validates name on signup.
  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Enter your name';
    }
    if (value.trim().length < 2) {
      return 'Enter your name';
    }
    return null;
  }

  /// Validates email on signup.
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Enter your email';
    }
    final trimmed = value.trim();
    if (!_emailRegex.hasMatch(trimmed)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  /// Validates password on signup.
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Enter your password';
    }
    if (value.length < 6) {
      return 'Passwords must be at least 6 characters';
    }
    return null;
  }

  /// Validates password confirmation on signup.
  static String? validateConfirmPassword(String? confirmPassword, String? password) {
    if (confirmPassword == null || confirmPassword.isEmpty) {
      return 'Type your password again';
    }
    if (confirmPassword != password) {
      return 'Passwords must match';
    }
    return null;
  }
}

/// Amazon-styled error tooltip that displays error messages as an overlay
/// without shifting or disturbing the layout.
class AmazonErrorTooltip extends StatelessWidget {
  final GlobalKey<TooltipState>? tooltipKey;
  final String message;
  final Widget? child;

  const AmazonErrorTooltip({
    super.key,
    this.tooltipKey,
    required this.message,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      key: tooltipKey,
      message: message,
      triggerMode: TooltipTriggerMode.tap,
      preferBelow: false,
      verticalOffset: 16,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFC40000),
        borderRadius: BorderRadius.circular(4),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      textStyle: const TextStyle(
        color: Colors.white,
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
      child: child ??
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Icon(
              Icons.error_outline,
              color: Color(0xFFC40000),
              size: 20,
            ),
          ),
    );
  }
}

/// Shows an alert dialog indicating that the clicked feature or screen is under development.
void showUnderDevelopmentDialog(BuildContext context, [String? title]) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title ?? 'Under Development'),
        content: const Text('This screen is under development.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'OK',
              style: TextStyle(color: Color(0xFF0066C0)),
            ),
          ),
        ],
      );
    },
  );
}

/// Shows a floating success toast with Amazon green accent.
void showSuccessToast(BuildContext context, String message) {
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          const Icon(Icons.check_circle_outline, color: Colors.white, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: const Color(0xFF067D62),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
      ),
      duration: const Duration(seconds: 3),
    ),
  );
}

