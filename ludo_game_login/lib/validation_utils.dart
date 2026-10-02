import 'package:flutter/material.dart';

/// Validation utilities for Ludo/Codashop login and signup forms.
class ValidationUtils {
  static final RegExp _emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  /// Validates email.
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Enter your email';
    }
    if (!_emailRegex.hasMatch(value.trim())) {
      return 'Enter a valid email address';
    }
    return null;
  }

  /// Validates name.
  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Enter your name';
    }
    if (value.trim().length < 2) {
      return 'Name must be at least 2 characters';
    }
    return null;
  }

  /// Validates password (min 8 chars, at least 1 digit).
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Enter your password';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain at least 1 number';
    }
    return null;
  }

  /// Validates signin password (just non-empty).
  static String? validateSigninPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Enter your password';
    }
    return null;
  }
}

/// Error tooltip that shows an error icon; tapping reveals the message.
/// Fixed size — does NOT shift layout.
class ErrorTooltip extends StatelessWidget {
  final GlobalKey<TooltipState>? tooltipKey;
  final String message;
  final Color accentColor;

  const ErrorTooltip({
    super.key,
    this.tooltipKey,
    required this.message,
    this.accentColor = const Color(0xFFED4956),
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
        color: accentColor,
        borderRadius: BorderRadius.circular(4),
        boxShadow: const [
          BoxShadow(
            color: Colors.black38,
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
      child: SizedBox(
        width: 40,
        height: 40,
        child: Center(
          child: Icon(
            Icons.error_outline,
            color: accentColor,
            size: 20,
          ),
        ),
      ),
    );
  }
}

/// Shows an alert dialog indicating that the clicked feature is under development.
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
              style: TextStyle(color: Color(0xFF583BE3)),
            ),
          ),
        ],
      );
    },
  );
}

/// Shows a floating success toast.
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
      backgroundColor: const Color(0xFF583BE3),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
      ),
      duration: const Duration(seconds: 3),
    ),
  );
}
