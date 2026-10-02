import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'amazon_signup_screen.dart';
import 'auth_service.dart';
import 'validation_utils.dart';

class AmazonLoginScreen extends StatefulWidget {
  const AmazonLoginScreen({super.key});

  @override
  State<AmazonLoginScreen> createState() => _AmazonLoginScreenState();
}

class _AmazonLoginScreenState extends State<AmazonLoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final GlobalKey<TooltipState> _emailTooltipKey = GlobalKey<TooltipState>();

  String? _emailError;
  bool _hasSubmitted = false;
  bool _isLoading = false;

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
      final error = ValidationUtils.validateLoginInput(_emailController.text);
      if (error != _emailError) {
        setState(() {
          _emailError = error;
        });
      }
    }
  }

  void _onFocusChanged() {
    if (!_emailFocusNode.hasFocus && _emailController.text.isNotEmpty) {
      final error = ValidationUtils.validateLoginInput(_emailController.text);
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
    final error = ValidationUtils.validateLoginInput(_emailController.text);
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
      builder: (sheetContext) => AmazonPasswordSheet(
        email: email,
        onSignInSuccess: () {
          showSuccessToast(context, 'Sign-in successful!');
        },
      ),
    );
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
    showUnderDevelopmentDialog(context, 'Need help?');
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
                        focusNode: _emailFocusNode,
                        keyboardType: TextInputType.emailAddress,
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
                          suffixIconConstraints: const BoxConstraints(
                            minWidth: 40,
                            minHeight: 48,
                            maxWidth: 48,
                            maxHeight: 48,
                          ),
                          suffixIcon: _emailError != null
                              ? AmazonErrorTooltip(
                                  tooltipKey: _emailTooltipKey,
                                  message: _emailError!,
                                )
                              : null,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(0),
                            borderSide: BorderSide(
                              color: _emailError != null
                                  ? const Color(0xFFC40000)
                                  : const Color(0xFF888888),
                              width: 1,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(0),
                            borderSide: BorderSide(
                              color: _emailError != null
                                  ? const Color(0xFFC40000)
                                  : const Color(0xFF888888),
                              width: 1,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(0),
                            borderSide: BorderSide(
                              color: _emailError != null
                                  ? const Color(0xFFC40000)
                                  : const Color(0xFFFF9900),
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
                          onPressed: !_isLoading ? _handleContinue : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFF0C14B),
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
                      Wrap(
                        children: [
                          const Text(
                            'By continuing, you agree to Amazon\'s ',
                            style: TextStyle(
                              color: Color(0xFF000000),
                              fontSize: 11,
                            ),
                          ),
                          InkWell(
                            onTap: () => showUnderDevelopmentDialog(context, 'Conditions of Use'),
                            child: const Text(
                              'Conditions of Use',
                              style: TextStyle(
                                color: Color(0xFF0066C0),
                                fontSize: 11,
                              ),
                            ),
                          ),
                          const Text(
                            ' and ',
                            style: TextStyle(
                              color: Color(0xFF000000),
                              fontSize: 11,
                            ),
                          ),
                          InkWell(
                            onTap: () => showUnderDevelopmentDialog(context, 'Privacy Notice'),
                            child: const Text(
                              'Privacy Notice',
                              style: TextStyle(
                                color: Color(0xFF0066C0),
                                fontSize: 11,
                              ),
                            ),
                          ),
                          const Text(
                            '.',
                            style: TextStyle(
                              color: Color(0xFF000000),
                              fontSize: 11,
                            ),
                          ),
                        ],
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
        showUnderDevelopmentDialog(context, text);
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

/// Amazon styled password bottom sheet for entering credentials.
class AmazonPasswordSheet extends StatefulWidget {
  final String email;
  final VoidCallback onSignInSuccess;

  const AmazonPasswordSheet({
    super.key,
    required this.email,
    required this.onSignInSuccess,
  });

  @override
  State<AmazonPasswordSheet> createState() => _AmazonPasswordSheetState();
}

class _AmazonPasswordSheetState extends State<AmazonPasswordSheet> {
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
                    color: Color(0xFF0066C0),
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
                borderRadius: BorderRadius.circular(4),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: const BorderSide(
                  color: Color(0xFFFF9900),
                  width: 2,
                ),
              ),
            ),
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            height: 38,
            child: ElevatedButton(
              onPressed: !_isLoading ? _handleSignIn : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF0C14B),
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              child: _isLoading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                      ),
                    )
                  : const Text(
                      'Sign in',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}