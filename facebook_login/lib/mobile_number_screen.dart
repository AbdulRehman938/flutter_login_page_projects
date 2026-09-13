import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'email_address_screen.dart';
import 'gender_selection_screen.dart';
import 'password_screen.dart';
import 'find_account_screen.dart';

class MobileNumberScreen extends StatefulWidget {
  static const String routeName = '/mobile';
  const MobileNumberScreen({super.key});

  @override
  State<MobileNumberScreen> createState() => _MobileNumberScreenState();
}

class _MobileNumberScreenState extends State<MobileNumberScreen> {
  final TextEditingController _mobileController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;
  bool _isInputFocused = false;

  @override
  void dispose() {
    _mobileController.dispose();
    super.dispose();
  }

  String _formatPhoneNumber(String value) {
    // Remove all non-digit characters
    String digits = value.replaceAll(RegExp(r'\D'), '');
    
    // Format as XXXX XXXXXXX (Pakistan format)
    if (digits.length > 4) {
      return '${digits.substring(0, 4)} ${digits.substring(4, Math.min(11, digits.length))}';
    }
    return digits;
  }

  bool _isValidPhoneNumber(String phone) {
    // Remove all non-digit characters (including spaces)
    String digits = phone.replaceAll(RegExp(r'\D'), '');
    
    print('Validation check: digits="$digits", length=${digits.length}');
    
    // Pakistan phone number validation: starts with 0, followed by 10 digits
    // Total 11 digits
    bool isValid = RegExp(r'^0[0-9]{10}$').hasMatch(digits);
    print('Validation result: $isValid');
    return isValid;
  }

  void _validateAndSubmit() {
    setState(() {
      _errorMessage = null;
    });

    String rawText = _mobileController.text.trim();
    print('Raw input: "$rawText"');
    print('Digits only: "${rawText.replaceAll(RegExp(r'\D'), '')}"');

    if (rawText.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter your mobile number';
      });
      return;
    }

    if (!_isValidPhoneNumber(rawText)) {
      setState(() {
        _errorMessage = 'Please enter a valid mobile number';
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    print('Validation passed, navigating to password screen');

    // Simulate API call
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const PasswordScreen(),
            settings: const RouteSettings(name: PasswordScreen.routeName),
          ),
        );
      }
    });
  }

  void _clearInput() {
    setState(() {
      _mobileController.clear();
      _errorMessage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Back button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: GestureDetector(
                  onTap: () {
                    Navigator.popUntil(context, (route) => route.settings.name == GenderSelectionScreen.routeName);
                  },
                  child: Image.asset(
                    'assets/images/leftSideArrow.png',
                    width: 24,
                    height: 24,
                  ),
                ),
              ),
            ),
            
            // Scrollable content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    
                    // Title
                    const Text(
                      "What's your mobile number?",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    
                    const SizedBox(height: 12),
                    
                    // Subtitle
                    const Text(
                      'Enter the mobile number that you can access right now. We\'ll send you a text message to verify your account.',
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Mobile number input
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Mobile number',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        FocusScope(
                          onFocusChange: (hasFocus) {
                            setState(() {
                              _isInputFocused = hasFocus;
                            });
                          },
                          child: TextField(
                            controller: _mobileController,
                            keyboardType: TextInputType.phone,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(11),
                              _PhoneNumberFormatter(),
                            ],
                            decoration: InputDecoration(
                              hintText: 'enter your phone number',
                              hintStyle: const TextStyle(
                                color: Color(0xFF65676B),
                                fontSize: 16,
                              ),
                              errorText: _errorMessage,
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: Color(0xFFDADDE1),
                                  width: 1,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: _errorMessage != null
                                      ? Colors.red
                                      : const Color(0xFFDADDE1),
                                  width: 1,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: Color(0xFF005FD5),
                                  width: 1,
                                ),
                              ),
                              suffixIcon: _isInputFocused && _mobileController.text.isNotEmpty
                                  ? GestureDetector(
                                      onTap: _clearInput,
                                      child: Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Image.asset(
                                          'assets/images/cross.png',
                                          width: 20,
                                          height: 20,
                                        ),
                                      ),
                                    )
                                  : null,
                            ),
                            onChanged: (value) {
                              setState(() {
                                _errorMessage = null;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Notification text with link
                    RichText(
                      text: const TextSpan(
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                        ),
                        children: [
                          TextSpan(text: 'You may receive SMS notifications from us for security and login purposes. '),
                          TextSpan(
                            text: 'Learn more',
                            style: TextStyle(
                              color: Color(0xFF005FD5),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Next button
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _validateAndSubmit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF005FD5),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          elevation: 0,
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                            : const Text(
                                'Next',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),
                    
                    const SizedBox(height: 12),
                    
                    // Sign up with email button
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const EmailAddressScreen(),
                              settings: const RouteSettings(name: EmailAddressScreen.routeName),
                            ),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.black87,
                          backgroundColor: const Color(0xFFF0F2F5),
                          side: BorderSide.none,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                        child: const Text(
                          'Sign up with email address',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
            
            // Bottom link
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const FindAccountScreen(),
                    ),
                  );
                },
                child: const Text(
                  'Find my account',
                  style: TextStyle(
                    color: Color(0xFF005FD5),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PhoneNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    
    if (digits.length > 11) {
      digits = digits.substring(0, 11);
    }
    
    String formatted = '';
    if (digits.length > 4) {
      formatted = '${digits.substring(0, 4)} ${digits.substring(4)}';
    } else {
      formatted = digits;
    }
    
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

class Math {
  static int min(int a, int b) => a < b ? a : b;
}
