import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EbaySignupScreen extends StatefulWidget {
  const EbaySignupScreen({super.key});

  @override
  State<EbaySignupScreen> createState() => _EbaySignupScreenState();
}

class _EbaySignupScreenState extends State<EbaySignupScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isButtonEnabled = false;
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _staySignedIn = false;

  @override
  void initState() {
    super.initState();
    _firstNameController.addListener(_validateInput);
    _lastNameController.addListener(_validateInput);
    _emailController.addListener(_validateInput);
    _passwordController.addListener(_validateInput);
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _validateInput() {
    String firstName = _firstNameController.text.trim();
    String lastName = _lastNameController.text.trim();
    String email = _emailController.text.trim();
    String password = _passwordController.text;

    setState(() {
      _isButtonEnabled = firstName.isNotEmpty &&
          lastName.isNotEmpty &&
          email.isNotEmpty &&
          password.isNotEmpty;
    });
  }

  void _handleCreateAccount() {
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
        print('Account created successfully');
      }
    });
  }

  void _handleSocialSignup(String provider) {
    print('Continue with $provider');
  }

  void _handleBusinessAccount() {
    print('Create business account pressed');
  }

  void _handleSignIn() {
    Navigator.pop(context);
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
                      SizedBox(height: screenHeight * 0.02),

                      // Header with logo and sign in link
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // eBay Logo
                          SvgPicture.asset(
                            'assets/ebayLogo.svg',
                            width: screenWidth * 0.2,
                          ),
                          // Sign in link
                          TextButton(
                            onPressed: _handleSignIn,
                            child: const Text(
                              'Sign in',
                              style: TextStyle(
                                color: Color(0xFF0964EC),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: screenHeight * 0.04),

                      // Create an account heading
                      const Text(
                        'Create an account',
                        style: TextStyle(
                          color: Color(0xFF191927),
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.03),

                      // Business account section
                      Row(
                        children: [
                          const Text(
                            'Are you a business or nonprofit?',
                            style: TextStyle(
                              color: Color(0xFF191927),
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(width: 4),
                          TextButton(
                            onPressed: _handleBusinessAccount,
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: const Text(
                              'Create a business account',
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

                      // Continue with section
                      const Text(
                        'Continue with:',
                        style: TextStyle(
                          color: Color(0xFF191927),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),

                      // Social signup buttons (circular icons)
                      Row(
                        children: [
                          _buildCircularSocialButton(
                            'assets/googleLogo.png',
                            () => _handleSocialSignup('Google'),
                          ),
                          SizedBox(width: screenWidth * 0.04),
                          _buildCircularSocialButton(
                            'assets/appleLogo.png',
                            () => _handleSocialSignup('Apple'),
                          ),
                          SizedBox(width: screenWidth * 0.04),
                          _buildCircularSocialButton(
                            'assets/facebookLogo.png',
                            () => _handleSocialSignup('Facebook'),
                          ),
                        ],
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

                      // First name input
                      _buildTextField(
                        controller: _firstNameController,
                        hintText: 'First name',
                      ),
                      SizedBox(height: screenHeight * 0.02),

                      // Last name input
                      _buildTextField(
                        controller: _lastNameController,
                        hintText: 'Last name',
                      ),
                      SizedBox(height: screenHeight * 0.02),

                      // Email input
                      _buildTextField(
                        controller: _emailController,
                        hintText: 'Email',
                      ),
                      SizedBox(height: screenHeight * 0.02),

                      // Password input with show/hide
                      TextField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        style: const TextStyle(
                          color: Color(0xFF191927),
                          fontSize: 16,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Password',
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
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              color: const Color(0xFF767676),
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.03),

                      // Legal disclaimer
                      RichText(
                        text: const TextSpan(
                          style: TextStyle(
                            color: Color(0xFF191927),
                            fontSize: 12,
                          ),
                          children: [
                            TextSpan(text: 'By Creating an account, you agree to our '),
                            TextSpan(
                              text: 'User Agreement',
                              style: TextStyle(
                                color: Color(0xFF0964EC),
                                decoration: TextDecoration.underline,
                              ),
                            ),
                            TextSpan(text: ' and acknowledge reading our '),
                            TextSpan(
                              text: 'User Privacy Notice.',
                              style: TextStyle(
                                color: Color(0xFF0964EC),
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.03),

                      // Create account button
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: _isButtonEnabled && !_isLoading
                              ? _handleCreateAccount
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
                                  'Create account',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ),
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

                      // Help icon at bottom right
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color(0xFFD3D3D3),
                              width: 1,
                            ),
                          ),
                          child: const Icon(
                            Icons.help_outline,
                            size: 24,
                            color: Color(0xFF191927),
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
  }) {
    return TextField(
      controller: controller,
      style: const TextStyle(
        color: Color(0xFF191927),
        fontSize: 16,
      ),
      decoration: InputDecoration(
        hintText: hintText,
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
    );
  }

  Widget _buildCircularSocialButton(String iconPath, VoidCallback onPressed) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: const Color(0xFFD3D3D3),
            width: 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Image.asset(
            iconPath,
            width: 24,
            height: 24,
          ),
        ),
      ),
    );
  }
}