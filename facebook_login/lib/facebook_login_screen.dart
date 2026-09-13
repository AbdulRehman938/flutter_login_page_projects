import 'package:flutter/material.dart';
import 'get_started_screen.dart';
import 'find_account_screen.dart';

class FacebookLoginScreen extends StatefulWidget {
  const FacebookLoginScreen({super.key});

  @override
  State<FacebookLoginScreen> createState() => _FacebookLoginScreenState();
}

class _FacebookLoginScreenState extends State<FacebookLoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _emailError;
  String? _passwordError;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool _isValidEmail(String email) {
    // Basic email validation
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  bool _isValidPhone(String phone) {
    // Basic phone validation (at least 10 digits)
    String digits = phone.replaceAll(RegExp(r'\D'), '');
    return digits.length >= 10;
  }

  void _validateAndLogin() {
    setState(() {
      _emailError = null;
      _passwordError = null;
    });

    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (email.isEmpty) {
      setState(() {
        _emailError = 'Please enter your mobile number or email';
      });
      return;
    }

    if (!_isValidEmail(email) && !_isValidPhone(email)) {
      setState(() {
        _emailError = 'Please enter a valid mobile number or email';
      });
      return;
    }

    if (password.isEmpty) {
      setState(() {
        _passwordError = 'Please enter your password';
      });
      return;
    }

    if (password.length < 6) {
      setState(() {
        _passwordError = 'Password must be at least 6 characters';
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Simulate login
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        // Navigate to onboarding screen for demo
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const GetStartedScreen(),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Language selector - centered
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Center(
                child: Text(
                  'English (UK)',
                  style: TextStyle(
                    color: const Color(0xFF65676B),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            
            // Scrollable content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    const SizedBox(height: 160),
                    
                    // Facebook Logo
                    Image.asset(
                      'assets/images/facebookLogo.png',
                      width: 60,
                      height: 60,
                    ),
                    
                    const SizedBox(height: 160),
                    
                    // Input fields
                    Column(
                      children: [
                        _buildTextField(
                          'Mobile number or email address',
                          controller: _emailController,
                          errorText: _emailError,
                        ),
                        const SizedBox(height: 12),
                        _buildTextField(
                          'Password',
                          controller: _passwordController,
                          errorText: _passwordError,
                          obscureText: true,
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Log in button
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _validateAndLogin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF005FD5),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
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
                                'Log in',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Forgotten password link
                    GestureDetector(
                      onTap: () {},
                      child: const Text(
                        'Forgotten password?',
                        style: TextStyle(
                          color: Color(0xFF005FD5),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Divider
                    Row(
                      children: [
                        const Expanded(
                          child: Divider(
                            color: Color(0xFFE4E6EB),
                            thickness: 1,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            'OR',
                            style: TextStyle(
                              color: const Color(0xFF65676B),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const Expanded(
                          child: Divider(
                            color: Color(0xFFE4E6EB),
                            thickness: 1,
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Create new account button
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const GetStartedScreen(),
                            ),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF005FD5),
                          side: const BorderSide(
                            color: Color(0xFF005FD5),
                            width: 1,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Create new account',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            
            // Bottom footer - always at bottom
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Column(
                children: [
                  // Meta Logo
                  Image.asset(
                    'assets/images/metaLogo.png',
                    width: 80,
                    height: 20,
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Footer links
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildFooterLink(context, 'About'),
                      const SizedBox(width: 16),
                      _buildFooterLink(context, 'Help'),
                      const SizedBox(width: 16),
                      _buildFooterLink(context, 'More'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String placeholder, {TextEditingController? controller, String? errorText, bool obscureText = false}) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: placeholder,
        hintStyle: const TextStyle(
          color: Color(0xFF65676B),
          fontSize: 16,
        ),
        errorText: errorText,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
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
            color: errorText != null ? Colors.red : const Color(0xFFDADDE1),
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
      ),
      onChanged: (value) {
        // Clear error when user types
        if (placeholder.contains('Mobile number') && _emailError != null) {
          setState(() {
            _emailError = null;
          });
        } else if (placeholder.contains('Password') && _passwordError != null) {
          setState(() {
            _passwordError = null;
          });
        }
      },
    );
  }

  Widget _buildFooterLink(BuildContext context, String text) {
    return GestureDetector(
      onTap: () {
        if (text == 'Help') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const FindAccountScreen(),
            ),
          );
        }
      },
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xFF65676B),
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
