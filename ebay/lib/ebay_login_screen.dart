import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'ebay_signup_screen.dart';

class EbayLoginScreen extends StatefulWidget {
  const EbayLoginScreen({super.key});

  @override
  State<EbayLoginScreen> createState() => _EbayLoginScreenState();
}

class _EbayLoginScreenState extends State<EbayLoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  bool _isButtonEnabled = false;
  bool _isLoading = false;
  bool _staySignedIn = false;

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

  void _validateInput() {
    String email = _emailController.text.trim();

    setState(() {
      _isButtonEnabled = email.isNotEmpty;
    });
  }

  void _handleContinue() {
    if (!_isButtonEnabled) return;

    setState(() {
      _isLoading = true;
    });

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        // TODO: Navigate to next screen
        print('Continue button pressed');
      }
    });
  }

  void _handleSocialLogin(String provider) {
    print('Continue with $provider');
  }

  void _handleCreateAccount() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const EbaySignupScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final screenHeight = constraints.maxHeight;
            final screenWidth = constraints.maxWidth;

            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: screenHeight,
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.08,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: screenHeight * 0.04),

                      // eBay Logo
                      SvgPicture.asset(
                        'assets/ebayLogo.svg',
                        width: screenWidth * 0.25,
                      ),
                      SizedBox(height: screenHeight * 0.04),

                      // Sign in heading
                      const Text(
                        'Sign in to your account',
                        style: TextStyle(
                          color: Color(0xFF191927),
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.03),

                      // New to eBay section
                      Row(
                        children: [
                          const Text(
                            'New to eBay?',
                            style: TextStyle(
                              color: Color(0xFF191927),
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(width: 8),
                          TextButton(
                            onPressed: _handleCreateAccount,
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                                side: const BorderSide(
                                  color: Color(0xFF0964EC),
                                  width: 1,
                                ),
                              ),
                            ),
                            child: const Text(
                              'Create account',
                              style: TextStyle(
                                color: Color(0xFF0964EC),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: screenHeight * 0.03),

                      // Email input
                      TextField(
                        controller: _emailController,
                        style: const TextStyle(
                          color: Color(0xFF191927),
                          fontSize: 16,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Email or username',
                          hintStyle: const TextStyle(
                            color: Color(0xFF767676),
                            fontSize: 16,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Color(0xFFD3D3D3),
                              width: 1,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Color(0xFFD3D3D3),
                              width: 1,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Color(0xFF0964EC),
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),

                      // Continue button
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: _isButtonEnabled && !_isLoading
                              ? _handleContinue
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _isButtonEnabled
                                ? const Color(0xFF0964EC)
                                : const Color(0xFFB3D1FF),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
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
                      SizedBox(height: screenHeight * 0.03),

                      // OR separator
                      Row(
                        children: [
                          const Expanded(
                            child: Divider(
                              color: Color(0xFFD3D3D3),
                              thickness: 1,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              'or',
                              style: TextStyle(
                                color: const Color(0xFF191927).withOpacity(0.6),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const Expanded(
                            child: Divider(
                              color: Color(0xFFD3D3D3),
                              thickness: 1,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: screenHeight * 0.03),

                      // Social login buttons
                      _buildSocialButton(
                        'assets/googleLogo.png',
                        'Continue with Google',
                        () => _handleSocialLogin('Google'),
                      ),
                      SizedBox(height: screenHeight * 0.015),

                      _buildSocialButton(
                        'assets/appleLogo.png',
                        'Continue with Apple',
                        () => _handleSocialLogin('Apple'),
                      ),
                      SizedBox(height: screenHeight * 0.015),

                      _buildSocialButton(
                        'assets/facebookLogo.png',
                        'Continue with Facebook',
                        () => _handleSocialLogin('Facebook'),
                      ),
                      SizedBox(height: screenHeight * 0.03),

                      // Stay signed in checkbox
                      Row(
                        children: [
                          Checkbox(
                            value: _staySignedIn,
                            onChanged: (value) {
                              setState(() {
                                _staySignedIn = value ?? false;
                              });
                            },
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            visualDensity: VisualDensity.compact,
                            activeColor: const Color(0xFF0964EC),
                          ),
                          const Text(
                            'Stay signed in',
                            style: TextStyle(
                              color: Color(0xFF191927),
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.info_outline,
                            size: 16,
                            color: Color(0xFF767676),
                          ),
                        ],
                      ),
                      SizedBox(height: screenHeight * 0.04),

                      // Footer
                      _buildFooter(screenWidth),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSocialButton(String iconPath, String text, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: const Color(0xFF191927),
          side: const BorderSide(
            color: Color(0xFFD3D3D3),
            width: 1,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              iconPath,
              width: 20,
              height: 20,
            ),
            const SizedBox(width: 12),
            Text(
              text,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter(double screenWidth) {
    return Column(
      children: [
        const Divider(color: Color(0xFFD3D3D3)),
        SizedBox(height: screenWidth * 0.03),
        const Text(
          'Copyright © 1995-2026 eBay Inc. All Rights Reserved.',
          style: TextStyle(
            color: Color(0xFF191927),
            fontSize: 12,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: screenWidth * 0.02),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: screenWidth * 0.02,
          runSpacing: screenWidth * 0.01,
          children: [
            _buildFooterLink('Accessibility'),
            _buildFooterLink('User Agreement'),
            _buildFooterLink('Privacy'),
            _buildFooterLink('Consumer Health Data'),
            _buildFooterLink('Payments Terms of Use'),
            _buildFooterLink('Cookies'),
            _buildFooterLink('CA Privacy Notice'),
            _buildFooterLink('Your Privacy Choices'),
            _buildFooterLink('AdChoice'),
          ],
        ),
        SizedBox(height: screenWidth * 0.03),
      ],
    );
  }

  Widget _buildFooterLink(String text) {
    return InkWell(
      onTap: () {
        print('$text pressed');
      },
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xFF0964EC),
          fontSize: 12,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }
}