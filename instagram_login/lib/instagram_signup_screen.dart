import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'auth_service.dart';
import 'instagram_login_screen.dart';
import 'validation_utils.dart';

class InstagramSignupScreen extends StatefulWidget {
  const InstagramSignupScreen({super.key});

  @override
  State<InstagramSignupScreen> createState() => _InstagramSignupScreenState();
}

class _InstagramSignupScreenState extends State<InstagramSignupScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _agreeToTerms = false;
  String? _nameError;
  String? _usernameError;
  String? _passwordError;

  final GlobalKey<TooltipState> _nameTooltipKey = GlobalKey<TooltipState>();
  final GlobalKey<TooltipState> _usernameTooltipKey =
      GlobalKey<TooltipState>();
  final GlobalKey<TooltipState> _passwordTooltipKey =
      GlobalKey<TooltipState>();

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignup() async {
    final nameErr = ValidationUtils.validateName(_nameController.text);
    final usernameErr =
        ValidationUtils.validateUsername(_usernameController.text);
    final passErr =
        ValidationUtils.validateSignupPassword(_passwordController.text);

    setState(() {
      _nameError = nameErr;
      _usernameError = usernameErr;
      _passwordError = passErr;
    });

    if (nameErr != null) {
      Future.microtask(
          () => _nameTooltipKey.currentState?.ensureTooltipVisible());
    } else if (usernameErr != null) {
      Future.microtask(
          () => _usernameTooltipKey.currentState?.ensureTooltipVisible());
    } else if (passErr != null) {
      Future.microtask(
          () => _passwordTooltipKey.currentState?.ensureTooltipVisible());
    }

    if (nameErr != null || usernameErr != null || passErr != null) return;

    if (!_agreeToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please agree to the Terms of Use and Privacy Policy'),
          backgroundColor: Color(0xFFED4956),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    if (AuthService.instance.isFirebaseInitialized) {
      final rawUsername = _usernameController.text.trim();
      final email = rawUsername.contains('@') ? rawUsername : '$rawUsername@instagram.com';
      try {
        await AuthService.instance.registerWithEmailPassword(
          email: email,
          password: _passwordController.text,
          displayName: _nameController.text.trim(),
        );
        if (mounted) {
          setState(() => _isLoading = false);
          showSuccessToast(context, 'Account created successfully!');
          Navigator.of(context).popUntil((route) => route.isFirst);
        }
      } catch (e) {
        if (mounted) {
          setState(() => _isLoading = false);
          final errorMessage = AuthService.getReadableErrorMessage(e);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMessage),
              backgroundColor: const Color(0xFFED4956),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    } else {
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() => _isLoading = false);
          showSuccessToast(context, 'Account created successfully!');
          Future.delayed(const Duration(milliseconds: 500), () {
            if (mounted) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const InstagramLoginScreen(),
                ),
              );
            }
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1F1F22),
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
                  padding:
                      EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          SizedBox(height: screenHeight * 0.05),

                          // Back button
                          Align(
                            alignment: Alignment.centerLeft,
                            child: IconButton(
                              icon: const Icon(
                                Icons.arrow_back,
                                color: Color(0xFFF2F4D4),
                              ),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ),

                          SizedBox(height: screenHeight * 0.02),

                          // Instagram logo
                          SvgPicture.asset(
                            'assets/images/instagramLogo.svg',
                            width: screenWidth * 0.4,
                            colorFilter: const ColorFilter.mode(
                              Color(0xFFF2F4D4),
                              BlendMode.srcIn,
                            ),
                          ),

                          SizedBox(height: screenHeight * 0.04),

                          // Continue with Facebook button
                          Container(
                            width: double.infinity,
                            height: 44,
                            decoration: BoxDecoration(
                              color: const Color(0xFF4599FF),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: ElevatedButton(
                              onPressed: () => showUnderDevelopmentDialog(
                                  context, 'Continue with Facebook'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    'assets/images/facebookLogo.svg',
                                    width: 20,
                                    height: 20,
                                    colorFilter: const ColorFilter.mode(
                                      Colors.white,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  const Text(
                                    'Continue with Facebook',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          SizedBox(height: screenHeight * 0.03),

                          // OR separator
                          Row(
                            children: [
                              const Expanded(
                                child: Divider(
                                  color: Color(0xFF262626),
                                  thickness: 1,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12),
                                child: Text(
                                  'OR',
                                  style: TextStyle(
                                    color: Color(0xFF9FA4AB),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              const Expanded(
                                child: Divider(
                                  color: Color(0xFF262626),
                                  thickness: 1,
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: screenHeight * 0.03),

                          // Name input
                          TextField(
                            controller: _nameController,
                            style: const TextStyle(
                              color: Color(0xFFF2F4D4),
                              fontSize: 14,
                            ),
                            onChanged: (_) {
                              if (_nameError != null) {
                                setState(() => _nameError = null);
                              }
                            },
                            decoration: InputDecoration(
                              hintText: 'Full Name',
                              hintStyle: const TextStyle(
                                color: Color(0xFF9FA4AB),
                                fontSize: 14,
                              ),
                              filled: true,
                              fillColor: const Color(0xFF1A1A1A),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              ),
                              suffixIconConstraints: const BoxConstraints(
                                  minWidth: 0, minHeight: 0),
                              suffixIcon: _nameError != null
                                  ? ErrorTooltip(
                                      tooltipKey: _nameTooltipKey,
                                      message: _nameError!,
                                    )
                                  : null,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                                borderSide: BorderSide.none,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                                borderSide: _nameError != null
                                    ? const BorderSide(
                                        color: Color(0xFFED4956), width: 1)
                                    : BorderSide.none,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                                borderSide: const BorderSide(
                                  color: Color(0xFF4599FF),
                                  width: 1,
                                ),
                              ),
                            ),
                          ),

                          SizedBox(height: screenHeight * 0.02),

                          // Username input
                          TextField(
                            controller: _usernameController,
                            style: const TextStyle(
                              color: Color(0xFFF2F4D4),
                              fontSize: 14,
                            ),
                            onChanged: (_) {
                              if (_usernameError != null) {
                                setState(() => _usernameError = null);
                              }
                            },
                            decoration: InputDecoration(
                              hintText: 'Username',
                              hintStyle: const TextStyle(
                                color: Color(0xFF9FA4AB),
                                fontSize: 14,
                              ),
                              filled: true,
                              fillColor: const Color(0xFF1A1A1A),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              ),
                              suffixIconConstraints: const BoxConstraints(
                                  minWidth: 0, minHeight: 0),
                              suffixIcon: _usernameError != null
                                  ? ErrorTooltip(
                                      tooltipKey: _usernameTooltipKey,
                                      message: _usernameError!,
                                    )
                                  : null,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                                borderSide: BorderSide.none,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                                borderSide: _usernameError != null
                                    ? const BorderSide(
                                        color: Color(0xFFED4956), width: 1)
                                    : BorderSide.none,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                                borderSide: const BorderSide(
                                  color: Color(0xFF4599FF),
                                  width: 1,
                                ),
                              ),
                            ),
                          ),

                          SizedBox(height: screenHeight * 0.02),

                          // Password input
                          TextField(
                            controller: _passwordController,
                            obscureText: true,
                            style: const TextStyle(
                              color: Color(0xFFF2F4D4),
                              fontSize: 14,
                            ),
                            onChanged: (_) {
                              if (_passwordError != null) {
                                setState(() => _passwordError = null);
                              }
                            },
                            decoration: InputDecoration(
                              hintText: 'Password',
                              hintStyle: const TextStyle(
                                color: Color(0xFF9FA4AB),
                                fontSize: 14,
                              ),
                              filled: true,
                              fillColor: const Color(0xFF1A1A1A),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              ),
                              suffixIconConstraints: const BoxConstraints(
                                  minWidth: 0, minHeight: 0),
                              suffixIcon: _passwordError != null
                                  ? ErrorTooltip(
                                      tooltipKey: _passwordTooltipKey,
                                      message: _passwordError!,
                                    )
                                  : null,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                                borderSide: BorderSide.none,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                                borderSide: _passwordError != null
                                    ? const BorderSide(
                                        color: Color(0xFFED4956), width: 1)
                                    : BorderSide.none,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                                borderSide: const BorderSide(
                                  color: Color(0xFF4599FF),
                                  width: 1,
                                ),
                              ),
                            ),
                          ),

                          SizedBox(height: screenHeight * 0.02),

                          // Terms checkbox
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Checkbox(
                                value: _agreeToTerms,
                                onChanged: (value) {
                                  setState(() {
                                    _agreeToTerms = value ?? false;
                                  });
                                },
                                fillColor: WidgetStateProperty.resolveWith(
                                  (states) => _agreeToTerms
                                      ? const Color(0xFF4599FF)
                                      : const Color(0xFF262626),
                                ),
                                checkColor: Colors.white,
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => showUnderDevelopmentDialog(
                                      context,
                                      "Terms of Use and Privacy Policy"),
                                  child: const Text(
                                    "I agree to Instagram's Terms of Use and Privacy Policy",
                                    style: TextStyle(
                                      color: Color(0xFF9FA4AB),
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: screenHeight * 0.03),

                          // Sign up button
                          Container(
                            width: double.infinity,
                            height: 44,
                            decoration: BoxDecoration(
                              color: const Color(0xFF4599FF),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _handleSignup,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
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
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                          Colors.white,
                                        ),
                                      ),
                                    )
                                  : const Text(
                                      'Sign up',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                            ),
                          ),

                          SizedBox(height: screenHeight * 0.03),

                          // Already have an account link
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Already have an account?",
                                style: TextStyle(
                                  color: Color(0xFF9FA4AB),
                                  fontSize: 14,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const InstagramLoginScreen(),
                                    ),
                                  );
                                },
                                child: const Text(
                                  'Log in',
                                  style: TextStyle(
                                    color: Color(0xFF4599FF),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      // Bottom navigation bar
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: const BoxDecoration(
                          color: Color(0xFF1F1F22),
                          border: Border(
                            top: BorderSide(
                              color: Color(0xFF262626),
                              width: 1,
                            ),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildNavItem('assets/images/homeLogo.svg', false),
                            _buildNavItem(
                                'assets/images/searchLogo.svg', false),
                            _buildNavItem(
                                'assets/images/reelsLogo.svg', false),
                            _buildNavItem(
                                'assets/images/messageLogo.svg', false),
                            _buildNavItem(
                                'assets/images/profileLogo.svg', false),
                          ],
                        ),
                      ),
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

  Widget _buildNavItem(String assetPath, bool isActive) {
    return SvgPicture.asset(
      assetPath,
      width: 24,
      height: 24,
      colorFilter: ColorFilter.mode(
        isActive ? const Color(0xFFF2F4D4) : const Color(0xFF9FA4AB),
        BlendMode.srcIn,
      ),
    );
  }
}
