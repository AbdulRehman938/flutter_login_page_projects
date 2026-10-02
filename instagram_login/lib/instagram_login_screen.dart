import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'auth_service.dart';
import 'instagram_signup_screen.dart';
import 'validation_utils.dart';

class InstagramLoginScreen extends StatefulWidget {
  const InstagramLoginScreen({super.key});

  @override
  State<InstagramLoginScreen> createState() => _InstagramLoginScreenState();
}

class _InstagramLoginScreenState extends State<InstagramLoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _emailError;
  String? _passwordError;

  final GlobalKey<TooltipState> _emailTooltipKey = GlobalKey<TooltipState>();
  final GlobalKey<TooltipState> _passwordTooltipKey = GlobalKey<TooltipState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    final emailErr = ValidationUtils.validateLoginInput(_emailController.text);
    final passErr = ValidationUtils.validatePassword(_passwordController.text);

    setState(() {
      _emailError = emailErr;
      _passwordError = passErr;
    });

    if (emailErr != null) {
      Future.microtask(() => _emailTooltipKey.currentState?.ensureTooltipVisible());
    } else if (passErr != null) {
      Future.microtask(() => _passwordTooltipKey.currentState?.ensureTooltipVisible());
    }

    if (emailErr != null || passErr != null) return;

    setState(() => _isLoading = true);

    if (AuthService.instance.isFirebaseInitialized) {
      final rawInput = _emailController.text.trim();
      final email = rawInput.contains('@') ? rawInput : '$rawInput@instagram.com';
      try {
        await AuthService.instance.signInWithEmailPassword(
          email: email,
          password: _passwordController.text,
        );
        if (mounted) {
          setState(() => _isLoading = false);
          showSuccessToast(context, 'Logged in successfully!');
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
          showSuccessToast(context, 'Logged in successfully!');
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
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Top section
                      Column(
                        children: [
                          SizedBox(height: screenHeight * 0.02),

                          // Language selector
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'English',
                                style: TextStyle(
                                  color: Color(0xFFF2F4D4),
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Icon(
                                Icons.keyboard_arrow_down,
                                color: const Color(0xFFF2F4D4),
                                size: 20,
                              ),
                            ],
                          ),
                          SizedBox(height: screenHeight * 0.04),

                          // Instagram logo
                          SvgPicture.asset(
                            'assets/images/instagramLogo.svg',
                            width: screenWidth * 0.5,
                            colorFilter: const ColorFilter.mode(
                              Color(0xFFF2F4D4),
                              BlendMode.srcIn,
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.03),

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
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 12),
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

                          // Phone/username/email input — no errorText to avoid layout shift
                          TextField(
                            controller: _emailController,
                            style: const TextStyle(
                              color: Color(0xFFF2F4D4),
                              fontSize: 14,
                            ),
                            onChanged: (_) {
                              if (_emailError != null) {
                                setState(() => _emailError = null);
                              }
                            },
                            decoration: InputDecoration(
                              hintText: 'Phone number, username, or email',
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
                              suffixIconConstraints:
                                  const BoxConstraints(minWidth: 0, minHeight: 0),
                              suffixIcon: _emailError != null
                                  ? ErrorTooltip(
                                      tooltipKey: _emailTooltipKey,
                                      message: _emailError!,
                                    )
                                  : null,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                                borderSide: BorderSide.none,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                                borderSide: _emailError != null
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
                              suffixIconConstraints:
                                  const BoxConstraints(minWidth: 0, minHeight: 0),
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
                          SizedBox(height: screenHeight * 0.01),

                          // Forgot password link
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () => showUnderDevelopmentDialog(
                                  context, 'Forgot password?'),
                              child: const Text(
                                'Forgot password?',
                                style: TextStyle(
                                  color: Color(0xFF4599FF),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.02),

                          // Log in button
                          Container(
                            width: double.infinity,
                            height: 44,
                            decoration: BoxDecoration(
                              color: const Color(0xFF4599FF),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _handleLogin,
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
                                      'Log in',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.03),

                          // Sign up link
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Don't have an account?",
                                style: TextStyle(
                                  color: Color(0xFF9FA4AB),
                                  fontSize: 14,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const InstagramSignupScreen(),
                                    ),
                                  );
                                },
                                child: const Text(
                                  'Sign up',
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

                      // Bottom section
                      Column(
                        children: [
                          GestureDetector(
                            onTap: () => showUnderDevelopmentDialog(
                                context, 'Terms of Use and Privacy Policy'),
                            child: const Text(
                              "By continuing, you agree to Instagram's Terms of Use and Privacy Policy.",
                              style: TextStyle(
                                color: Color(0xFF9FA4AB),
                                fontSize: 12,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.02),

                          // Meta branding
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(width: 4),
                              SvgPicture.asset(
                                'assets/images/metaLogo.svg',
                                width: 90,
                                height: 30,
                                colorFilter: const ColorFilter.mode(
                                  Color(0xFFF2F4D4),
                                  BlendMode.srcIn,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: screenHeight * 0.02),

                          // Bottom navigation bar
                          Container(
                            padding:
                                const EdgeInsets.symmetric(vertical: 12),
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
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceAround,
                              children: [
                                _buildNavItem(
                                    'assets/images/homeLogo.svg', true),
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
