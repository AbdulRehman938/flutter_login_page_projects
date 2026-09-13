import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SearchByMobileScreen extends StatefulWidget {
  const SearchByMobileScreen({super.key});

  @override
  State<SearchByMobileScreen> createState() => _SearchByMobileScreenState();
}

class _SearchByMobileScreenState extends State<SearchByMobileScreen> {
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
    // Remove all non-digit characters
    String digits = phone.replaceAll(RegExp(r'\D'), '');
    
    // Pakistan phone number validation: starts with 0, followed by 3 digits, then 7 digits
    // Total 11 digits
    return RegExp(r'^0[0-9]{10}$').hasMatch(digits);
  }

  void _validateAndSubmit() {
    setState(() {
      _errorMessage = null;
    });

    if (_mobileController.text.trim().isEmpty) {
      setState(() {
        _errorMessage = 'Please enter your mobile number';
      });
      return;
    }

    if (!_isValidPhoneNumber(_mobileController.text)) {
      setState(() {
        _errorMessage = 'Please enter a valid mobile number';
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        // Show success dialog
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Account Found'),
            content: Text('Mobile number: ${_mobileController.text}'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context); // Go back to email search
                },
                child: const Text('OK'),
              ),
            ],
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
                    Navigator.pop(context);
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
                      'Find your account',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    
                    const SizedBox(height: 12),
                    
                    // Subtitle
                    const Text(
                      'Enter your mobile number.',
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
                              hintText: 'Mobile number',
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
                    
                    const SizedBox(height: 32),
                    
                    // Continue button
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
                                'Continue',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),
                    
                    const SizedBox(height: 12),
                    
                    // Search by email link
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context); // Go back to email search screen
                      },
                      child: const Text(
                        'Search by email address instead',
                        style: TextStyle(
                          color: Color(0xFF005FD5),
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 40),
                  ],
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
