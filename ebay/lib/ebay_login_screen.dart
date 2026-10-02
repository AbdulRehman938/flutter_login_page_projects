import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'auth_service.dart';
import 'ebay_signup_screen.dart';
import 'validation_utils.dart';

class EbayLoginScreen extends StatefulWidget {
  const EbayLoginScreen({super.key});

  @override
  State<EbayLoginScreen> createState() => _EbayLoginScreenState();
}

class _EbayLoginScreenState extends State<EbayLoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final GlobalKey<TooltipState> _emailTooltipKey = GlobalKey<TooltipState>();

  String? _emailError;
  bool _hasSubmitted = false;
  bool _isLoading = false;
  bool _staySignedIn = false;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_onTextChanged);
    _emailFocusNode.addListener(_onFocusChanged);
  }

  @override
  void dispose() {
    _emailController.removeListener(_onTextChanged);
    _emailFocusNode.removeListener(_onFocusChanged);
    _emailController.dispose();
    _emailFocusNode.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    if (_hasSubmitted || _emailError != null) {
      final error = ValidationUtils.validateEmailOrUsername(_emailController.text);
      if (error != _emailError) {
        setState(() {
          _emailError = error;
        });
      }
    }
  }

  void _onFocusChanged() {
    if (!_emailFocusNode.hasFocus && _emailController.text.isNotEmpty) {
      final error = ValidationUtils.validateEmailOrUsername(_emailController.text);
      if (error != _emailError) {
        setState(() {
          _emailError = error;
        });
        if (error != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _emailTooltipKey.currentState?.ensureTooltipVisible();
          });
        }
      }
    }
  }

  void _handleContinue() {
    _hasSubmitted = true;
    final error = ValidationUtils.validateEmailOrUsername(_emailController.text);
    if (error != null) {
      setState(() {
        _emailError = error;
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _emailTooltipKey.currentState?.ensureTooltipVisible();
      });
      return;
    }

    setState(() {
      _emailError = null;
    });

    if (AuthService.instance.isFirebaseInitialized) {
      _showPasswordModal(_emailController.text.trim());
    } else {
      setState(() {
        _isLoading = true;
      });
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
          showSuccessToast(context, 'Sign-in successful!');
          debugPrint('Continue button pressed');
        }
      });
    }
  }

  void _showPasswordModal(String email) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (sheetContext) => EbayPasswordSheet(
        email: email,
        onSignInSuccess: () {
          showSuccessToast(context, 'Sign-in successful!');
        },
      ),
    );
  }

  void _handleSocialLogin(String provider) {
    showUnderDevelopmentDialog(context, 'Continue with $provider');
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
                        focusNode: _emailFocusNode,
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
                          suffixIconConstraints: const BoxConstraints(
                            minWidth: 40,
                            minHeight: 48,
                            maxWidth: 48,
                            maxHeight: 48,
                          ),
                          suffixIcon: _emailError != null
                              ? EbayErrorTooltip(
                                  tooltipKey: _emailTooltipKey,
                                  message: _emailError!,
                                )
                              : null,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: _emailError != null
                                  ? const Color(0xFFC40000)
                                  : const Color(0xFFD3D3D3),
                              width: 1,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: _emailError != null
                                  ? const Color(0xFFC40000)
                                  : const Color(0xFFD3D3D3),
                              width: 1,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: _emailError != null
                                  ? const Color(0xFFC40000)
                                  : const Color(0xFF0964EC),
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
                          onPressed: !_isLoading ? _handleContinue : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0964EC),
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
                                color: const Color(0xFF191927).withValues(alpha: 0.6),
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
                          InkWell(
                            onTap: () => showUnderDevelopmentDialog(context, 'Stay signed in info'),
                            child: const Icon(
                              Icons.info_outline,
                              size: 16,
                              color: Color(0xFF767676),
                            ),
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
        showUnderDevelopmentDialog(context, text);
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

/// eBay styled password bottom sheet for entering credentials.
class EbayPasswordSheet extends StatefulWidget {
  final String email;
  final VoidCallback onSignInSuccess;

  const EbayPasswordSheet({
    super.key,
    required this.email,
    required this.onSignInSuccess,
  });

  @override
  State<EbayPasswordSheet> createState() => _EbayPasswordSheetState();
}

class _EbayPasswordSheetState extends State<EbayPasswordSheet> {
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;
  String? _passwordError;

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignIn() async {
    final error = ValidationUtils.validatePassword(_passwordController.text);
    if (error != null) {
      setState(() {
        _passwordError = error;
      });
      return;
    }

    setState(() {
      _passwordError = null;
      _isLoading = true;
    });

    try {
      await AuthService.instance.signInWithEmailPassword(
        email: widget.email,
        password: _passwordController.text,
      );
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        Navigator.pop(context);
        widget.onSignInSuccess();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        final errorMessage = AuthService.getReadableErrorMessage(e);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: const Color(0xFFC40000),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: bottomInset + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Enter Password',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                widget.email,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF555555),
                ),
              ),
              const SizedBox(width: 8),
              InkWell(
                onTap: () => Navigator.pop(context),
                child: const Text(
                  'Change',
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF0964EC),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            decoration: InputDecoration(
              labelText: 'Password',
              errorText: _passwordError,
              filled: true,
              fillColor: Colors.white,
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  size: 20,
                  color: const Color(0xFF555555),
                ),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: Color(0xFF0064D2),
                  width: 2,
                ),
              ),
            ),
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            height: 44,
            child: ElevatedButton(
              onPressed: !_isLoading ? _handleSignIn : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0064D2),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(22),
                ),
              ),
              child: _isLoading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Text(
                      'Sign in',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}