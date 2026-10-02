import 'package:flutter/material.dart';

/// Validation utilities for eBay forms.
class ValidationUtils {
  static final RegExp _emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  /// Validates email or username for eBay login.
  static String? validateEmailOrUsername(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Enter your email or username';
    }
    final trimmed = value.trim();
    if (trimmed.contains('@')) {
      if (!_emailRegex.hasMatch(trimmed)) {
        return 'Enter a valid email address';
      }
      return null;
    }
    if (trimmed.length < 3) {
      return 'Enter a valid username (at least 3 characters)';
    }
    return null;
  }

  /// Validates first name on signup.
  static String? validateFirstName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Enter your first name';
    }
    return null;
  }

  /// Validates last name on signup.
  static String? validateLastName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Enter your last name';
    }
    return null;
  }

  /// Validates email on signup.
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Enter your email address';
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
      return 'Password must be at least 6 characters';
    }
    return null;
  }
}

/// Floating error tooltip that displays error messages as an overlay
/// with strictly zero layout shift or height alterations.
class EbayErrorTooltip extends StatelessWidget {
  final GlobalKey<TooltipState>? tooltipKey;
  final String message;
  final Widget? child;

  const EbayErrorTooltip({
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
              style: TextStyle(color: Color(0xFF0964EC)),
            ),
          ),
        ],
      );
    },
  );
}

/// Shows a floating success toast with eBay blue/green accent.
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
      backgroundColor: const Color(0xFF0964EC),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      duration: const Duration(seconds: 3),
    ),
  );
}
