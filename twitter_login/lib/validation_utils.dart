import 'package:flutter/material.dart';

/// Validation utilities for Twitter/X login forms.
class ValidationUtils {
  static final RegExp _emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  /// Validates email or username for login.
  static String? validateLoginInput(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Enter your email or username';
    }
    final input = value.trim();
    if (input.contains('@')) {
      if (!_emailRegex.hasMatch(input)) {
        return 'Enter a valid email address';
      }
    } else {
      // Username: letters, numbers, underscores
      if (!RegExp(r'^[a-zA-Z0-9_]{1,}$').hasMatch(input)) {
        return 'Username can only contain letters, numbers, and underscores';
      }
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
    this.accentColor = const Color(0xFF1D9BF0),
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
        color: Colors.red.shade700,
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
            color: Colors.red.shade400,
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
        backgroundColor: const Color(0xFF202327),
        title: Text(
          title ?? 'Under Development',
          style: const TextStyle(color: Color(0xFFF8FAFC)),
        ),
        content: const Text(
          'This screen is under development.',
          style: TextStyle(color: Color(0xFF71767B)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'OK',
              style: TextStyle(color: Color(0xFF1D9BF0)),
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
      backgroundColor: const Color(0xFF1D9BF0),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
      ),
      duration: const Duration(seconds: 3),
    ),
  );
}
