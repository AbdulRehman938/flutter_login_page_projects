import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'amazon_signup_screen.dart';

class AmazonLoginScreen extends StatefulWidget {
  const AmazonLoginScreen({super.key});

  @override
  State<AmazonLoginScreen> createState() => _AmazonLoginScreenState();
}

class _AmazonLoginScreenState extends State<AmazonLoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  bool _isButtonEnabled = false;
  bool _isLoading = false;

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
        // TODO: Navigate to password screen
        print('Continue button pressed');
      }
    });
  }

  void _handleCreateAccount() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AmazonSignupScreen(),
      ),
    );
  }

  void _handleNeedHelp() {
    print('Need help pressed');
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
                    horizontal: screenWidth * 0.06,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: screenHeight * 0.02),

                      // Amazon Logo
                      SvgPicture.asset(
                        'assets/amazon_logo.svg',
                        width: screenWidth * 0.3,
                      ),
                      SizedBox(height: screenHeight * 0.03),

                      // Sign in heading
                      const Text(
                        'Sign in',
                        style: TextStyle(
                          color: Color(0xFF000000),
                          fontSize: 28,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),

                      // Email/phone input label
                      const Text(
                        'Email or mobile phone number',
                        style: TextStyle(
                          color: Color(0xFF000000),
                          fontSize: 13,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.01),

                      // Email input field
                      TextField(
                        controller: _emailController,
                        style: const TextStyle(
                          color: Color(0xFF000000),
                          fontSize: 16,
                        ),
                        decoration: InputDecoration(
                          hintText: '',
                          hintStyle: const TextStyle(
                            color: Color(0xFF767676),
                            fontSize: 16,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 12,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(0),
                            borderSide: const BorderSide(
                              color: Color(0xFF888888),
                              width: 1,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(0),
                            borderSide: const BorderSide(
                              color: Color(0xFF888888),
                              width: 1,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(0),
                            borderSide: const BorderSide(
                              color: Color(0xFFFF9900),
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),

                      // Continue button
                      SizedBox(
                        width: double.infinity,
                        height: 32,
                        child: ElevatedButton(
                          onPressed: _isButtonEnabled && !_isLoading
                              ? _handleContinue
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _isButtonEnabled
                                ? const Color(0xFFF0C14B)
                                : const Color(0xFFE8E8E8),
                            foregroundColor: Colors.black,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
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
                                    fontSize: 13,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),

                      // "By continuing, you agree to Amazon's Conditions of Use and Privacy Notice."
                      const Text(
                        'By continuing, you agree to Amazon\'s Conditions of Use and Privacy Notice.',
                        style: TextStyle(
                          color: Color(0xFF000000),
                          fontSize: 11,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),

                      // Need help link
                      InkWell(
                        onTap: _handleNeedHelp,
                        child: const Text(
                          'Need help?',
                          style: TextStyle(
                            color: Color(0xFF0066C0),
                            fontSize: 13,
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.04),

                      // Divider
                      const Divider(
                        color: Color(0xFFDDDDDD),
                        thickness: 1,
                      ),
                      SizedBox(height: screenHeight * 0.04),

                      // New to Amazon section
                      const Text(
                        'New to Amazon?',
                        style: TextStyle(
                          color: Color(0xFF000000),
                          fontSize: 13,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.01),

                      // Create account button
                      SizedBox(
                        width: double.infinity,
                        height: 32,
                        child: OutlinedButton(
                          onPressed: _handleCreateAccount,
                          style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                            side: const BorderSide(
                              color: Color(0xFF888888),
                              width: 1,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          child: const Text(
                            'Create your Amazon account',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.04),

                      // Footer with legal links
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

  Widget _buildFooter(double screenWidth) {
    return Column(
      children: [
        const Divider(color: Color(0xFFDDDDDD)),
        SizedBox(height: screenWidth * 0.02),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: screenWidth * 0.02,
          runSpacing: screenWidth * 0.01,
          children: [
            _buildFooterLink('Conditions of Use'),
            _buildFooterLink('Privacy Notice'),
            _buildFooterLink('Help'),
          ],
        ),
        SizedBox(height: screenWidth * 0.02),
        const Text(
          '© 1996-2024, Amazon.com, Inc. or its affiliates',
          style: TextStyle(
            color: Color(0xFF000000),
            fontSize: 11,
          ),
          textAlign: TextAlign.center,
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
          color: Color(0xFF0066C0),
          fontSize: 11,
        ),
      ),
    );
  }
}