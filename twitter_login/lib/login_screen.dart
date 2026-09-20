import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'landing_screen.dart';
import 'twitter_onboarding_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  bool _isButtonEnabled = false;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_validateInput);
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  bool _isValidEmail(String email) {
    // More permissive email validation
    return RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(email);
  }

  bool _isValidUsername(String username) {
    // Username validation: at least 1 character, letters, numbers, underscores
    return RegExp(r'^[a-zA-Z0-9_]{1,}$').hasMatch(username);
  }

  void _validateInput() {
    String input = _emailController.text.trim();
    
    if (input.isEmpty) {
      setState(() {
        _isButtonEnabled = false;
        _errorMessage = null;
      });
      return;
    }

    // Check if it's an email or username
    if (input.contains('@')) {
      if (!_isValidEmail(input)) {
        setState(() {
          _isButtonEnabled = false;
          _errorMessage = 'Please enter a valid email address';
        });
        return;
      }
    } else {
      if (!_isValidUsername(input)) {
        setState(() {
          _isButtonEnabled = false;
          _errorMessage = 'Username can only contain letters, numbers, and underscores';
        });
        return;
      }
    }

    setState(() {
      _isButtonEnabled = true;
      _errorMessage = null;
    });
  }

  void _handleSubmit() {
    if (!_isButtonEnabled) return;

    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const TwitterOnboardingScreen(),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Back button at top left
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.04,
                vertical: screenHeight * 0.02,
              ),
              child: Align(
                alignment: Alignment.topLeft,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: SvgPicture.asset(
                    'assets/images/backArrow.svg',
                    width: 24,
                    height: 24,
                    colorFilter: const ColorFilter.mode(
                      Color(0xFFF8FAFC),
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
            ),

            // X icon and "See what's happening" text - centered
            Padding(
              padding: EdgeInsets.only(top: screenHeight * 0.05),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/images/twitterIcon.svg',
                    width: 28,
                    height: 28,
                    colorFilter: const ColorFilter.mode(
                      Color(0xFFF8FAFC),
                      BlendMode.srcIn,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    "See what's happening",
                    style: TextStyle(
                      color: Color(0xFFF8FAFC),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(),

            // Middle content - vertically centered
            SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.04,
              ),
              child: Column(
                children: [
                  // "Continue with phone" button
                  _buildSocialButton(
                    icon: 'assets/images/phoneImage.svg',
                    text: 'Continue with phone',
                    screenWidth: screenWidth,
                  ),

                  const SizedBox(height: 12),

                  // "Continue with Google" button
                  _buildSocialButton(
                    icon: 'assets/images/googleIcon.svg',
                    text: 'Continue with Google',
                    screenWidth: screenWidth,
                  ),

                  const SizedBox(height: 12),

                  // "Continue with Apple" button
                  _buildSocialButton(
                    icon: 'assets/images/appleLogo.svg',
                    text: 'Continue with Apple',
                    screenWidth: screenWidth,
                  ),

                  const SizedBox(height: 24),

                  // Divider with "or"
                  Row(
                    children: [
                      const Expanded(
                        child: Divider(
                          color: Color(0xFF2F3336),
                          thickness: 1,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.04,
                        ),
                        child: const Text(
                          'or',
                          style: TextStyle(
                            color: Color(0xFF71767B),
                            fontSize: 14,
                          ),
                        ),
                      ),
                      const Expanded(
                        child: Divider(
                          color: Color(0xFF2F3336),
                          thickness: 1,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Email or username input
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF202327),
                          borderRadius: BorderRadius.circular(4),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white.withValues(alpha: 0.05),
                              blurRadius: 4,
                              spreadRadius: 0,
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: _emailController,
                          style: const TextStyle(
                            color: Color(0xFFF8FAFC),
                            fontSize: 16,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Email or username',
                            hintStyle: const TextStyle(
                              color: Color(0xFF71767B),
                              fontSize: 16,
                            ),
                            errorText: _errorMessage,
                            filled: true,
                            fillColor: Colors.transparent,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4),
                              borderSide: BorderSide.none,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4),
                              borderSide: BorderSide(
                                color: _errorMessage != null ? Colors.red : Colors.transparent,
                                width: _errorMessage != null ? 1 : 0,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4),
                              borderSide: const BorderSide(
                                color: Color(0xFF1D9BF0),
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Continue button
                  Container(
                    width: double.infinity,
                    height: 48,
                    decoration: BoxDecoration(
                      color: _isButtonEnabled
                          ? const Color(0xFFF8FAFC)
                          : const Color(0xFF4A4A4A),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withValues(alpha: 0.25),
                          blurRadius: _isButtonEnabled ? 12 : 8,
                          spreadRadius: _isButtonEnabled ? 2 : 1,
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: _isButtonEnabled && !_isLoading ? _handleSubmit : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        foregroundColor: Colors.black,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.black,
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
                ],
              ),
            ),

            const Spacer(),

            // Bottom section - legal disclaimer
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.04,
                vertical: screenHeight * 0.02,
              ),
              child: RichText(
                textAlign: TextAlign.center,
                text: const TextSpan(
                  style: TextStyle(
                    color: Color(0xFF71767B),
                    fontSize: 12,
                  ),
                  children: [
                    TextSpan(text: 'By continuing, you agree to our '),
                    TextSpan(
                      text: 'Terms of Service',
                      style: TextStyle(
                        color: Color(0xFFF8FAFC),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(text: ', '),
                    TextSpan(
                      text: 'Privacy Policy',
                      style: TextStyle(
                        color: Color(0xFFF8FAFC),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(text: ' and '),
                    TextSpan(
                      text: 'Cookie Use',
                      style: TextStyle(
                        color: Color(0xFFF8FAFC),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(text: '.'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialButton({
    required String icon,
    required String text,
    required double screenWidth,
  }) {
    return Container(
      width: double.infinity,
      height: 48,
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withValues(alpha: 0.15),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.black,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              icon,
              width: 22,
              height: 22,
            ),
            const SizedBox(width: 12),
            Text(
              text,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
